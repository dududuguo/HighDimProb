#!/usr/bin/env python3
"""Regression tests for the append-only Judge ledger."""

from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path
from unittest import mock


SCRIPT = Path(__file__).with_name("judge_append_only_check.py")
SPEC = importlib.util.spec_from_file_location("judge_append_only_check", SCRIPT)
assert SPEC is not None and SPEC.loader is not None
judge = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(judge)


class JudgeAppendOnlyCheckTest(unittest.TestCase):
    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        (self.root / "HighDimProbJudge/Area").mkdir(parents=True)
        self.write_leaf("HighDimProbJudge/Area/FirstUse.lean", "#check Nat.add\n")
        (self.root / "HighDimProbJudge.lean").write_text(
            "import HighDimProbJudge.Area.FirstUse\n", encoding="utf-8"
        )
        self.manifest = {
            "HighDimProbJudge/Area/FirstUse.lean": judge.sha256_file(
                self.root / "HighDimProbJudge/Area/FirstUse.lean"
            )
        }

    def tearDown(self) -> None:
        self.temp.cleanup()

    def write_leaf(self, relative: str, content: str) -> None:
        path = self.root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")

    def test_unchanged_baseline_passes(self) -> None:
        self.assertEqual(judge.validate_tree(self.root, self.manifest), [])

    def test_registered_addition_passes(self) -> None:
        second = "HighDimProbJudge/Area/SecondUse.lean"
        self.write_leaf(second, "#check Nat.mul\n")
        (self.root / "HighDimProbJudge.lean").write_text(
            "import HighDimProbJudge.Area.FirstUse\n"
            "import HighDimProbJudge.Area.SecondUse\n",
            encoding="utf-8",
        )
        candidate = dict(self.manifest)
        candidate[second] = judge.sha256_file(self.root / second)
        self.assertEqual(judge.validate_tree(self.root, candidate), [])
        self.assertEqual(judge.compare_locked_entries(self.manifest, candidate), [])

    def test_locked_mutation_is_rejected(self) -> None:
        self.write_leaf("HighDimProbJudge/Area/FirstUse.lean", "#check Nat.mul\n")
        errors = judge.validate_tree(self.root, self.manifest)
        self.assertTrue(any("was modified" in error for error in errors))

    def test_locked_deletion_is_rejected(self) -> None:
        (self.root / "HighDimProbJudge/Area/FirstUse.lean").unlink()
        errors = judge.validate_tree(self.root, self.manifest)
        self.assertTrue(any("is missing" in error for error in errors))

    def test_old_hash_rewrite_is_rejected(self) -> None:
        candidate = dict(self.manifest)
        candidate["HighDimProbJudge/Area/FirstUse.lean"] = "0" * 64
        errors = judge.compare_locked_entries(self.manifest, candidate)
        self.assertEqual(
            errors,
            ["locked manifest hash was changed: HighDimProbJudge/Area/FirstUse.lean"],
        )

    def test_malformed_root_is_rejected(self) -> None:
        (self.root / "HighDimProbJudge.lean").write_text(
            "-- imports\nimport HighDimProbJudge.Area.FirstUse\n", encoding="utf-8"
        )
        errors = judge.validate_tree(self.root, self.manifest)
        self.assertTrue(any("expected one exact" in error for error in errors))

    def test_unregistered_addition_is_rejected(self) -> None:
        self.write_leaf("HighDimProbJudge/Area/SecondUse.lean", "#check Nat.mul\n")
        errors = judge.validate_tree(self.root, self.manifest)
        self.assertTrue(any("unregistered Judge file" in error for error in errors))

    def test_existing_path_cannot_be_readded(self) -> None:
        judge.write_manifest(self.root, self.manifest)
        with mock.patch.object(judge, "git_manifest", return_value=(self.manifest, [])):
            errors = judge.add_files(
                self.root, ["HighDimProbJudge/Area/FirstUse.lean"]
            )
        self.assertTrue(any("cannot be re-added" in error for error in errors))

    def test_add_command_registers_file_and_import(self) -> None:
        judge.write_manifest(self.root, self.manifest)
        second = "HighDimProbJudge/Area/SecondUse.lean"
        self.write_leaf(second, "#check Nat.mul\n")
        with mock.patch.object(judge, "git_manifest", return_value=(self.manifest, [])):
            errors = judge.add_files(self.root, [second])
        self.assertEqual(errors, [])
        updated, parse_errors = judge.read_manifest(self.root)
        self.assertEqual(parse_errors, [])
        assert updated is not None
        self.assertIn(second, updated)
        self.assertEqual(
            (self.root / "HighDimProbJudge.lean").read_text(encoding="utf-8"),
            "import HighDimProbJudge.Area.FirstUse\n"
            "import HighDimProbJudge.Area.SecondUse\n",
        )

    def test_unsafe_manifest_path_is_rejected(self) -> None:
        text = '{"schema_version": 1, "files": {"HighDimProbJudge/../x.lean": "' + "0" * 64 + '"}}'
        manifest, errors = judge.parse_manifest_text(text, "test")
        self.assertIsNone(manifest)
        self.assertTrue(any("not normalized" in error for error in errors))

    def test_non_module_filename_is_rejected(self) -> None:
        error = judge.validate_judge_path("HighDimProbJudge/Area/Bad-Name.lean")
        self.assertIsNotNone(error)
        assert error is not None
        self.assertIn("does not form a Lean module name", error)

    def test_duplicate_manifest_path_is_rejected(self) -> None:
        path = "HighDimProbJudge/Area/FirstUse.lean"
        digest = "0" * 64
        text = (
            '{"schema_version": 1, "files": {'
            f'"{path}": "{digest}", "{path}": "{digest}"'
            "}}"
        )
        manifest, errors = judge.parse_manifest_text(text, "test")
        self.assertIsNone(manifest)
        self.assertTrue(any("duplicate JSON key" in error for error in errors))


if __name__ == "__main__":
    unittest.main()
