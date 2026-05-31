# Saarland University Faculty of Mathematics and Computer Science Department of Mathematics

# Random matrices

# Lecture notes

Winter 2019/20 

(version 2 from May 14, 2020) 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/f92f1508d9ca0560dce5e32158fd22d9f2e5c40f1b5840550428c79f62a77de5.jpg)


Prof. Dr. Roland Speicher 

This in an introduction to random matrix theory, giving an impression of some of the most important aspects of this modern subject. In particular, it covers the basic combinatorial and analytic theory around Wigner’s semicircle law, featuring also concentration phenomena, and the Tracy–Widom distribution of the largest eigenvalue. The circular law and a discussion of Voiculescu’s multivariate extension of the semicircle law, as an appetizer for free probability theory, also make an appearance. 

This manuscript here is an updated version of a joint manuscript with Marwa Banna from an earlier version of this course; it relies substantially on the sources given in the literature; in particular, the lecture notes of Todd Kemp were inspiring and very helpful at various places. 

The material here was presented in the winter term 2019/20 at Saarland University in 24 lectures of 90 minutes each. The lectures were recorded and can be found online at https://www.math.uni-sb.de/ag/speicher/web_video/index.html. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/3ac806564128e0bd63ca44d91de611c19688c7cd0acfba8e029e9303750432dc.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/f4314571b962d74194f433b7412812a49349b769f1a62f844c29e4beba44bae8.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/156d540bdb2ff0bc6e67c646c475472ed70797d2f270b0d38c5b165e07ad0ffa.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/a556b31432f381909f035c2efe8d23a1b514b9c0f7d3560eb1000c28917ac06e.jpg)


# Table of contents

# 1 Introduction 7

1.1 Brief history of random matrix theory . 7 

1.2 What are random matrices and what do we want to know about them? 8 

1.3 Wigner’s semicircle law 11 

1.4 Universality 12 

1.5 Concentration phenomena 12 

1.6 From histograms to moments 13 

1.7 Choice of scaling 14 

1.8 The semicircle and its moments 15 

1.9 Types of convergence 16 

# 2 Gaussian Random Matrices: Wick Formula and Combinatorial Proof of Wigner’s Semicircle 19

2.1 Gaussian random variables and Wick formula 19 

2.2 Gaussian random matrices and genus expansion 23 

2.3 Non-crossing pairings 27 

2.4 Semicircle law for GUE 29 

# 3 Wigner Matrices: Combinatorial Proof of Wigner’s Semicircle Law 33

3.1 Wigner matrices . 33 

3.2 Combinatorial description of moments of Wigner matrices 34 

3.3 Semicircle law for Wigner matrices 37 

# 4 Analytic Tools: Stieltjes Transform and Convergence of Measures 39

4.1 Stieltjes transform 40 

4.2 Convergence of probability measures 43 

4.3 Probability measures determined by moments 46 

4.4 Description of weak convergence via the Stieltjes transform 47 

# 5 Analytic Proof of Wigner’s Semicircle Law for Gaussian Random Matrices 49

5.1 GOE random matrices 49 

5.2 Stein’s identity for independent Gaussian variables 51 

5.3 Semicircle law for GOE 52 

# 6 Concentration Phenomena and Stronger Forms of Convergence for the Semicircle Law 55

6.1 Forms of convergence 55 

6.2 Markov’s and Chebyshev’s inequality 56 

6.3 Poincaré inequality 58 

6.4 Concentration for $\operatorname { t r } [ R _ { A } ( z ) ]$ via Poincaré inequality 63 

6.5 Logarithmic Sobolev inequalities 65 

# 7 Analytic Description of the Eigenvalue Distribution of Gaussian Random Matrices 67

7.1 Joint eigenvalue distribution for GOE and GUE 67 

7.2 Rewriting the Vandermonde 72 

7.3 Rewriting the GUE density in terms of Hermite kernels 73 

# 8 Determinantal Processes and Non-Crossing Paths: Karlin–McGregor and Gessel–Viennot 81

8.1 Stochastic version à la Karlin–McGregor 81 

8.2 Combinatorial version à la Gessel–Viennot 83 

8.3 Dyson Brownian motion and non-intersecting paths 86 

# 9 Statistics of the Largest Eigenvalue and Tracy–Widom Distribution 89

9.1 Some heuristics on single eigenvalues 89 

9.2 Tracy–Widom distribution 90 

9.3 Convergence of the largest eigenvalue to 2 91 

9.4 Estimate for fluctuations 95 

9.5 Non-rigorous derivation of Tracy–Widom distribution 96 

9.6 Proof of the Harer–Zagier recursion 101 

# 10 Statistics of the Longest Increasing Subsequence 107

10.1 Complete order is impossible 107 

10.2 Tracy–Widom for the asymptotic distribution of $L _ { n }$ 109 

10.3 Very rough sketch of the proof of the Baik, Deift, Johansson theorem 109 

10.3.1 RSK correspondence 110 

10.3.2 Relation to non-intersecting paths . . . 112 

# 11 The Circular Law 113

11.1 Circular law for Ginibre ensemble 113 

11.2 General circular law . 117 

# 12 Several Independent GUEs and Asymptotic Freeness 119

12.1 The problem of non-commutativity 119 

12.2 Joint moments of independent GUEs 120 

12.3 The concept of free independence 122 

# 13 Exercises 127

13.1 Assignment 1 127 

13.2 Assignment 2 128 

13.3 Assignment 3 129 

13.4 Assignment 4 130 

13.5 Assignment 5 131 

13.6 Assignment 6 133 

13.7 Assignment 7 135 

13.8 Assignment 8 135 

13.9 Assignment 9 137 

13.10Assignment 10 138 

13.11Assignment 11 139 

# 14 Literature 141

# 1 Introduction

We start with giving a brief history of the subject and a feeling for some the basic objects, questions, and methods - this is just motivational and should be seen as an appetizer. Rigorous versions of statements will come in later chapters. 

# 1.1 Brief history of random matrix theory

• 1897: the paper Über die Erzeugung der Invarianten durch Integration by Hurwitz is, according to Diaconis and Forrester, the first paper on random matrices in mathematics; 

• 1928: usually, the first appearance of random matrices, for fixed size $N$ , is attributed to a paper of Wishart in statistics; 

• 1955: Wigner introduced random matrices as statistical models for heavy nuclei and studied in particular the asymptotics for $N \to \infty$ (the so-called “large $N$ limit”); this set off a lot of activity around random matrices in physics; 

• since 1960’s: random matrices have become important tools in physics; in particular in the context of quantum chaos and universality questions; important work was done by by Mehta and Dyson; 

• 1967: the first and influential book on Random Matrices by Mehta appeared; 

• 1967: Marchenko and Pastur calculated the asymptotics $N  \infty$ of Wishart matrices; 

• ∼ 1972: a relation between the statistics of eigenvalues of random matrices and the zeros of the Riemann $\zeta$ -function was conjectured by Montgomery and Dyson; with substantial evidence given by numerical calculations of Odlyzko; this made the subject more and more popular in mathematics; 

• since 1990’s: random matrices are studied more and more extensively in mathematics, in the context of quite different topics, like 

◦ Tracy-Widom distribution of largest eigenvalue 

◦ free probability theory 

◦ universality of fluctuations 

◦ “circular law” 

◦ and many more 

# 1.2 What are random matrices and what do we want to know about them?

A random matrix is a matrix $A = ( a _ { i j } ) _ { i , j = 1 } ^ { N }$ where the entries $a _ { i j }$ are chosen randomly and we are mainly interested in the eigenvalues of the matrices. Often we require $A$ to be selfadjoint, which guarantees that its eigenvalues are real. 

Example 1.1. Choose $a _ { i j } \in \{ - 1 , + 1 \}$ with $a _ { i j } = a _ { j i }$ for all $i , j$ . We consider all such matrices and ask for typical or generic behaviour of the eigenvalues. In a more probabilistic language we declare all allowed matrices to have the same probability and we ask for probabilities of properties of the eigenvalues. We can do this for different sizes $N$ . To get a feeling, let us look at different $N$ . 

• For $N = 1$ we have two matrices. 

matrix eigenvalues probability of the matrix 

(1) 

+1 

12 

(−1) 

−1 

12 

• For $N = 2$ we have eight matrices. 

matrix eigenvalues probability of the matrix 

$$
\left( \begin{array}{c c} 1 & 1 \\ 1 & 1 \end{array} \right) \qquad \qquad 0, 2 \qquad \qquad \frac {1}{8}
$$

$$
\left( \begin{array}{c c} 1 & 1 \\ 1 & - 1 \end{array} \right) \qquad - \sqrt {2}, \sqrt {2} \qquad \frac {1}{8}
$$

$$
\left( \begin{array}{c c} 1 & - 1 \\ - 1 & 1 \end{array} \right) \qquad 0, 2 \qquad \frac {1}{8}
$$

$$
\left( \begin{array}{c c} - 1 & 1 \\ 1 & - 1 \end{array} \right) \qquad - \sqrt {2}, \sqrt {2} \qquad \qquad \frac {1}{8}
$$

$$
\left( \begin{array}{c c} 1 & - 1 \\ - 1 & - 1 \end{array} \right) \qquad - \sqrt {2},   \sqrt {2} \qquad \qquad \frac {1}{8}
$$

$$
\left( \begin{array}{c c} - 1 & 1 \\ 1 & - 1 \end{array} \right) \qquad - 2, 0 \qquad \frac {1}{8}
$$

$$
\left( \begin{array}{c c} - 1 & - 1 \\ - 1 & 1 \end{array} \right) \qquad - \sqrt {2},   \sqrt {2} \qquad \qquad \frac {1}{8}
$$

$$
\left( \begin{array}{c c} - 1 & - 1 \\ - 1 & - 1 \end{array} \right) \qquad - 2, 0 \qquad \qquad \qquad \frac {1}{8}
$$

• For general $N$ , we have $2 ^ { N ( N + 1 ) / 2 }$ matrices, each counting with probability $2 ^ { - N ( N + 1 ) / 2 }$ . Of course, there are always very special matrices such as 

$$
A = \left( \begin{array}{c c c} 1 & \dots & 1 \\ \vdots & \ddots & \vdots \\ 1 & \dots & 1 \end{array} \right),
$$

where all entries are $+ 1$ . Such a matrix has an atypical eigenvalue behaviour (namely, only two eigenvalues, $N$ and 0, the latter with multiplicity $N - 1$ ); however, the probability of such atypical behaviours will become small if we increase $N$ . What we are interested in is the behaviour of most of the matrices for large $N$ . 

Question. What is the “typical” behaviour of the eigenvalues? 

• Here are two “randomly generated” (by throwing a coin for each of the entries on and above the diagonal) $8 \times 8$ symmetric matrices with $\pm 1$ entries ... 

$$
\left( \begin{array}{c c c c c c c c} - 1 & - 1 & 1 & 1 & 1 & - 1 & 1 & - 1 \\ - 1 & - 1 & 1 & - 1 & - 1 & - 1 & 1 & - 1 \\ 1 & 1 & 1 & 1 & - 1 & - 1 & 1 & - 1 \\ 1 & - 1 & 1 & - 1 & - 1 & - 1 & 1 & 1 \\ 1 & - 1 & - 1 & - 1 & 1 & 1 & - 1 & - 1 \\ - 1 & - 1 & - 1 & - 1 & 1 & 1 & - 1 & 1 \\ 1 & 1 & 1 & 1 & - 1 & - 1 & - 1 & - 1 \\ - 1 & - 1 & - 1 & 1 & - 1 & 1 & - 1 & - 1 \end{array} \right)
$$

$$
\left( \begin{array}{c c c c c c c c} 1 & - 1 & - 1 & 1 & - 1 & - 1 & 1 & - 1 \\ - 1 & 1 & - 1 & 1 & 1 & - 1 & 1 & 1 \\ - 1 & - 1 & - 1 & - 1 & 1 & 1 & 1 & - 1 \\ 1 & 1 & - 1 & 1 & - 1 & 1 & 1 & 1 \\ - 1 & 1 & 1 & - 1 & - 1 & - 1 & - 1 & - 1 \\ - 1 & - 1 & 1 & 1 & - 1 & 1 & - 1 & - 1 \\ 1 & 1 & 1 & 1 & - 1 & - 1 & - 1 & - 1 \\ - 1 & 1 & - 1 & 1 & - 1 & - 1 & - 1 & - 1 \end{array} \right)
$$

... and their corresponding histograms of the 8 eigenvalues 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/969bd1e4735e92b7c6994116b5b602d5ea8c18ff82373a61737089936ef35784.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/52313253e828d224663b25967ebc7ea4eec8a51cee6883e3d5ee447d5bd356f2.jpg)


The message of those histograms is not so clear - apart from maybe that degeneration of eigenvalues is atypical. However, if we increase $N$ further then there will appear much more structure. 

• Here are the eigenvalue histograms for two “random” $1 0 0 \times 1 0 0$ matrices ... 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/d4af1a811aff00545dc1206ee0b7e21281c66023c692fc6d4737210073d09409.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/c10bcd49e4c0f2116380f63a0f6678fdd279a6e250e63b216887bbdd5f276135.jpg)


• ... and here for two “random” $3 0 0 0 \times 3 0 0 0$ matrices ... 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/23a71b2c5afaa0ffb17cb95afca67c22a1af9425ad0264ca9b4f0ef667aef1f3.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/67e0f5813712ff1732445c4cb8a7b9b1c2006688fb286ccf7114c5720c2574ec.jpg)


To be clear, no coins were thrown for producing those matrices, but we relied on the MATLAB procedure for creating random matrices. Note that we also rescaled our matrices, as we will address in Section 1.7. 

# 1.3 Wigner’s semicircle law

What we see in the above figures is the most basic and important result of random matrix theory, the so-called Wigner’s semicirlce law . . . 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/828fab4e351ba76112c105e4e04fb26867a805d18aad3006da1a342682da6495.jpg)


. . . which says that typically the eigenvalue distribution of such a random matrix converges to Wigner’s semicircle for $N \to \infty$ . 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/e8680306053ec0c485afc7cb00b0cc393239b736a01cda5df9bc1931d69d5792.jpg)


Note the quite surprising feature that the limit of the random eigenvalue distribution for $N  \infty$ is a deterministic object - the semicircle distribution. The randomness disappears for large $N$ . 

# 1.4 Universality

This statement is valid much more generally. Choose the $a _ { i j }$ not just from $\{ - 1 , + 1 \}$ but, for example, 

• $a _ { i j } \in \{ 1 , 2 , 3 , 4 , 5 , 6 \}$ , 

$a _ { i j }$ normally (Gauß) distributed, 

• $a _ { i j }$ distributed according to your favorite distribution, 

but still independent (apart from symmetry), then we still have the same result: The eigenvalue distribution typically converges to a semicircle for $N \to \infty$ . 

# 1.5 Concentration phenomena

The (quite amazing) fact that the a priori random eigenvalue distribution is, for $N  \infty$ , not random anymore, but concentrated on one deterministic distribution (namely the semicircle) is an example of the general high-dimensional phenomenon of “measure concentration”. 

Example 1.2. To illustrate this let us give an easy but illustrating example of such a concentration in high dimensions; namely that the volume of a ball is essentially sitting in the surface. 

Denote by $B _ { r } ( 0 )$ the ball of radius $r$ about 0 in $\mathbb { R } ^ { n }$ and for $0 < \varepsilon < 1$ consider the $\varepsilon$ -neighborhood of the surface inside the ball, $B : = \{ x \in \mathbb { R } ^ { n } | 1 - \varepsilon \leq \| x \| \leq 1 \}$ . As we know the volume of balls 

$$
\operatorname {v o l} (B _ {r} (0)) = r ^ {n} \frac {\pi^ {\frac {n}{2}}}{\left(\frac {n}{2} - 1\right) !},
$$

we can calculate the volume of $B$ as 

$$
\operatorname {v o l} (B) = \operatorname {v o l} (B _ {1} (0)) - \operatorname {v o l} (B _ {1 - \varepsilon} (0)) = \frac {\pi^ {\frac {n}{2}}}{\left(\frac {n}{2} - 1\right) !} \left(1 - (1 - \varepsilon) ^ {n}\right).
$$

Thus, 

$$
\frac {\operatorname {v o l} (B)}{\operatorname {v o l} (B _ {1} (0))} = 1 - (1 - \varepsilon) ^ {n} \stackrel {n \to \infty} {\longrightarrow} 1.
$$

This says that in high dimensions the volume of a ball is concentrated in an arbitrarily small neighborhood of the surface. This is, of course, not true in small dimension - hence from our usual 3-dimensional perspective this appears quite counter-intuitive. 

# 1.6 From histograms to moments

Let $A _ { N } = A = ( a _ { i j } ) _ { i , j = 1 } ^ { N }$ be our selfadjoint matrix with $a _ { i j } = \pm 1$ randomly chosen. Then we typically see for the eigenvalues of $A$ : 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/a12ca48cf6e68d3d35a128a94ad6676569949b3d25fa5bcab4d18f0fdf4ea472.jpg)


This convergence means 

$$
\frac {\# \left\{\text {e i g e n v a l u e s i n} [ s , t ] \right\}}{N} \xrightarrow {N \rightarrow \infty} \int_ {s} ^ {t} \mathrm {d} \mu_ {W} = \int_ {s} ^ {t} p _ {W} (x) \mathrm {d} x,
$$

where $\mu _ { W }$ is the semicircle distribution, with density $p _ { W }$ . 

The left-hand side of this is difficult to calculate directly, but we note that the above statement is the same as 

$$
\frac {1}{N} \sum_ {i = 1} ^ {N} 1 _ {[ s, t ]} (\lambda_ {i}) \xrightarrow {N \rightarrow \infty} \int_ {\mathbb {R}} 1 _ {[ s, t ]} (x) \mathrm {d} \mu_ {W} (x), \tag {*}
$$

where $\lambda _ { 1 } , \ldots , \lambda _ { N }$ are the eigenvalues of $A$ counted with multiplicity and $1 _ { [ s , t ] }$ is the characteristic function of $[ s , t ]$ , i.e, 

$$
1 _ {[ s, t ]} (x) = \left\{ \begin{array}{l l} 1, & x \in [ s, t ], \\ 0, & x \not \in [ s, t ]. \end{array} \right.
$$

Hence in (?) we are claiming that 

$$
\frac {1}{N} \sum_ {i = 1} ^ {N} f (\lambda_ {i}) \xrightarrow {N \to \infty} \int_ {\mathbb {R}} f (x) \mathrm {d} \mu_ {W} (x)
$$

for all $f = 1 _ { [ s , t ] }$ . It is easier to calculate this for other functions $f$ , in particular, for $f$ of the form $f ( x ) = x ^ { n }$ , i.e., 

$$
\frac {1}{N} \sum_ {i = 1} ^ {N} \lambda_ {i} ^ {n} \xrightarrow {N \rightarrow \infty} \int_ {\mathbb {R}} x ^ {n} \mathrm {d} \mu_ {W} (x); \quad (\star \star)
$$

the latter are the moments of $\mu _ { W }$ . (Note that $\mu _ { W }$ must necessarily be a probability measure.) 

We will see later that in our case the validity of (?) for all $s < t$ is equivalent to the validity of $( \star \star )$ for all $n$ . Hence we want to show (??) for all $n$ . 

Remark 1.3. The above raises of course the question: What is the advantage of $( \star \star )$ over $( \star )$ , or of $x ^ { n }$ over $1 _ { [ s , t ] }$ ? 

Note that $A = A ^ { * }$ is selfadjoint and hence can be diagonalized, i.e., $A = U D U ^ { * }$ , where $U$ is unitary and $D$ is diagonal with $d _ { i i } = \lambda _ { i }$ for all $i$ (where $\lambda _ { 1 } , \ldots , \lambda _ { N }$ are the eigenvalues of $A$ , counted with multiplicity). Moreover, we have 

$$
A ^ {n} = (U D U ^ {*}) ^ {n} = U D ^ {n} U ^ {*} \qquad \text {w i t h} \qquad D ^ {n} = \left( \begin{array}{c c c} \lambda_ {1} ^ {n} & & \\ & \ddots & \\ & & \lambda_ {N} ^ {n} \end{array} \right),
$$

hence 

$$
\sum_ {i = 1} ^ {N} \lambda_ {i} ^ {n} = \operatorname {T r} (D ^ {n}) = \operatorname {T r} (U D ^ {n} U ^ {*}) = \operatorname {T r} (A ^ {n})
$$

and thus 

$$
\frac {1}{N} \sum_ {i = 1} ^ {N} \lambda_ {i} ^ {n} = \frac {1}{N} \operatorname {T r} (A ^ {n}).
$$

Notation 1.4. We denote by $\textstyle \mathrm { t r } = { \frac { 1 } { N } } \operatorname { T r }$ the normalized trace of matrices, i.e., 

$$
\operatorname {t r} \left(\left(a _ {i j}\right) _ {i, j = 1} ^ {N}\right) = \frac {1}{N} \sum_ {i = 1} ^ {N} a _ {i i}.
$$

So we are claiming that for our matrices we typically have that 

$$
\operatorname {t r} \left(A _ {N} ^ {n}\right) \xrightarrow {N \to \infty} \int x ^ {n} \mathrm {d} \mu_ {W} (x).
$$

The advantage in this formulation is that the quantity $\operatorname { t r } ( A _ { N } ^ { n } )$ can be expressed in terms of the entries of the matrix, without actually having to calculate the eigenvalues. 

# 1.7 Choice of scaling

Note that we need to choose the right scaling in $N$ for the existence of the limit $N \to \infty$ . For the case $a _ { i j } \in \{ \pm 1 \}$ with $A _ { N } = A _ { N } ^ { * }$ we have 

$$
\operatorname {t r} (A _ {N} ^ {2}) = \frac {1}{N} \sum_ {i, j = 1} ^ {N} a _ {i j} a _ {j i} = \frac {1}{N} \sum_ {i, j = 1} a _ {i j} ^ {2} = \frac {1}{N} N ^ {2} = N.
$$

Since this has to converge for $N \to \infty$ we should rescale our matrices 

$$
A _ {N} \rightsquigarrow \frac {1}{\sqrt {N}} A _ {N},
$$

i.e., we consider matrices $A _ { N } = ( a _ { i j } ) _ { i , j = 1 } ^ { N }$ , where $a _ { i j } = \pm \frac { 1 } { \sqrt { N } }$ . For this scaling we claim that we typically have that 

$$
\operatorname {t r} \left(A _ {N} ^ {n}\right) \xrightarrow {N \to \infty} \int x ^ {n} \mathrm {d} \mu_ {W} (x)
$$

for a deterministic probability measure $\mu _ { W }$ . 

# 1.8 The semicircle and its moments

It’s now probably time to give the precise definition of the semicircle distribution and, in the light of what we have to prove, also its moments. 

Definition 1.5. (1) The (standard) semicircular distribution $\mu _ { W }$ is the measure on $[ - 2 , 2 ]$ with density 

$$
\mathrm {d} \mu_ {W} (x) = \frac {1}{2 \pi} \sqrt {4 - x ^ {2}} \mathrm {d} x.
$$

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/ef58bd6fddf5dde951835cb33c56de61c2d9d90c12c0af8bfb26d83670950d59.jpg)


(2) The Catalan numbers $( C _ { k } ) _ { k \geq 0 }$ are given by 

$$
C _ {k} = \frac {1}{k + 1} \binom {2 k} {k}.
$$

They look like this: $1 , 1 , 2 , 5 , 1 4 , 4 2 , 1 3 2 , . . .$ 

Theorem 1.6. (1) The Catalan numbers have the following properties. 

(i) The Catalan numbers satisfy the following recursion: 

$$
C _ {k} = \sum_ {l = 0} ^ {k - 1} C _ {l} C _ {k - l - 1} \qquad (k \geq 1)
$$

(ii) The Catalan numbers are uniquely determined by this recursion and by the initial value $C _ { 0 } = 1$ . 

(2) The semicircular distribution $\mu _ { W }$ is a probability measure, i.e., 

$$
\frac {1}{2 \pi} \int_ {- 2} ^ {2} \sqrt {4 - x ^ {2}} \mathrm {d} x = 1
$$

and its moments are given by 

$$
\frac {1}{2 \pi} \int_ {- 2} ^ {2} x ^ {n} \sqrt {4 - x ^ {2}}   \mathrm {d} x = \left\{ \begin{array}{l l} 0, & n o d d, \\ C _ {k}, & n = 2 k e v e n. \end{array} \right.
$$

Exercises 2 and 3 address the proof of Theorem 1.6. 

# 1.9 Types of convergence

So we are claiming that typically 

$$
\operatorname {t r} (A _ {N} ^ {2}) \to 1, \qquad \operatorname {t r} (A _ {N} ^ {4}) \to 2, \qquad \operatorname {t r} (A _ {N} ^ {6}) \to 5, \quad \operatorname {t r} (A _ {N} ^ {8}) \to 1 4, \qquad \operatorname {t r} (A _ {N} ^ {1 0}) \to 4 2,
$$

and so forth. But what do we mean by “typically”? The mathematical expression for this is “almost surely”, but for now let us look on the more intuitive “convergence in probability” for $\mathrm { t r } ( A _ { N } ^ { 2 k } )  C _ { k }$ . 

Denote by $\Omega _ { N }$ the set of our considered matrices, that is 

$$
\Omega_ {N} = \left\{A _ {N} = \frac {1}{\sqrt {N}} (a _ {i j}) _ {i, j = 1} ^ {N} \mid A _ {N} = A _ {N} ^ {*} \mathrm {a n d} a _ {i j} \in \{\pm 1 \} \right\}.
$$

Then convergence in probability means that for all $\varepsilon > 0$ we have 

$$
\frac {\# \left\{A _ {N} \in \Omega_ {N} \mid \left| \operatorname {t r} \left(A _ {N} ^ {2 k}\right) - C _ {k} \right| > \varepsilon \right\}}{\# \Omega_ {N}} = P \left(A _ {N} \mid \left| \operatorname {t r} \left(A _ {N} ^ {2 k}\right) - C _ {k} \right| > \varepsilon\right) \xrightarrow {N \to \infty} 0. (\star)
$$

How can we show (?)? Usually, one proceeds as follows. 

(1) First we show the weaker form of convergence in average, i.e., 

$$
\frac {\sum_ {A _ {N} \in \Omega_ {N}} \mathrm {t r} (A _ {N} ^ {2 k})}{\# \Omega_ {N}} = \mathbb {E} [ \mathrm {t r} (A _ {N} ^ {2 k}) ] \xrightarrow {N \to \infty} C _ {k}.
$$

(2) Then we show that with high probability the derivation from the average will become small as $N  \infty$ . 

We will first consider step (1); (2) is a concentration phenomenon and will be treated later. 

Note that step (1) is giving us the insight into why the semicircle shows up. Step (2) is more of a theoretical nature, adding nothing to our understanding of the semicircle, but making the (very interesting!) statement that in high dimensions the typical behaviour is close to the average behaviour. 

# 2 Gaussian Random Matrices: Wick Formula and Combinatorial Proof of Wigner’s Semicircle

We want to prove convergence of our random matrices to the semicircle by showing 

$$
\mathbb {E} \left[ \mathrm {t r} A _ {N} ^ {2 k} \right] \xrightarrow {N \to \infty} C _ {k},
$$

where the $C _ { k }$ are the Catalan numbers. 

Up to now our matrices were of the form $\begin{array} { r } { A _ { N } = \frac { 1 } { \sqrt { N } } ( a _ { i j } ) _ { i , j = 1 } ^ { N } } \end{array}$ with $a _ { i j } \in \{ - 1 , 1 \}$ . From an analytic and also combinatorial point of view it is easier to deal with another choice for the $a _ { i j }$ , namely we will take them as Gaussian (aka normal) random variables; different $a _ { i j }$ will still be, up to symmetry, independent. If we want to calculate the expectations $\operatorname { t r } ( A ^ { 2 k } )$ , then we should of course understand how to calculate moments of independent Gaussian random variables. 

# 2.1 Gaussian random variables and Wick formula

Definition 2.1. A standard Gaussian (or normal) random variable $X$ is a realvalued Gaussian random variable with mean 0 and variance 1, i.e., it has distribution 

$$
\mathbb {P} \left[ t _ {1} \leq X \leq t _ {2} \right] = \frac {1}{\sqrt {2 \pi}} \int_ {t _ {1}} ^ {t _ {2}} e ^ {- \frac {t ^ {2}}{2}} \mathrm {d} t
$$

and hence its moments are given by 

$$
\mathbb {E} \left[ X ^ {n} \right] = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} t ^ {n} e ^ {- \frac {t ^ {2}}{2}} \mathrm {d} t.
$$

Proposition 2.2. The moments of a standard Gaussian random variable are of the form 

$$
\frac {1}{\sqrt {2 \pi}} \int_ {- \infty} ^ {\infty} t ^ {n} e ^ {- \frac {t ^ {2}}{2}}   \mathrm {d} t = \left\{ \begin{array}{l l} 0, & n o d d, \\ (n - 1)!!, & n e v e n, \end{array} \right.
$$

where the “double factorial” is defined, for m odd, as 

$$
m!! = m (m - 2) (m - 4) \dots 5 \cdot 3 \cdot 1.
$$

You are asked to prove this in Exercise 5. 

Remark 2.3. From an analytic point of view it is surprising that those integrals evaluate to natural numbers. They actually count interesting combinatorial objects, 

$$
\mathbb {E} \left[ X ^ {2 k} \right] = \# \{\text {p a i r i n g s o f 2 k e l e m e n t s} \}.
$$

Definition 2.4. (1) For a natural number $n \in \mathbb { N }$ we put $[ n ] = \{ 1 , \dots , n \}$ 

(2) A pairing $\pi$ of $[ n ]$ is a decomposition of $[ n ]$ into disjoints subsets of size 2, i.e., $\pi = \{ V _ { 1 } , \ldots , V _ { k } \}$ such that for all $i , j = 1 , \ldots , k$ with $i \neq j$ , we have: 

• $V _ { i } \subset [ n ]$ 

• $\# V _ { i } = 2$ 

• $V _ { i } \cap V _ { j } = \emptyset$ 

• $\cup _ { i = 1 } ^ { k } V _ { i } = [ n ]$ 

Note that necessarily $\begin{array} { r } { k = \frac { n } { 2 } } \end{array}$ 

(3) The set of all pairings of $[ n ]$ is denoted by 

$$
\mathcal {P} _ {2} (n) = \{\pi \mid \pi \text {i s a p a i r i n g o f} [ n ] \}.
$$

Proposition 2.5. (1) We have 

$$
\# \mathcal {P} _ {2} (n) = \left\{ \begin{array}{l l} 0, & n o d d, \\ (n - 1)!!, & n e v e n. \end{array} \right.
$$

(2) Hence for a standard Gaussian variable $X$ we have 

$$
\mathbb {E} \left[ X ^ {n} \right] = \# \mathcal {P} _ {2} (n).
$$

Proof. (1) Count elements in $\mathcal { P } _ { 2 } ( n )$ in a recursive way. Choose the pair which contains the element 1, for this we have $n - 1$ possibilities. Then we are left with choosing a pairing of the remaining $n - 2$ numbers. Hence we have 

$$
\# \mathcal {P} _ {2} (n) = (n - 1) \cdot \# \mathcal {P} _ {2} (n - 2).
$$

Iterating this and noting that $\# \mathcal { P } _ { 2 } ( 1 ) = 0$ and $\# \mathcal { P } _ { 2 } ( 2 ) = 1$ gives the desired result. 

(2) Follows from (i) and Proposition 2.2. 

Example 2.6. Usually we draw our partitions by connecting the elements in each pair. Then $\mathbb { E } \left[ X ^ { 2 } \right] = 1$ corresponds to the single partition 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/ff79825bb1bb6d59c109ce89ce3ab5d6bc93bfd5000b94964c9ac0d8272a7a55.jpg)


and $\mathbb { E } \left[ X ^ { 4 } \right] = 3$ corresponds to the three partitions 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/815359d18264fcf8da1f1b6747f0aa5773d0495299546cd2cebd80e321a4793c.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/ad2c1dcd961cb376063cad89f9791374cb5af3e42511b46c826ffdddc72ea5df.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/10f352959869a3035dc0ae565a04f1d8ac067241a14821d1f3bcdbe2f000ae2d.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/082e508927dce217a38006fc285a16da9cdae0da04a6a467d9741f80aaddb83b.jpg)


Remark 2.7 (Independent Gaussian random variables). We will have several, say two, Gaussian random variables $X , Y$ and have to calculate their joint moments. The random variables are independent; this means that their joint distribution is the product measure of the single distributions, 

$$
\mathbb {P} \left[ t _ {1} \leq X \leq t _ {2}, s _ {1} \leq Y \leq s _ {2} \right] = \mathbb {P} \left[ t _ {1} \leq X \leq t _ {2} \right] \cdot \mathbb {P} \left[ s _ {1} \leq Y \leq s _ {2} \right],
$$

so in particular, for the moments we have 

$$
\mathbb {E} \left[ X ^ {n} Y ^ {m} \right] = \mathbb {E} \left[ X ^ {n} \right] \cdot \mathbb {E} \left[ Y ^ {m} \right].
$$

This gives then also a combinatorial description for their mixed moments: 

$$
\begin{array}{l} \mathbb {E} \left[ X ^ {n} Y ^ {m} \right] = \mathbb {E} \left[ X ^ {n} \right] \cdot \mathbb {E} \left[ Y ^ {m} \right] \\ = \# \{\text {p a i r i n g s o f} \underbrace {X \cdots X} _ {n} \} \cdot \# \{\text {p a i r i n g s o f} \underbrace {Y \cdots Y} _ {m} \} \\ = \# \{\text {p a i r i n g s o f} \underbrace {X \cdots X} _ {n} \underbrace {Y \cdots Y} _ {m} \text {w h i c h c o n n e c t} X \text {w i t h} X \text {a n d} Y \text {w i t h} Y \}. \\ \end{array}
$$

Example. We have $\mathbb { E } \left[ X X Y Y \right] = 1$ since the only possible pairing is 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/c1c83f75a91485849fc9e70b27057f35a2ab32636990e20086915a7d2ca36014.jpg)


On the other hand, $\mathbb { E } \left[ X X X Y X Y \right] = 3$ since we have the following three possible pairings: 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/67f660da2bc08dd5f53293cc3d834eb31046361b53e90d87742010e637075dec.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/16687e57f8986b68d599d8487de1d4dd7bdfd4f34fbe2590f1ba07238d4e8dbd.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/fdc393cf87b70c7ddda8c7c08bd23c403e9305c7a0d9586ea4c7c00350a9adfe.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/f7f2d85439e3ce7aaa7ff7a0929de51d5a9cfdc6181e0231fdeb8090ec56e0be.jpg)


Consider now $x _ { 1 } , \ldots , x _ { n } \in \{ X , Y \}$ . Then we still have 

$$
\mathbb {E} \left[ x _ {1} \dots x _ {n} \right] = \# \{\text {p a i r i n g s w h i c h c o n n e c t X w i t h X a n d Y w i t h Y} \}.
$$

Can we decide in a more abstract way whether $x _ { i } = x _ { j }$ or $x _ { i } \neq x _ { j }$ ? Yes, we can read this from the corresponding second moment, since 

$$
\mathbb {E} \left[ x _ {i} x _ {j} \right] = \left\{ \begin{array}{l l} \mathbb {E} \left[ x _ {i} ^ {2} \right] = 1, & x _ {i} = x _ {j}, \\ \mathbb {E} \left[ x _ {i} \right] \mathbb {E} \left[ x _ {j} \right] = 0, & x _ {i} \neq x _ {j}. \end{array} \right.
$$

Hence we have: 

$$
\mathbb {E} \left[ x _ {1} \cdot \cdot \cdot x _ {n} \right] = \sum_ {\pi \in \mathcal {P} _ {2} (n)} \prod_ {(i, j) \in \pi} \mathbb {E} \left[ x _ {i} x _ {j} \right]
$$

Theorem 2.8 (Wick 1950, physics; Isserlis 1918, statistics). Let $Y _ { 1 } , \ldots , Y _ { p }$ be independent standard Gaussian random variables and consider $x _ { 1 } , \ldots , x _ { n } \in \{ Y _ { 1 } , \ldots , Y _ { p } \}$ . Then we have the Wick formula 

$$
\mathbb {E} \left[ x _ {1} \dots x _ {n} \right] = \sum_ {\pi \in \mathcal {P} _ {2} (n)} \mathbb {E} _ {\pi} \left[ x _ {1}, \ldots , x _ {n} \right],
$$

where, for $\pi \in \mathcal { P } _ { 2 } ( n )$ , we use the notation 

$$
\mathbb {E} _ {\pi} \left[ x _ {1}, \dots , x _ {n} \right] = \prod_ {(i, j) \in \pi} \mathbb {E} \left[ x _ {i} x _ {j} \right].
$$

Note that the Wick formula is linear in the $x _ { i }$ , hence it remains valid if we replace the $x _ { i }$ by linear combinations of the $x _ { j }$ . In particular, we can go over to complex Gaussian variables. 

Definition 2.9. A standard complex Gaussian random variable $Z$ is of the form 

$$
Z = \frac {X + i Y}{\sqrt {2}},
$$

where $X$ and $Y$ are independent standard real Gaussian variables. 

Remark 2.10. Let $Z$ be a standard complex Gaussian, i.e., $\begin{array} { r } { Z = \frac { X + i Y } { \sqrt { 2 } } } \end{array}$ . Then we have $\begin{array} { r } { \bar { Z } = \frac { X - i Y } { \sqrt { 2 } } } \end{array}$ and the first and second moments are given by 

• 

• 

$\begin{array} { r l } & { \bullet \mathbb { E } \left[ \bar { Z } ^ { 2 } \right] = 0 } \\ & { \bullet \mathbb { E } \left[ | Z | ^ { 2 } \right] = \mathbb { E } \left[ Z \bar { Z } \right] = \frac { 1 } { 2 } \left[ \mathbb { E } \left[ X X \right] + \mathbb { E } \left[ Y Y \right] + i \left( \mathbb { E } \left[ Y X \right] - \mathbb { E } \left[ Y X \right] \right) \right] = 1 } \end{array}$ 

Hence, for $z _ { 1 } , z _ { 2 } \in \{ Z , \bar { Z } \}$ and π = z1 z2 we have 

$$
\mathbb {E} \left[ z _ {1} z _ {2} \right] = \left\{ \begin{array}{l l} 1, & \pi \text {c o n n e c t s} Z \text {w i t h} \bar {Z}, \\ 0, & \pi \text {c o n n e c t s} (Z \text {w i t h} Z) \text {o r} (\bar {Z} \text {w i t h} \overline {{Z}}). \end{array} \right.
$$

Theorem 2.11. Let $Z _ { 1 } , \ldots , Z _ { p }$ be independent standard complex Gaussian random variables and consider $z _ { 1 } , \dots , z _ { n } \in \{ Z _ { 1 } , Z _ { 1 } , \dots , Z _ { p } , Z _ { p } \}$ . Then we have the Wick formula 

$$
\begin{array}{l} \mathbb {E} \left[ z _ {1} \dots z _ {n} \right] = \sum_ {\pi \in \mathcal {P} _ {2} (n)} \mathbb {E} _ {\pi} \left[ z _ {1}, \dots , z _ {n} \right] \\ = \# \left\{\text {p a i r i n g s o f} [ n ] \text {w h i c h c o n n e c t} Z _ {i} \text {w i t h} \bar {Z} _ {i} \right\}. \\ \end{array}
$$

# 2.2 Gaussian random matrices and genus expansion

Now we are ready to consider random matrices with such complex Gaussians as entries. 

Definition 2.12. A Gaussian random matrix is of the form $\begin{array} { r } { A _ { N } = \frac { 1 } { \sqrt { N } } ( a _ { i j } ) _ { i , j = 1 } ^ { N } } \end{array}$ 

• $A _ { N } = A _ { N } ^ { * }$ , i.e., $a _ { i j } = a _ { j i }$ for all $i , j$ 

• $\{ a _ { i j } | i \geq j \}$ are independent, 

• each $a _ { i j }$ is a standard Gaussian random variable, which is complex for $i \neq j$ and real for $i = j$ . 

Remark 2.13. (1) More precisely, we should address the above as selfadjoint Gaussian random matrices. 

(2) Another common name for those random matrices is gue, which stands for Gaussian unitary ensemble. “Unitary” corresponds here to the fact that the entries are complex, since such matrices are invariant under unitary transformations. With gue(n) we denote the gue of size $N \times N$ . There are also real and quaternionic versions, Gaussian orthogonal ensembles goe, and Gaussian symplectic ensembles gse. 

(3) Note that we can also express this definition in terms of the Wick formula 2.11 as 

$$
\mathbb {E} \left[ a _ {i (1) j (1)} \dots a _ {i (n) j (n)} \right] = \sum_ {\pi \in \mathcal {P} _ {2} (n)} \mathbb {E} _ {\pi} \left[ a _ {i (1) j (1)}, \ldots , a _ {i (n) j (n)} \right],
$$

for all $n$ and $1 \leq i ( 1 ) , j ( 1 ) , \ldots , i ( n ) , j ( n ) \leq N$ , and where the second moments are given by 

$$
\mathbb {E} \left[ a _ {i j} a _ {k l} \right] = \delta_ {i l} \delta_ {j k}.
$$

So we have for example for the fourth moment 

$$
\begin{array}{l} \mathbb {E} \left[ a _ {i (1) j (1)} a _ {i (2) j (2)} a _ {i (3) j (3)} a _ {i (4) j (4)} \right] = \delta_ {i (1) j (2)} \delta_ {j (1) i (2)} \delta_ {i (3) j (4)} \delta_ {j (3) i (4)} \\ + \delta_ {i (1) j (3)} \delta_ {j (1) i (3)} \delta_ {i (2) j (4)} \delta_ {j (2) i (4)} \\ + \delta_ {i (1) j (4)} \delta_ {j (1) i (4)} \delta_ {i (2) j (3)} \delta_ {j (2) i (3)}, \\ \end{array}
$$

and more concretely, $\mathbb { E } \left[ a _ { 1 2 } a _ { 2 1 } a _ { 1 1 } a _ { 1 1 } \right] = 1$ and $\mathbb { E } \left[ a _ { 1 2 } a _ { 1 2 } a _ { 2 1 } a _ { 2 1 } \right] = 2$ . 

Remark 2.14 (Calculation of $\mathbb { E } \left[ \mathrm { t r } ( A _ { N } ^ { m } ) \right] ,$ ). For our Gaussian random matrix we want to calculate their moments 

$$
\mathbb {E} \left[ \mathrm {t r} (A _ {N} ^ {m}) \right] = \frac {1}{N} \frac {1}{N ^ {m / 2}} \sum_ {i (1), \ldots , i (m) = 1} ^ {N} \mathbb {E} \left[ a _ {i (1) i (2)} a _ {i (2) i (3)} \dots a _ {i (m) i (1)} \right].
$$

Let us first consider small examples before we treat the general case: 

(1) 

$$
\mathbb {E} \left[ \mathrm {t r} (A _ {N} ^ {2}) \right] = \frac {1}{N ^ {2}} \sum_ {i, j = 1} ^ {N} \underbrace {\mathbb {E} [ a _ {i j} a _ {j i} ]} _ {= 1} = \frac {1}{N ^ {2}} N ^ {2} = 1,
$$

and hence: $\mathbb { E } \left[ \mathrm { t r } ( A _ { N } ^ { 2 } ) \right] = 1 = C _ { 1 }$ for all $N$ 

(2) We consider the partitions 

$$
\pi_ {1} = \begin{array}{c c c c} 1 & 2 & 3 & 4 \\ \bullet & \bullet & \bullet & \bullet \end{array} , \quad \pi_ {2} = \begin{array}{c c c c} 1 & 2 & 3 & 4 \\ \bullet & \bullet & \bullet & \bullet \end{array} , \quad \pi_ {3} = \begin{array}{c c c c} 1 & 2 & 3 & 4 \\ \bullet & \bullet & \bullet & \bullet \end{array} .
$$

With this, we have 

$$
\mathbb {E} \left[ \mathrm {t r} (A _ {N} ^ {4}) \right] = \frac {1}{N ^ {3}} \sum_ {i, j, k, l = 1} ^ {N} \underbrace {\mathbb {E} \left[ a _ {i j} a _ {j k} a _ {k l} a _ {l i} \right]} _ {= \mathbb {E} _ {\pi_ {1}} [ \ldots ] + \mathbb {E} _ {\pi_ {2}} [ \ldots ] + \mathbb {E} _ {\pi_ {3}} [ \ldots ]}
$$

and calculate 

$$
\sum_{i,j,k,l = 1}^{N}\mathbb{E}_{\pi_{1}}\left[a_{ij},a_{jk},a_{kl},a_{li}\right] = \sum_{\substack{i,j,k,l = 1\\ i = k}}^{N}1 = N^{3},
$$

$$
\sum_{i,j,k,l = 1}^{N}\mathbb{E}_{\pi_{2}}\left[a_{ij},a_{jk},a_{kl},a_{li}\right] = \sum_{\substack{i,j,k,l = 1\\ j = l}}^{N}1 = N^{3},
$$

$$
\sum_{i,j,k,l = 1}^{N}\mathbb{E}_{\pi_{3}}\left[a_{ij},a_{jk},a_{kl},a_{li}\right] = \sum_{\substack{i,j,k,l = 1\\ i = l,j = k,j = i,k = l}}^{N}1 = \sum_{i = 1}^{N}1 = N,
$$

hence 

$$
\mathbb {E} \left[ \mathrm {t r} (A _ {N} ^ {4}) \right] = \frac {1}{N ^ {3}} \left(N ^ {3} + N ^ {3} + N\right) = 2 + \frac {1}{N ^ {2}}.
$$

So we have 

$$
\lim  _ {N \to \infty} \mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {4}\right) \right] = 2 = C _ {2}.
$$

(3) Let us now do the general case. 

$$
\begin{array}{l} \mathbb {E} \left[ a _ {i (1) i (2)} a _ {i (2) i (3)} \dots a _ {i (m) i (1)} \right] = \sum_ {\pi \in \mathcal {P} _ {2} (m)} \mathbb {E} _ {\pi} \left[ a _ {i (1) i (2)}, a _ {i (2) i (3)}, \dots , a _ {i (m) i (1)} \right] \\ = \sum_ {\pi \in \mathcal {P} _ {2} (m)} \prod_ {(k, l) \in \pi} \mathbb {E} \left[ a _ {i (k) i (k + 1)} a _ {i (l) i (l + 1)} \right]. \\ \end{array}
$$

We use the notation $[ i = j ] = \delta _ { i j }$ and, by identifying a pairing $\pi$ with a permutation $\pi \in S _ { m }$ via 

$$
(k, l) \in \pi \leftrightarrow \pi (k) = l, \pi (l) = k,
$$

find that 

$$
\begin{array}{l} \mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {m}\right) \right] = \frac {1}{N ^ {m / 2 + 1}} \sum_ {i (1), \dots , i (m) = 1} ^ {N} \sum_ {\pi \in \mathcal {P} _ {2} (m)} \prod_ {(k, l) \in \pi} \mathbb {E} \left[ a _ {i (k) i (k + 1)} a _ {i (l) i (l + 1)} \right] \\ = \frac{1}{N^{m / 2 + 1}}\sum_{\pi \in \mathcal{P}_{2}(m)}\sum_{i(1),\ldots ,i(m) = 1}^{N}\prod_{k}\Bigl[i(k) = i(\underbrace{\pi(k) + 1}_{\gamma \pi (k)})\Bigr], \\ \end{array}
$$

where $\gamma = ( 1 , 2 , \ldots , m ) \in S _ { m }$ is the shift by 1 modulo $m$ . The above product is different from 0 if and only if $i \colon [ m ] \ \to \ [ N ]$ is constant on the cycles of 

$\gamma \pi \in S _ { m }$ . Thus we get finally 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {m}\right) \right] = \frac {1}{N ^ {m / 2 + 1}} \sum_ {\pi \in \mathcal {P} _ {2} (m)} N ^ {\# (\gamma \pi)},
$$

where $\# ( \gamma \pi )$ is the number of cycles of the permutation $\gamma \pi$ 

Hence we have proved the following. 

Theorem 2.15. Let $A _ { N }$ be a gue(n) random matrix. Then we have for all $m \in \mathbb { N }$ , 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {m}\right) \right] = \sum_ {\pi \in \mathcal {P} _ {2} (m)} N ^ {\# (\gamma \pi) - \frac {m}{2} - 1}.
$$

Example 2.16. (1) This says in particular that all odd moments are zero, since $\mathcal { P } _ { 2 } ( 2 k + 1 ) = \emptyset$ . 

(2) Let $m = 2$ , then $\gamma = \left( 1 , 2 \right)$ and we have only one $\pi = ( 1 , 2 )$ ; then $\gamma \pi = \operatorname { i d } =$ (1)(2), and thus $\# ( \gamma \pi ) = 2$ and 

$$
\# (\gamma \pi) - \frac {m}{2} - 1 = 0.
$$

Thus, 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {2}\right) \right] = N ^ {0} = 1.
$$

(3) Let $m = 4$ and $\gamma = ( 1 , 2 , 3 , 4 )$ . Then there are three $\pi \in \mathcal { P } _ { 2 } ( 4 )$ with the following contributions: 

$$
\begin{array}{c c c c} \pi & \gamma \pi & \# (\gamma \pi) - 3 & \text {c o n t r i b u t i o n} \\ \hline (1, 2) (3 4) & (1, 3) (2) (4) & 0 & N ^ {0} = 1 \\ (1 3) (2 4) & (1, 4, 3, 2) & - 2 & N ^ {- 2} = \frac {1}{N ^ {2}} \\ (1 4) (2 3) & (1) (2, 4) (3) & 0 & N ^ {0} = 1 \end{array}
$$

so that 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {4}\right) \right] = 2 + \frac {1}{N ^ {2}}.
$$

(4) In the same way one can calculate that 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {6}\right) \right] = 5 + 1 0 \frac {1}{N ^ {2}},
$$

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {8}\right) \right] = 1 4 + 7 0 \frac {1}{N ^ {2}} + 2 1 \frac {1}{N ^ {4}}.
$$

(5) For $m = 6$ the following 5 pairings give contribution $N ^ { 0 }$ 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/d63475e196fc5144ce5ece79b9d47e67dac4085e5eb115eb473572d1e0f0886a.jpg)


Those are non-crossing pairings, all other pairings $\pi \in \mathcal { P } _ { 2 } ( 6 )$ have a crossing, e.g.: 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/5bf0efe7935bcb0d05ba1a343092713e78926c78d560ed9fe953c43e0578d9cd.jpg)


# 2.3 Non-crossing pairings

Definition 2.17. A pairing $\pi \in \mathcal { P } _ { 2 } ( m )$ is non-crossing (NC ) if there are no pairs $( i , k )$ and $( j , l )$ in $\pi$ with $i < j < k < l$ , i.e., we don’t have a crossing in $\pi$ . 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/699ac68c75f438c47f04fb284b957f441f112e9f9ad5c28e561e15b9ee5a138c.jpg)


We put 

$$
\mathcal {N C} _ {2} (m) = \left\{\pi \in \mathcal {P} _ {2} (m) \mid \pi \text {i s n o n - c r o s s i n g} \right\}.
$$

Example 2.18. (1) $\mathcal { N C } _ { 2 } ( 2 ) = \mathcal { P } _ { 2 } ( 2 ) = \{ \sqcup \}$ 

(2) $\mathcal { N C } _ { 2 } ( 4 ) = \{ \bigcup \ \ \bigcup \ , \ \bigcup , \ \bigcup \ \ \bigcup \ \ \big | \}$ and $\mathcal { P } _ { 2 } ( 4 ) \backslash \mathcal { N C } _ { 2 } ( 4 ) = \{ \bigcup \big | \big | \big | \big | \big | \big | \}$ 

(3) The 5 elements of $\mathcal { N C } _ { 2 } ( 6 )$ are given in Example 2.16 (v), $\mathcal { P } _ { 2 } ( 6 )$ contains 15 elements; thus there are $1 5 - 5 = 1 0$ more elements in $\mathcal { P } _ { 2 } ( 6 )$ with crossings. 

Remark 2.19. Note that NC-pairings have a recursive structure, which usually is crucial for dealing with them. 

(1) The first pair of $\pi \in \mathcal { N C } _ { 2 } ( 2 k )$ must necessarily be of the form $( 1 , 2 l )$ and the remaining pairs can only pair within $\{ 2 , \ldots , 2 l - 1 \}$ or within $\{ 2 l + 1 , \ldots , 2 l \}$ . 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/bd7302590a60083dbdf2a8395072a991ef2ded8bd42439ed0e9d0bf8f9e59301.jpg)


(2) Iterating this shows that we must find in any $\pi \in \mathcal { N C } _ { 2 } ( 2 k )$ at least one pair of the form $( i , i + 1 )$ with $1 \leq i \leq 2 k - 1$ . Removing this pair gives a NC-pairing of $2 k - 2$ points. This characterizes the NC-pairings as those pairings, which can be reduced to the empty set by iterated removal of pairs, which consist of neighbors. 

An example for the reduction of a non-crossing pairing is the following. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/05d51527505a0222c5eb3112a98990e963ee558dfb4b78fd44870b7169235ddd.jpg)


In the case of a crossing pairing, some reductions might be possible, but eventually one arrives at a point, where no further reduction can be done. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/0f6d66a8c18987cee644552fc288b43d899f17795bef6431d782704a65beb193.jpg)


Proposition 2.20. Consider m even and let $\pi \in \mathcal { P } _ { 2 } ( m )$ , which we identify with a permutation $\pi \in S _ { m }$ . As before, $\gamma = ( 1 , 2 , \ldots , m ) \in S _ { m }$ . Then we have: 

(1) $\# ( \gamma \pi ) - \textstyle { \frac { m } { 2 } } - 1 \leq 0$ for al l $\pi \in \mathcal { P } _ { 2 } ( m )$ 

(2) # $\begin{array} { r } { { \left( \gamma \pi \right) } - \frac { m } { 2 } - 1 = 0 } \end{array}$ if and only if $\pi \in \mathcal { N C } _ { 2 } ( m )$ 

Proof. First we note that a pair $( i , i + 1 )$ in $\pi$ corresponds to a fixed point of $\gamma \pi$ More precisely, in such a situation we have $i + 1 \stackrel { \pi } {  } i \stackrel { \gamma } {  } i + 1$ and $i \stackrel { \pi } {  } i + 1 \stackrel { \gamma } {  } i + 2$ . Hence $\gamma \pi$ contains the cycles $( i + 1 )$ and $( \dots , i , i + 2 , \dots )$ . 

This implication also goes in the other direction: If $\gamma \pi ( i + 1 ) = i + 1$ then $\pi ( i + 1 ) = \gamma ^ { - 1 } ( i + 1 ) = i$ . Since $\pi$ is a pairing we must then also have $\pi ( i ) = i + 1$ and hence we have the pair $( i , i + 1 )$ in $\pi$ . 

If we have $( i , i + 1 )$ in $\pi$ , we can remove the points $i$ and $i + 1$ , yielding another pairing $\tilde { \pi }$ . By doing so, we remove in $\gamma \pi$ the cycle $( i + 1 )$ and we remove in the cycle $( \dots , i , i + 2 , \dots )$ the point $i$ , yielding $\gamma \tilde { \pi }$ . We reduce thus $m$ by 2 and $\# ( \gamma \pi )$ by 1. 

If $\pi$ is NC we can iterate this until we arrive at $\tilde { \pi }$ with $m = 2$ . Then we have $\tilde { \pi } = ( 1 , 2 )$ and $\gamma = \left( 1 , 2 \right)$ such that $\gamma \tilde { \pi } = ( 1 ) ( 2 )$ and $\# ( \gamma \tilde { \pi } ) = 2$ . If $m = 2 k$ we did $k - 1$ reductions where we reduced in each step the number of cycles by 1 and at the end we remain with 2 cycles, hence 

$$
\# (\gamma \pi) = (k - 1) \cdot 1 + 2 = k + 1 = \frac {m}{2} + 1.
$$

Here is an example for this: 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/bfde2f8e6b6f5bfe7ccbb513466021bfbfdcb1efc5c0ac419d12cece28346f09.jpg)


For a general $\pi \in \mathcal { P } _ { 2 } ( m )$ we remove cycles $( i , i + 1 )$ as long as possible. If $\pi$ is crossing we arrive at a pairing $\tilde { \pi }$ , where this is not possible anymore. It suffices to show that such a $\tilde { \pi } \in \mathcal { P } _ { 2 } ( m )$ satisfies $\# ( \gamma \tilde { \pi } ) - \textstyle \frac { m } { 2 } - 1 < 0$ . But since $\tilde { \pi }$ has no cycle $( i , i + 1 )$ , $\gamma \tilde { \pi }$ has no fixed point. Hence each cycle has at least 2 elements, thus 

$$
\# (\gamma \tilde {\pi}) \leq \frac {m}{2} <   \frac {m}{2} + 1.
$$

Note that in the above arguments, with $( i , i + 1 )$ we actually mean $( i , \gamma ( i ) )$ ; thus also $( 1 , m )$ counts as a pair of neighbors for a $\pi \in \mathcal { P } _ { 2 } ( m )$ , in order to have the characterization of fixed points right. Hence, when reducing a general pairing to one without fixed points we have also to remove such cyclic neighbors as long as possible. □ 

# 2.4 Semicircle law for GUE

Theorem 2.21 (Wigner’s semicircle law for GUE, averaged version). Let $A _ { N }$ be a Gaussian (GUE) $N \times N$ random matrix. Then we have for all $m \in \mathbb { N }$ : 

$$
\lim _ {N \to \infty} \mathbb {E} \left[ \mathrm {t r} \left(A _ {N} ^ {m}\right) \right] = \frac {1}{2 \pi} \int_ {- 2} ^ {2} x ^ {m} \sqrt {4 - x ^ {2}} \mathrm {d} x.
$$

Proof. This is true for $m$ odd, since then both sides are equal to zero. Consider $m = 2 k$ even. Then Theorem 2.15 and Proposition 2.20 show that 

$$
\lim  _ {\mathbb {N} \to \infty} \mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {m}\right) \right] = \sum_ {\pi \in \mathcal {P} _ {2} (m)} \lim  _ {N \to \infty} N ^ {\# (\gamma \pi) - \frac {m}{2} - 1} = \sum_ {\pi \in \mathcal {N C} _ {2} (m)} 1 = \# \mathcal {N C} _ {2} (m).
$$

Since the moments of the semicircle are given by the Catalan numbers, it remains to see that $\# \mathcal { N C } _ { 2 } ( 2 k )$ is equal to the Catalan number $C _ { k }$ . To see this, we now count $d _ { k } : = \# \mathcal { N C } _ { 2 } ( 2 k )$ according to the recursive structure of NC-pairings as in 2.19 (i). 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/5cde595802c811a5f3aee1ec580461b761f2045b08ac0ce2d501e904774278a5.jpg)


Namely, we can identify $\pi \in \mathcal { N C } _ { 2 } ( 2 k )$ with $\{ ( 1 , 2 l ) \} \cup \pi _ { 0 } \cup \pi _ { 1 }$ , where $l \in \{ 1 , \ldots , k \}$ , $\pi _ { 0 } \in \mathcal { N C } _ { 2 } ( 2 ( l - 1 ) )$ and $\pi _ { 1 } \in \mathcal { N C } _ { 2 } ( 2 ( k - l ) )$ . Hence we have 

$$
d _ {k} = \sum_ {l = 1} ^ {k} d _ {l - 1} d _ {k - l}, \qquad \text {w h e r e} d _ {0} = 1.
$$

This is the recursion for the Catalan numbers, whence $d _ { k } = C _ { k }$ for all $k \in \mathbb N$ . 

Remark 2.22. (1) One can refine 

$$
\# (\gamma \pi) - \frac {m}{2} - 1 \leq 0 \quad \mathrm {t o} \quad \# (\gamma \pi) - \frac {m}{2} - 1 = - 2 g (\pi)
$$

for $g ( \pi ) \in \mathbb { N } _ { 0 }$ . This $g$ has the meaning that it is the minimal genus of a surface on which $\pi$ can be drawn without crossings. NC pairings are also called planar, they correspond to $g = 0$ . Theorem 2.15 is usually addressed as genus expansion, 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {m}\right) \right] = \sum_ {\pi \in \mathcal {P} _ {2} (m)} N ^ {- 2 g (\pi)}.
$$

(2) For example, $( 1 , 2 ) ( 3 , 4 ) \in \mathcal { N C } _ { 2 } ( 4 )$ has $g = 0$ , but the crossing pairing $( 1 , 3 ) ( 2 , 4 ) \in$ $\mathcal { P } _ { 2 } ( 4 )$ has genus $g = 1$ . It has a crossing in the plane but this can be avoided on a torus. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/3dcf576a44261c8af6372e2af288549e45784aef80e599d349969839a39baa74.jpg)


(3) If we denote 

$$
\varepsilon_ {g} (k) = \# \left\{\pi \in \mathcal {P} _ {2} (2 k) \mid \pi \text {h a s g e n u s} g \right\}
$$

then the genus expansion 2.15 can be written as 

$$
\mathbb {E} \left[ \mathrm {t r} (A _ {N} ^ {2 k}) \right] = \sum_ {g \geq 0} \varepsilon_ {g} (k) N ^ {- 2 g}.
$$

We know that 

$$
\varepsilon_ {g} (0) = C _ {k} = \frac {1}{k + 1} \binom {2 k} {k},
$$

but what about the $\varepsilon _ { g } ( k )$ for $g > 0$ ? There does not exist an explicit formula for them, but Harer and Zagier have shown in 1986 that 

$$
\varepsilon_ {g} (k) = \frac {(2 k) !}{(k + 1) ! (k - 2 g) !} \cdot \lambda_ {g} (k),
$$

where $\lambda _ { g } ( k )$ is the coefficient of $x ^ { 2 g }$ in 

$$
\left(\frac {\frac {x}{2}}{\tanh  \frac {x}{2}}\right) ^ {k + 1}.
$$

We will come back later to this statement of Harer and Zagier; see Theorem 9.2 

# 3 Wigner Matrices: Combinatorial Proof of Wigner’s Semicircle Law

Wigner’s semicircle law does not only hold for Gaussian random matrices, but more general for so-called Wigner matrices; there we keep the independence and identical distribution of the entries, but allow arbitrary distribution instead of Gaussian. As there is no Wick formula any more, there is no clear advantage of the complex over the real case any more, hence we will consider in the following the real one. 

# 3.1 Wigner matrices

Definition 3.1. Let $\mu$ be a probability distribution on $\mathbb { R }$ . A corresponding Wigner random matrix is of the form $\begin{array} { r } { A _ { N } = \frac { 1 } { \sqrt { N } } \left( a _ { i j } \right) _ { i , j = 1 } ^ { N } } \end{array}$ , where 

• $A _ { N } = A _ { N } ^ { * }$ , i.e., $a _ { i j } = a _ { j i }$ for all $i , j$ 

• $\{ a _ { i j } | i \geq j \}$ are independent, 

• each $a _ { i j }$ has distribution $\mu$ 

Remark 3.2. (1) In our combinatorial setting we will assume that all moments of $\mu$ exist; that the first moment is 0; and the second moment will be normalized to 1. In an analytic setting one can deal with more general situations: usually only the existence of the second moment is needed; and one can also allow non-vanishing mean. 

(2) Often one also allows different distributions for the diagonal and the offdiagonal entries. 

(3) Even more general, one can give up the assumption of identical distribution of all entries and replace this by uniform bounds on their moments. 

(4) We will now try to imitate our combinatorial proof from the Gaussian case also in this more general situation. Without a precise Wick formula for the higher moments of the entries, we will not aim at a precise genus expansion; 

it suffices to see that the leading contributions are still given by the Catalan numbers. 

# 3.2 Combinatorial description of moments of Wigner matrices

Consider a Wigner matrix $\begin{array} { r } { A _ { N } = \frac { 1 } { \sqrt { N } } \left( a _ { i j } \right) _ { i , j = 1 } ^ { N } } \end{array}$ , where $\mu$ has all moments and 

$$
\int_ {\mathbb {R}} x \mathrm {d} \mu (x) = 0, \quad \int_ {\mathbb {R}} x ^ {2} \mathrm {d} \mu (x) = 1.
$$

Then 

$$
\mathbb{E}\left[\mathrm{tr}(A_{N}^{m})\right] = \frac{1}{N^{1 + \frac{m}{2}}}\sum_{i_{1},\ldots ,i_{m} = 1}^{N}\mathbb{E}\left[a_{i_{1}i_{2}}a_{i_{2}i_{3}}\dots a_{i_{m}i_{1}}\right] = \frac{1}{N^{1 + \frac{m}{2}}}\sum_{\sigma \in \mathcal{P}(m)}\sum_{\substack{i: [m]\to [N]\\ \ker i = \sigma}}\mathbb{E}\left[\sigma \right],
$$

where we group the appearing indices $( i _ { 1 } , \ldots , i _ { m } )$ according to their “kernel”, which is a “partition $\sigma$ of $\{ 1 , \ldots , m \}$ . 

Definition 3.3. (1) A partition $\sigma$ of $[ n ]$ is a decomposition of $[ n ]$ into disjoint, non-empty subsets (of arbitrary size), i.e., $\sigma = \{ V _ { 1 } , \ldots , V _ { k } \}$ , where 

• $V _ { i } \subset [ n ]$ for all $i$ 

• $V _ { i } \neq \emptyset$ for all $i$ 

• $V _ { i } \cap V _ { j } = \emptyset$ for all $i \neq j$ 

• $\cup _ { i = 1 } ^ { k } V _ { i } = [ n ]$ 

The $V _ { i }$ are called blocks of $\sigma$ . The set of all partitions of $[ n ]$ is denoted by 

$$
\mathcal {P} (n) := \left\{\sigma \mid \sigma \text {i s a p a r t i t i o n o f} [ n ] \right\}.
$$

(2) For a multi-index $i = ( i _ { 1 } , \dots , i _ { m } ) $ we denote by $\ker i$ its kernel; this is the partition $\sigma \in \mathcal { P } ( m )$ such that we have $i _ { k } = i _ { l }$ if and only if $k$ and $l$ are in the same block of $\sigma$ . If we identify $i$ with a function $i \colon [ m ]  [ N ]$ via $i ( k ) = i _ { k }$ then we can also write 

$$
\ker i = \left\{i ^ {- 1} (1), i ^ {- 1} (2), \dots , i ^ {- 1} (N) \right\},
$$

where we discard all empty sets. 

Example 3.4. For $i = ( 1 , 2 , 1 , 3 , 2 , 4 , 2 )$ we have 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/052826c209995097a15df8002ec41ee2eb26d37d4e28562493072e874ec80452.jpg)


such that 

$$
\ker i = \{(1, 3), (2, 5, 7), (4), (6) \} \in \mathcal {P} (7).
$$

Remark 3.5. The relevance of this kernel in our setting is the following: 

For $i = ( i _ { 1 } , \dots , i _ { m } )$ and $j = ( j _ { 1 } , \dots , j _ { m } )$ with $\ker i = \ker j$ we have 

$$
\mathbb {E} \left[ a _ {i _ {1} i _ {2}} a _ {i _ {2} i _ {3}} \cdot \cdot \cdot a _ {i _ {m} i _ {1}} \right] = \mathbb {E} \left[ a _ {j _ {1} j _ {2}} a _ {j _ {2} j _ {3}} \cdot \cdot \cdot a _ {j _ {m} j _ {1}} \right].
$$

For example, for $i = ( 1 , 1 , 2 , 1 , 1 , 2 )$ and $j = ( 2 , 2 , 7 , 2 , 2 , 7 )$ we have 

$$
\ker i = \begin{array}{c c c c c c} 1 & 2 & 3 & 4 & 5 \\ \bullet & \bullet & \bullet & \bullet & \bullet \\ \hline \end{array} \begin{array}{c c c c c c} 6 \\ \bullet & \bullet & \bullet & \bullet \\ \hline \end{array} = \ker j
$$

and 

$$
\mathbb {E} \left[ a _ {1 1} a _ {1 2} a _ {2 1} a _ {1 1} a _ {1 2} a _ {2 1} \right] = \mathbb {E} \left[ a _ {1 1} ^ {2} \right] \mathbb {E} \left[ a _ {1 2} ^ {4} \right] = \mathbb {E} \left[ a _ {2 2} ^ {2} \right] \mathbb {E} \left[ a _ {2 7} ^ {4} \right] = \mathbb {E} \left[ a _ {2 2} a _ {2 7} a _ {7 2} a _ {2 2} a _ {2 7} a _ {7 2} \right].
$$

We denote this common value by 

$$
\mathbb {E} \left[ \sigma \right] := \mathbb {E} \left[ a _ {i _ {1} i _ {2}} a _ {i _ {2} i _ {3}} \dots a _ {i _ {m} i _ {1}} \right] \qquad \text {i f k e r} i = \sigma .
$$

Thus we get: 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {m}\right)\right] = \frac {1}{N ^ {1 + \frac {m}{2}}} \sum_ {\sigma \in \mathcal {P} (m)} \mathbb {E} \left[ \sigma \right] \cdot \# \left\{i: [ m ] \rightarrow [ N ] \mid \ker i = \sigma \right\}.
$$

To understand the contribution corresponding to a $\sigma \in \mathcal P ( m )$ we associate to $\sigma$ a graph $\mathcal { G } _ { \sigma }$ . 

Definition 3.6. For $\sigma = \{ V _ { 1 } , \ldots , V _ { k } \} \in { \mathcal { P } } ( m )$ we define a corresponding graph $\scriptstyle { \mathcal { G } } _ { \sigma }$ as follows. The vertices of $\mathcal { G } _ { \sigma }$ are given by the blocks $V _ { p }$ of $\sigma$ and there is an edge betwees $V _ { p }$ and $V _ { q }$ if there is an $r \in [ m ]$ such that $r \in V _ { p }$ and $r + 1 ( \mathrm { m o d } \ m ) \in V _ { q }$ . 

Another way of saying this is that we start with a graph with vertices $1 , 2 , \ldots , m$ and edges $( 1 , 2 ) , ( 2 , 3 ) , ( 3 , 4 ) , \ldots , ( m - 1 , m ) , ( m , 1 )$ and then identify vertices according to the blocks of $\sigma$ . We keep loops, but erase multiple edges. 

Example 3.7. (1) For 

$$
\sigma = \{(1, 3), (2, 5), (4) \} = \boxed {\lceil \begin{array}{c c c} & & \end{array} \rceil}
$$

we have 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/455c32ba8570f4f94d715d6d39eb5aa6b805616a4bc3ed7684005a9ac3047cbc.jpg)


(2) For 

$$
\sigma = \{(1, 5), (2, 4), (3) \} = \left\lfloor \begin{array}{c c c} & & \\ & \left\lfloor & \mid \\ & & \end{array} \right\rfloor \end{array} \right\rfloor
$$

we have 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/bb3e21cf1d18b6051e3fa4186ca896519a8f67fb492717e7bb7e62928941e5ee.jpg)


(3) For 

$$
\sigma = \{(1, 3), (2), (4) \} = \left\lfloor \begin{array}{c c} \mid & \mid \\ \hline \end{array} \right\rfloor
$$

we have 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/846c20b24dc78912824ca3b6c7a73e4519d3c42062d9d04f320f63d6375d7246.jpg)


The term $\mathbb { E } \left[ a _ { i _ { 1 } i _ { 2 } } a _ { i _ { 2 } i _ { 3 } } \cdot \cdot \cdot a _ { i _ { m } i _ { 1 } } \right]$ corresponds now to a walk in $\mathcal { G } _ { \sigma }$ , with $\sigma = \ker i$ along the edges with steps 

$$
i _ {1} \rightarrow i _ {2} \rightarrow i _ {3} \rightarrow \dots \rightarrow i _ {m} \rightarrow i _ {1}.
$$

Hence we are using each edge in $\mathcal { G } _ { \sigma }$ at least once. Note that different edges in $\mathcal { G } _ { \sigma }$ correspond to independent random variables. Hence, if we use an edge only once in 

our walk, then $\mathbb { E } \left[ { \boldsymbol { \sigma } } \right] = 0$ , because the expectation factorizes into a product with one factor being the first moment of $a _ { i j }$ , which is assumed to be zero. Thus, every edge must be used at least twice, but this implies 

$$
\# \mathrm {e d g e s i n} \mathcal {G} _ {\sigma} \leq \frac {\# \mathrm {s t e p s i n t h e w a l k}}{2} = \frac {m}{2}.
$$

Since the number of $i$ with the same kernel is 

$$
\# \left\{i \colon [ m ] \to [ N ] \mid \ker i = \sigma \right\} = N (N - 1) (N - 2) \dots (N - \# \sigma + 1),
$$

where $\# \sigma$ is the number of blocks in $\sigma$ , we finally get 

$$
\mathbb{E}\left[\operatorname {tr}\left(A_{N}^{m}\right)\right] = \frac{1}{N^{1 + \frac{m}{2}}}\sum_{\substack{\sigma \in \mathcal{P}(m)\\ \# \operatorname {edges}(\mathcal{G}_{\sigma})\leq \frac{m}{2}}}\mathbb{E}\left[\sigma \right]\underbrace{N(N - 1)(N - 2)\cdots(N - \# \sigma + 1)}_{\sim N^{\# \sigma}\text{for} N\to \infty}. \quad (\star)
$$

We have to understand what the constraint on the number of edges in $\mathcal { G } _ { \sigma }$ gives us for the number of vertices in $\mathcal { G } _ { \sigma }$ (which is the same as $\# \sigma$ ). For this, we will now use the following well-known basic result from graph theory. 

Proposition 3.8. Let $\mathcal { G } = ( V , E )$ be a connected finite graph with vertices $V$ and edges $E$ . (We allow loops and multi-edges.) Then we have that 

$$
\# V \leq \# E + 1
$$

and we have equality if and only if $\mathscr { G }$ is $a$ tree, i.e., a connected graph without cycles. 

# 3.3 Semicircle law for Wigner matrices

Theorem 3.9 (Wigner’s semicircle law for Wigner matrices, averaged version). Let $A _ { N }$ be a Wigner matrix corresponding to $\mu$ , which has all moments, with mean 0 and second moment 1. Then we have for all $m \in \mathbb { N }$ : 

$$
\lim _ {N \to \infty} \mathbb {E} \left[ \mathrm {t r} \left(A _ {N} ^ {m}\right) \right] = \frac {1}{2 \pi} \int_ {- 2} ^ {2} x ^ {m} \sqrt {4 - x ^ {2}} \mathrm {d} x.
$$

Proof. From ( $\star$ ) we get 

$$
\lim _ {N \to \infty} \mathbb {E} \left[ \mathrm {t r} \left(A _ {N} ^ {m}\right) \right] = \sum_ {\sigma \in \mathcal {P} (m)} \mathbb {E} \left[ \sigma \right] \lim _ {N \to \infty} N ^ {\# V (\mathcal {G} _ {\sigma}) - \frac {m}{2} - 1}.
$$

In order to have $\mathbb { E } \left[ \sigma \right] \neq 0$ , we can restrict to $\sigma$ with $\# E ( \mathcal G _ { \sigma } ) \ \leq \ \frac { m } { 2 }$ , which by Proposition 3.8 implies that 

$$
\# V (\mathcal {G} _ {\sigma}) \leq \# E (\mathcal {G} _ {\sigma}) + 1 \leq \frac {m}{2} + 1.
$$

Hence all terms converge and the only contribution in the limit $N  \infty$ comes from those $\sigma$ , where we have equality, i.e., 

$$
\# V (\mathcal {G} _ {\sigma}) = \# E (\mathcal {G} _ {\sigma}) + 1 = \frac {m}{2} + 1.
$$

Thus, $\mathcal { G } _ { \sigma }$ must be a tree and in our walk we use each edge exactly twice (necessarily in opposite directions). For such a $\sigma$ we have $\mathbb { E } \left[ \sigma \right] = 1$ ; thus 

$$
\lim _ {N \to \infty} \mathbb {E} \left[ \operatorname {t r} \left(A _ {N} ^ {m}\right) \right] = \# \left\{\sigma \in \mathcal {P} (m) \mid \mathcal {G} _ {\sigma} \text {i s a t r e e} \right\}.
$$

We will check in Exercise 9 that the latter number is also counted by the Catalan numbers. □ 

Remark 3.10. Note that our $\mathcal { G } _ { \sigma }$ are not just abstract trees, but they are coming with the walks, which encode 

• a starting point, i.e., the $\mathcal { G } _ { \sigma }$ are rooted trees 

• a cyclic order of the outgoing edges at a vertex, which gives a planar drawing of our graph 

Hence what we have to count are rooted planar trees. 

Note also that a rooted planar tree determines uniquely the corresponding walk. 

# 4 Analytic Tools: Stieltjes Transform and Convergence of Measures

Let us recall our setting and goal. We have, for each $N \in \mathbb { N }$ , selfadjoint $N \times N$ random matrices, which are given by a probability measure $\mathbb { P } _ { N }$ on the entries of the matrices; the prescription of $\mathbb { P } _ { N }$ should be kind of uniform in $N$ . 

For example, for the gue(n) we have √ $A = ( a _ { i j } ) _ { i , j = 1 } ^ { N }$ with the complex variables $a _ { i j } = x _ { i j } + \sqrt { - 1 } y _ { i j }$ having real part $x _ { i j }$ and imaginary part $y _ { i j }$ . Since $a _ { i j } = a _ { j i }$ , we have $y _ { i i } = 0$ for all $i$ and we remain with the $N ^ { 2 }$ many “free variables” $x _ { i i }$ $( i = 1 , \ldots , N )$ and $x _ { i j } , y _ { i j }$ ( $1 \leq i < j \leq N$ ). All those are independent and Gaussian distributed, which can be written in the compact form 

$$
d \mathbb {P} (A) = c _ {N} \exp (- N \frac {\mathrm {T r} (A ^ {2})}{2}) d A,
$$

where $d A$ is the product of all differentials of the $N ^ { 2 }$ variables and $c _ { N }$ is a normalization constant, to make $\mathbb { P } _ { N }$ a probability measure. 

We want now statements about our matrices with respect to this measure $\mathbb { P } _ { N }$ , either in average or in probability. Let us be a bit more specific on this. 

Denote by $\Omega _ { N }$ the space of our selfadjoint $N \times N$ matrices, i.e., 

$$
\Omega_ {N} := \{A = (x _ {i j} + \sqrt {- 1} y _ {i j}) _ {i, j = 1} ^ {N} \mid x _ {i i} \in \mathbb {R} (i = 1, \ldots , N), x _ {i j}, y _ {i j} \in \mathbb {R} (i <   j) \} \hat {=} \mathbb {R} ^ {N ^ {2}},
$$

then, for each $N \in  { \mathbb { N } }$ , $\mathbb { P } _ { N }$ is a probability measure on $\Omega _ { N }$ . 

For $A \in \Omega _ { N }$ we consider its $N$ eigenvalues $\lambda _ { 1 } , \ldots , \lambda _ { N }$ , counted with multiplicity. We encode those eigenvalues in a probability measure $\mu _ { A }$ on $\mathbb { R }$ : 

$$
\mu_ {A} := \frac {1}{N} (\delta_ {\lambda_ {1}} + \dots + \delta_ {\lambda_ {N}}),
$$

which we call the eigenvalue distribution of $A$ . Our claim is now that $\mu _ { A }$ converges under $\mathbb { P } _ { N }$ , for $N \to \infty$ to the semicircle distribution $\mu _ { W }$ , 

• in average, i.e., 

$$
\mu_ {N} := \int_ {\Omega_ {N}} \mu_ {A} d \mathbb {P} _ {N} (A) = \mathbb {E} [ \mu_ {a} ] \stackrel {N \rightarrow \infty} {\longrightarrow} \mu_ {W}
$$

• and, stronger, in probability or almost surely. 

So what we have to understand now is: 

• What kind of convergence $\mu _ { N }  \mu$ do we have here, for probability measures on $\mathbb { R }$ ? 

• How can we describe probability measures (on $\mathbb { R }$ ) and their convergence with analytic tools? 

The relevant notions of convergence are the “vague” and ”weak” convergence and our analytic tool will be the Stieltjes transform. We start with describing the latter. 

# 4.1 Stieltjes transform

Definition 4.1. Let $\mu$ be a Borel measure on $\mathbb { R }$ 

(1) $\mu$ is finite if $\mu ( \mathbb { R } ) < \infty$ 

(2) $\mu$ is a probability measure if $\mu ( \mathbb { R } ) = 1$ 

(3) For a finite measure $\mu$ on $\mathbb { R }$ we define its Stieltjes transform $S _ { \mu }$ on $\mathbb { C } \backslash \mathbb { R }$ by 

$$
S _ {\mu} (z) = \int_ {\mathbb {R}} \frac {1}{t - z} d \mu (t) \quad (z \in \mathbb {C} \backslash \mathbb {R}).
$$

(4) $- S _ { \mu } = G _ { \mu }$ is also called the Cauchy transform. 

Theorem 4.2. The Stieltjes transform has the following properties. 

(1) Let $\mu$ be a finite measure on $\mathbb { R }$ and $S = S _ { \mu }$ its Stieltjes transform. Then one has: 

(i) $S : \mathbb { C } ^ { + } \to \mathbb { C } ^ { + }$ , where $\mathbb { C } ^ { + } : = \{ z \in \mathbb { C } \mid \operatorname { I m } ( z ) > 0 \}$ 

(ii) $S$ is analytic on $\mathbb { C } ^ { + }$ ; 

(iii) $\begin{array} { r } { \operatorname* { l i m } _ { y \to \infty } i y S ( i y ) = - \mu ( \mathbb { R } ) } \end{array}$ 

(2) $\mu$ can be recovered from $S _ { \mu }$ via the Stieltjes inversion formula: for $a < b$ we have 

$$
\lim _ {\varepsilon \searrow 0} \frac {1}{\pi} \int_ {a} ^ {b} \mathrm {I m} S _ {\mu} (x + i \varepsilon) d x = \mu ((a, b)) + \frac {1}{2} \mu (\{a, b \}).
$$

(3) In particular, we have for two finite measures $\mu$ and $\nu$ : $S _ { \mu } = S _ { \nu }$ implies that $\mu = \nu$ . 

Proof. (1) This is Exercise 10. 

(2) We have 

$$
\operatorname {I m} S _ {\mu} (x + i \varepsilon) = \int_ {\mathbb {R}} \operatorname {I m} \left(\frac {1}{t - x - i \varepsilon}\right) d \mu (t) = \int_ {\mathbb {R}} \frac {\varepsilon}{(t - x) ^ {2} + \varepsilon} d \mu (t)
$$

and thus 

$$
\int_ {a} ^ {b} \operatorname {I m} S _ {\mu} (x + i \varepsilon) d x = \int_ {\mathbb {R}} \int_ {a} ^ {b} \frac {\varepsilon}{(t - x) ^ {2} + \varepsilon^ {2}} d x d \mu (t).
$$

For the inner integral we have 

$$
\begin{array}{l} \int_ {a} ^ {b} \frac {\varepsilon}{(t - x) ^ {2} + \varepsilon^ {2}} d x = \int_ {(a - b) / \varepsilon} ^ {(b - t) / \varepsilon} \frac {1}{x ^ {2} + 1} d x = \tan^ {- 1} \left(\frac {b - t}{\varepsilon}\right) - \tan^ {- 1} \left(\frac {a - t}{\varepsilon}\right) \\ \xrightarrow {\varepsilon \searrow 0} \left\{ \begin{array}{l l} 0, & t \notin [ a, b ] \\ \pi / 2, & t \in \{a, b \} \\ \pi , & t \in (a, b) \end{array} \right. \\ \end{array}
$$

From this the assertion follows. 

(3) Now assume that $S _ { \mu } = S _ { \nu }$ . By the Stieltjes inversion formula it follows then that $\mu ( ( a , b ) ) = \nu ( ( a , b ) )$ for all open intervals such that $a$ and $b$ are atoms neither of $\mu$ nor of $\nu$ . Since there can only be countably many atoms we can write any interval as 

$$
(a, b) = \bigcup_ {n = 1} ^ {\infty} (a + \varepsilon_ {n}, b - \varepsilon_ {n}),
$$

where the sequence $\varepsilon _ { n } ~ \searrow ~ 0$ is chosen such that all $a + \varepsilon _ { n }$ and $b - \varepsilon _ { n }$ are no atoms of $\mu$ nor $\nu$ . By monotone convergence for measures we get then 

$$
\mu ((a, b) = \lim _ {n \to \infty} \mu ((a + \varepsilon_ {n}, b - \varepsilon_ {n})) = \lim _ {n \to \infty} \nu ((a + \varepsilon_ {n}, b - \varepsilon_ {n})) = \nu ((a, b)).
$$

Remark 4.3. If we put $\mu _ { \varepsilon } = p _ { \varepsilon } \lambda$ (where $\lambda$ is Lebesgue measure) with density 

$$
p _ {\varepsilon} (x) := \frac {1}{\pi} \mathrm {I m} S _ {\mu} (x + i \varepsilon) = \frac {1}{\pi} \int_ {\mathbb {R}} \frac {\varepsilon}{(t - x) ^ {2} + \varepsilon^ {2}} d \mu (t),
$$

then $\mu _ { \varepsilon } = \gamma _ { \varepsilon } * \mu$ , where $\gamma _ { \varepsilon }$ is the Cauchy distribution, and we have checked explicitly in our proof of the Stieltjes inversion formula the well-known fact that $\gamma _ { \varepsilon } \ast \mu$ converges weakly to $\mu$ for $\varepsilon \searrow 0$ . We will talk about weak convergence later, see Definition 4.7. 

Proposition 4.4. Let µ be a compactly supported probability measure, say $\mu ( [ - r , r ] ) =$ 1 for some $r > 0$ . Then $S _ { \mu }$ has a power series expansion (about $\infty$ ) as follows 

$$
S _ {\mu} (z) = - \sum_ {n = 0} ^ {\infty} \frac {m _ {n}}{z ^ {n + 1}} \qquad f o r | z | > r,
$$

where $\begin{array} { r } { m _ { n } : = \int _ { \mathbb { R } } t ^ { n } d \mu ( t ) } \end{array}$ are the moments of $\mu$ . 

Proof. For $| z | > r$ we can expand 

$$
{\frac {1}{t - z}} = - {\frac {1}{z (1 - {\frac {t}{z}})}} = - {\frac {1}{z}} \sum_ {n = 0} ^ {\infty} \left({\frac {t}{z}}\right) ^ {n}
$$

for all $t \in [ - r , r ]$ ; the convergence on $[ - r , r ]$ is uniform, hence 

$$
S _ {\mu} (z) = \int_ {- r} ^ {r} \frac {1}{t - z} d \mu (t) = - \sum_ {n = 0} ^ {\infty} \int_ {- r} ^ {r} \frac {t ^ {n}}{z ^ {n + 1}} d \mu (t) = - \sum_ {n = 0} ^ {\infty} \frac {m _ {n}}{z ^ {n + 1}}.
$$

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/822712f50d2ef0dbc6c8c7b936f250ba06158d7ada891285c92aa64a3743806a.jpg)


Proposition 4.5. The Stieltjes transform $S ( z )$ of the semicircle distribution, $d \mu _ { W } ( t ) =$ $\textstyle { \frac { 1 } { 2 \pi } } { \sqrt { t ^ { 2 } - 4 } } d t$ , is, for $z \in \mathbb { C } ^ { + }$ , uniquely determined by 

• $S ( z ) \in \mathbb { C } ^ { + }$ 

• $S ( z )$ is the solution of the equation $S ( z ) ^ { 2 } + z S ( z ) + 1 = 0$ 

Explicitly, this means 

$$
S (z) = \frac {- z + \sqrt {z ^ {2} - 4}}{2} \qquad (z \in \mathbb {C} ^ {+}).
$$

Proof. By Proposition 4.4, we know that for large $| z |$ : 

$$
S (z) = - \sum_ {k = 0} ^ {\infty} \frac {C _ {k}}{z ^ {2 k + 1}},
$$

where $C _ { k }$ are the Catalan numbers. By using the recursion for the Catalan numbers (see Theorem 1.6), this implies that for large $| z |$ we have $S ( z ) ^ { 2 } + z S ( z ) + 1 = 0$ . Since we know that $S$ is analytic on $\mathbb { C } ^ { + }$ , this equation is, by analytic extension, then valid for all $z \in \mathbb { C } ^ { + }$ . 

This equation has two solutions, $( - z \pm \sqrt { z ^ { 2 } - 4 } ) / 2$ , and only the one with the +-sign is in $\mathbb { C } ^ { + }$ . □ 

Remark 4.6. Proposition 4.5 gave us the Stieltjes transform of $\mu _ { W }$ just from the knowledge of the moments. From $S ( z ) = ( - z - \sqrt { z ^ { 2 } - 4 } ) / 2$ we can then get the density of $\mu _ { W }$ via the Stieltjes inversion formula: 

$$
\frac {1}{\pi} \operatorname {I m} S (x + i \varepsilon) = \frac {1}{2 \pi} \operatorname {I m} \sqrt {(x + i \varepsilon) ^ {2} - 4} \stackrel {\varepsilon \searrow 0} {\longrightarrow} \frac {1}{2 \pi} \operatorname {I m} \sqrt {x ^ {4} - 4} = \left\{ \begin{array}{l l} 0, & | x | > 2 \\ \frac {1}{2 \pi} \sqrt {4 - x ^ {2}}, & | x | \leq 2. \end{array} \right.
$$

Thus this analytic machinery gives an effective way to calculate a distribution from its moments (without having to know the density in advance). 

# 4.2 Convergence of probability measures

Now we want to consider the convergence $\mu _ { N }  \mu$ . We can consider (probability) measures from two equivalent perspectives: 

(1) measure theoretic perspective: $\mu$ gives us the measure (probability) of sets, i.e., $\mu ( B )$ for measurable sets $B$ , or just $\mu$ (intervals) 

(2) functional analytic perspective: $\mu$ allows to integrate continuous functions, i.e, it gives us $\textstyle { \int f d \mu }$ for continuous $f$ 

According to this there are two canonical choices for a notion of convergence: 

(1) $\mu _ { N } ( B ) \to \mu ( B )$ for all measurable sets $B$ , or maybe for all intervals $B$ 

(2) $\textstyle \int f d \mu _ { N } \to \int f d \mu$ for all continuous $f$ 

The first possibility is problematic in this generality, as it does treat atoms too restrictive. 

Example: Take $\mu _ { N } = \delta _ { 1 - 1 / N }$ and $\mu = \delta _ { 1 }$ . Then we surely want that $\mu _ { N }  \mu$ , but for $B = [ 1 , 2 ]$ we have $\mu _ { N } ( [ 1 , 2 ] ) = 0$ for all $N$ , but $\mu ( [ 1 , 2 ] ) = 1$ . 

Thus the second possibility above is the better definition. But we have to be careful about which class of continuous functions we allow; we need bounded ones, otherwise $\textstyle { \int f d \mu }$ might not exist in general; and, for compactness reasons, it is sometimes better to ignore the behaviour of the measures at infinity. 

Definition 4.7. (1) We use the notations 

(i) $\begin{array} { r } { C _ { 0 } ( \mathbb { R } ) : = \{ f \in C ( \mathbb { R } ) \ | \ \operatorname* { l i m } _ { | t |  \infty } f ( t ) = 0 \} } \end{array}$ are the continuous functions on $\mathbb { R }$ vanishing at infinity 

(ii) $C _ { b } ( \mathbb { R } ) : = \{ f \in C ( \mathbb { R } ) \mid \exists M > 0 : | f ( t ) | \leq M \forall t \in \mathbb { R } \}$ are the continuous bounded functions on $\mathbb { R }$ 

(2) Let $\mu$ and $\mu _ { N }$ ( $N \in N$ ) be finite measures. Then we say that 

(i) $\mu _ { N }$ converges vaguely to $\mu$ , denoted by $\mu _ { N } \xrightarrow [ ] { v } \mu$ , if 

$$
\int f (t) d \mu (t) \to \int f (t) d \mu (t) \qquad \mathrm {f o r a l l} f \in C _ {0} (\mathbb {R});
$$

(ii) µN converges weakly to $\mu$ , denoted by $\mu _ { N } \xrightarrow [ ] { w } \mu$ , if 

$$
\int f (t) d \mu_ {N} (t) \rightarrow \int f (t) d \mu (t) \qquad \mathrm {f o r a l l} f \in C _ {b} (\mathbb {R}).
$$

Remark 4.8. (1) Note that weak convergence includes in particular that 

$$
\mu_ {N} (\mathbb {R}) = \int 1 d \mu_ {N} (t) \rightarrow \int 1 d \mu (t) = \mu (\mathbb {R}),
$$

and thus the weak limit of probability measures must again be a probability measure. For the vague convergence this is not true; there we can loose mass at infinity. 

Example: Consider $\mu _ { N } = { \textstyle { \frac { 1 } { 2 } } } \delta _ { 1 } + { \textstyle { \frac { 1 } { 2 } } } \delta _ { N }$ and $\begin{array} { r } { \mu = \frac { 1 } { 2 } \delta _ { 1 } } \end{array}$ ; then 

$$
\int f (t) d \mu_ {N} (t) = \frac {1}{2} f (1) + \frac {1}{2} f (N) \rightarrow \frac {1}{2} f (1) = \int f (t) d \mu (t)
$$

for all $f \in C _ { 0 } ( \mathbb { R } )$ . Thus the sequence of probability measures $\mathit { \Pi } _ { \overline { { 2 } } } ^ { \perp } \delta _ { 1 } + \mathit { \Pi } _ { \overline { { 2 } } } ^ { \perp } \delta _ { N }$ converges, for $N  \infty$ , to the finite measure $\textstyle { \frac { 1 } { 2 } } \delta _ { 1 }$ with total mass $1 / 2$ . 

(2) The relevance of the vague convergence, even if we are only interested in probability measures, is that the probability measures are precompact in the vague topology, but not in the weak topology. E.g., in the above example, $\mu _ { N } = { \textstyle { \frac { 1 } { 2 } } } \delta _ { 1 } + { \textstyle { \frac { 1 } { 2 } } } \delta _ { N }$ has no subsequence which converges weakly (but it has a subsequence, namely itself, which converges vaguely). 

Theorem 4.9. The space of probability measures on $\mathbb { R }$ is precompact in the vague topology: every sequence $( \mu _ { N } ) _ { N \in \mathbb { N } }$ of probability measures on $\mathbb { R }$ has a subsequence which converges vaguely to a finite measure $\mu$ , with $\mu ( \mathbb { R } ) \leq 1$ . 

Proof. (1) From a functional analytic perspective this is a special case of the Banach-Alaoglu theorem; since complex measures on $\mathbb { R }$ are the dual space of the Banach space $C _ { 0 } ( \mathbb { R } )$ , and its weak∗ topology is exactly the vague topology. 

(2) From a measure theory perspective this is known as Helly’s (Selection) Theorem. Here are the main ideas for the proof in this setting. 

(i) We describe a finite measure $\mu$ by its distribution function $F _ { \mu }$ , given by 

$$
F _ {\mu}: \mathbb {R} \to \mathbb {R}; \quad F _ {\mu} (t) := \mu ((- \infty , t ]).
$$

Such distribution functions can be characterized as functions $F$ with the properties: 

• $t \mapsto F ( t )$ is non-decreasing 

• $F ( - \infty ) : = \operatorname* { l i m } _ { t \to - \infty } F ( t ) = 0$ and $F ( + \infty ) : = \operatorname* { l i m } _ { t \to \infty } F ( t ) < \infty$ 

• $F ^ { \prime }$ is continuous on the right 

(ii) The vague convergence of $\mu _ { N } \xrightarrow [ ] { v } \mu$ can also be described in terms of their distribution functions $F _ { N }$ , $F$ ; $\mu _ { N } \xrightarrow [ ] { v } \mu$ is equivalent to: 

$$
F _ {N} (t) \to F (t) \qquad \mathrm {f o r a l l} t \in \mathbb {R} \mathrm {a t w h i c h} F \mathrm {i s c o n t i n u o u s}.
$$

(iii) Let now a sequence $( \mu _ { N } ) _ { N }$ of probability measures be given. We consider the corresponding distribution functions $( F _ { N } ) _ { N }$ and want to find a convergent subsequence (in the sense of (ii)) for those. 

For this choose a countable dense subset $T = \{ t _ { 1 } , t _ { 2 } , . . . \}$ of $\mathbb { R }$ . Then, by choosing subsequences of subsequences and taking the “diagonal” subsequence, we get convergence for all $t \in T$ . More precisely: Choose subsequence $\left( F _ { N _ { 1 } ( m ) } \right) _ { m }$ such that 

$$
F _ {N _ {1} (m)} (t _ {1}) \stackrel {m \rightarrow \infty} {\longrightarrow} F _ {T} (t _ {1}),
$$

choose then a subsequence $\big ( F _ { N _ { 2 } ( m ) } \big ) _ { m }$ of this such that 

$$
F _ {N _ {2} (m)} (t _ {1}) \stackrel {m \to \infty} {\longrightarrow} F _ {T} (t _ {1}), \qquad F _ {N _ {2} (m)} (t _ {2}) \stackrel {m \to \infty} {\longrightarrow} F _ {T} (t _ {2});
$$

iterating this gives subsequences $\left( F _ { N _ { k } \left( m \right) } \right) _ { m }$ such that 

$$
F _ {N _ {k} (m)} \left(t _ {i}\right) \stackrel {{m \rightarrow \infty}} {{\longrightarrow}} F _ {T} \left(t _ {i}\right) \qquad \text {f o r a l l} i = 1, \dots , k.
$$

The diagonal subsequence $( F _ { N _ { m } ( m ) } ) _ { m }$ converges then at all $t \in { \boldsymbol { I } } ^ { \prime }$ to $F _ { T } ( t )$ . We improve now $F _ { T }$ to the wanted $F$ by 

$$
F (t) := \inf  \left\{F _ {T} (s) \mid s \in T, s > t \right\}
$$

and show that 

• $F$ is a distribution function; 

• $F _ { N _ { m } ( m ) } ( t ) \stackrel { m  \infty } { \longrightarrow } F ( t )$ at all continuity points of $F$ 

According to (ii) this gives then the convergence $\mu _ { N _ { m } ( m ) } \stackrel { m  \infty } { \longrightarrow } \mu$ , where $\mu$ is the finite measure corresponding to the distribution function $F$ . Note that $F _ { N } ( + \infty ) \ = \ 1$ for all $N \in \mathbb { N }$ gives $F ( + \infty ) \leq 1$ , but we cannot guarantee $F ( + \infty ) = 1$ in general. 

Remark 4.10. If we want compactness in the weak topology, then we must control the mass at $\infty$ in a uniform way. This is given by the notion of tightness. A sequence $( \mu _ { N } ) _ { N }$ of probability measures is tight if: for all $\varepsilon > 0$ there exists an interval $I = \left\lfloor - R , R \right\rfloor$ such that $\mu _ { N } ( I ^ { c } ) < \varepsilon$ for all $N$ . 

Then one has: Any tight sequence of probability measures has a subsequence which converges weakly; the limit is then necessarily a probability measure. 

# 4.3 Probability measures determined by moments

We can now also relate weak convergence to convergence of moments; which shows that our combinatorial approach (using moments) and analytic approach (using Stieltjes transforms) for proving the semicircle law are essentially equivalent. We want to make this more precise in the following. 

Definition 4.11. A probability measure $\mu$ on $\mathbb { R }$ is determined by its moments if 

(i) all moments $\textstyle \int t ^ { k } d \mu ( t ) < \infty$ (k ∈ N) exist; 

(ii) $\mu$ is the only probability measure with those moments: if $\nu$ is a probability measure and $\textstyle \int t ^ { k } d \nu ( t ) = \int t ^ { k } d \mu ( t )$ for all $k \in \mathbb N$ , then $\nu = \mu$ . 

Theorem 4.12. Let $\mu$ and $\mu _ { N }$ ( $N \in \mathbb { N }$ ) be probability measures for which all moments exist. Assume that $\mu$ is determined by its moments. Assume furthermore that we have convergence of moments, i.e., 

$$
\lim  _ {N \rightarrow \infty} \int t ^ {k} d \mu_ {N} (t) = \int t ^ {k} d \mu (t) \qquad f o r a l l k \in \mathbb {N}.
$$

Then we have weak convergence: $\mu _ { N } \xrightarrow [ ] { w } \mu$ . 

Rough idea of proof. One has to note that convergence of moments implies tightness, which implies the existence of a weakly convergent subsequence, $\mu _ {  { N _ { m } } } \to \nu$ . Furthermore, the assumption that the moments converge implies that they are uniformly integrable, which implies then that the moments of this subsequence converge to the moments of $\nu$ . (These are kind of standard measure theoretic arguments, though a bit involved; for details see the book of Billingsley, in particular, his Theorem 25.12 and its Corollary.) However, the moments of the subsequence converge, as the moments of the whole sequence, by assumption to the moments of $\mu$ ; this means that $\mu$ and $\nu$ have the same moments and hence, by our assumption that $\mu$ is determined by its moments, we have that $\nu = \mu$ . 

In the same way all weakly convergent subsequences of $( \nu _ { N } ) _ { N }$ must converge to the same $\mu$ , and thus the whole sequence must converge weakly to $\mu$ . 

Remark 4.13. (0) Note that in the first version of these notes (and also in the recorded lectures) it was claimed that, under the assumption that the limit is determined by its moments, convergence in moments is equivalent to weak convergence. This is clearly not true as the following simple example shows. Consider 

$$
\mu_ {N} = (1 - \frac {1}{N}) \delta_ {0} + \frac {1}{N} \delta_ {N} \qquad \text {a n d} \qquad \mu = \delta_ {0}.
$$

Then it is clear that $\mu _ { N } \xrightarrow [ ] { w } \mu$ , and $\mu$ is also determined by its moments. But there is no convergence of moments. For example, the first moment converges, but to the wrong limit 

$$
\int t d \mu_ {N} (t) = \frac {1}{N} N = 1 \rightarrow 1 \neq 0 = \int t d \mu (t),
$$

and the other moments explode 

$$
\int t ^ {k} d \mu_ {N} (t) = \frac {1}{N} N ^ {k} = N ^ {k - 1} \to \infty \qquad \mathrm {f o r} k \geq 2.
$$

In order to have convergence of moments one needs a uniform integrability assumption; see Billingsley, in particular, his Theorem 25.12 and its Corollary. 

(1) Note that there exist measures for which all moments exist but which, however, are not determined by their moments. Weak convergence to them cannot be checked by just looking on convergence of moments. 

Example: The log-normal distribution with density 

$$
d \mu (t) = \frac {1}{\sqrt {2 \pi}} \frac {1}{x} e ^ {- (\log x) ^ {2} / 2} d t \qquad \mathrm {o n} [ 0, \infty)
$$

(which is the distribution of $e ^ { X }$ for $X$ Gaussian) is not determined by its moments. 

(2) Compactly supported measures (like the semicircle) or also the Gaussian distribution are determined by their moments. 

# 4.4 Description of weak convergence via the Stieltjes transform

Theorem 4.14. Let $\mu$ and $\mu _ { N }$ ( $N \in \mathbb { N }$ ) be probability measures on $\mathbb { R }$ . Then the following are equivalent. 

(i) $\mu _ { N } \overset { w } { \to } \mu$ 

(ii) For all $z \in \mathbb { C } ^ { + }$ we have: $\begin{array} { r } { \operatorname* { l i m } _ { N \to \infty } S _ { \mu _ { N } } ( z ) = S _ { \mu } ( z ) } \end{array}$ 

(iii) There exists a set $D \subset \mathbb { C } ^ { + }$ , which has an accumulation point in $\mathbb { C } ^ { + }$ , such that: $\begin{array} { r } { \operatorname* { l i m } _ { N \to \infty } S _ { \mu N } ( z ) = S _ { \mu } ( z ) } \end{array}$ for al l $z \in D$ . 

Proof. • $( \mathrm { i } ) \Longrightarrow$ (ii): Assume that $\mu _ { N } \xrightarrow [ ] { w } \mu$ . For $z \in \mathbb { C } ^ { + }$ we consider 

$$
f _ {z}: \mathbb {R} \to \mathbb {C} \qquad \mathrm {w i t h} \qquad f _ {z} (t) = \frac {1}{t - z}.
$$

Since $\begin{array} { r } { \operatorname* { l i m } _ { | t | \to \infty } f _ { z } ( t ) = 0 } \end{array}$ , we have $f _ { z } \in C _ { 0 } ( \mathbb { R } ) \subset C _ { b } ( \mathbb { R } )$ and thus, by definition of weak convergence: 

$$
S _ {\mu_ {N}} (z) = \int f _ {z} (t) d \mu_ {N} (t) \rightarrow \int f _ {z} (t) d \mu (t) = S _ {\mu} (z).
$$

• (ii) =⇒ (iii): clear 

• (iii) =⇒ (i): By Theorem 4.9, we know that $( \mu _ { N } ) _ { N }$ has a subsequence $( \mu _ { N ( m ) } ) _ { m }$ which converges vaguely to some finite measure $\nu$ with $\nu ( \mathbb { R } ) \leq 1$ . Then, as above, we have for all $z \in \mathcal { D }$ : 

$$
S _ {\mu} (z) = \lim _ {m \to \infty} S _ {\mu_ {N} (m)} (z) = S _ {\nu} (z).
$$

Thus the analytic functions $S _ { \mu }$ and $S _ { \nu }$ agree on $D$ and hence, but the identity therem for analytic functions, also on $\mathbb { C } ^ { + }$ , i.e., $S _ { \mu } = S _ { \nu }$ . But this implies, by Theorem 4.2, that $\nu = \mu$ . 

Thus the subsequence $( \mu _ { N ( m ) } ) _ { m }$ converges vaguely to the probability measure $\mu$ (and thus also weakly, see Exercise 12). In the same way, any weak cluster point of $( \mu _ { N } ) _ { N }$ must be equal to $\mu$ , and thus the whole sequence must converge weakly to $\mu$ . 

Remark 4.15. If we only assume that $S _ { \mu _ { N } } ( z )$ converges to a limit function $S ( z )$ , then $S$ must be the Stieltjes transform of a measure $\nu$ with $\nu ( \mathbb { R } ) \leq 1$ and we have the vague convergence $\mu _ { N } \xrightarrow [ ] { v } \nu$ . 

# 5 Analytic Proof of Wigner’s Semicircle Law for Gaussian Random Matrices

Now we are ready to give an analytic proof of Wigner’s semicircle law, relying on the analytic tools we developed in the last chapter. As for the combinatorial approach, the Gaussian case is easier compared to the general Wigner case and thus we will restrict to this. The difference between real and complex is here not really relevant, instead of gue we will treat the goe case. 

# 5.1 GOE random matrices

Definition 5.1. Real Gaussian random matrices (goe) are of the form $A _ { N } \ =$ $( x _ { i j } ) _ { i , j = 1 } ^ { N }$ , where $x _ { i j } ~ = ~ x _ { j i }$ for all $i , j$ and $\{ x _ { i j } \mid i \le j \}$ are i.i.d. (independent identically distributed) random variables with Gaussian distribution of mean zero and variance $1 / N$ . More formaly, on the space of symmetric $N \times N$ matrices 

$$
\Omega_ {N} = \{A _ {N} = (x _ {i j}) _ {i, j = 1} ^ {N} \mid x _ {i j} \in \mathbb {R}, x _ {i j} = x _ {j i} \forall i, j \}
$$

we consider the probability measure 

$$
d \mathbb {P} _ {N} (A _ {N}) = c _ {N} \exp (- \frac {N}{4} \operatorname {T r} (A _ {N} ^ {2})) \prod_ {i \leq j} d x _ {i j},
$$

with a normalization constant $c _ { N }$ such that $\mathbb { P } _ { N }$ is a probability measure. 

Remark 5.2. (1) Note that with this choice of $\mathbb { P } _ { N }$ , which is invariant under orthogonal rotations, we have actually different variances on and off the diagonal: 

$$
\mathbb {E} \left[ x _ {i j} ^ {2} \right] = \frac {1}{N} (i \neq j) \mathrm {a n d} \mathbb {E} \left[ x _ {i i} ^ {2} \right] = \frac {2}{N}.
$$

(2) We consider now, for each $N \in  { \mathbb { N } }$ , the averaged eigenvalue distribution 

$$
\mu_ {N} := \mathbb {E} \left[ \mu_ {A _ {N}} \right] = \int_ {\Omega_ {N}} \mu_ {A} d P _ {N} (A).
$$

We want to prove that $\mu _ { N } \stackrel { w } {  } \mu _ { W }$ . According to Theorem 4.14 we can prove this by showing $\begin{array} { r } { \operatorname* { l i m } _ { N \to \infty } S _ { \mu _ { N } } ( z ) = S _ { \mu _ { W } } ( z ) } \end{array}$ for all $z \in \mathbb { C } ^ { + }$ . 

(3) Note that 

$$
S _ {\mu_ {N}} (z) = \int_ {\mathbb {R}} \frac {1}{t - z} d \mu_ {N} (t) = \mathbb {E} \left[ \int_ {\mathbb {R}} \frac {1}{t - z} d \mu_ {A _ {N}} (t) \right] = \mathbb {E} \left[ \mathrm {t r} [ (A _ {N} - z 1) ^ {- 1} ] \right],
$$

since, by Assignement ...., $S _ { \mu _ { A _ { N } } } ( t ) = \mathrm { t r } [ ( A _ { N } - z 1 ) ^ { - 1 } ]$ . So what we have to see, is for all $z \in \mathbb { C } ^ { + }$ : 

$$
\lim  _ {N \to \infty} \mathbb {E} \left[ \operatorname {t r} [ (A _ {N} - z 1) ^ {1 -} ] \right] = S _ {\mu_ {W}} (z).
$$

For this, we want to see that $S _ { \mu _ { N } } ( z )$ satisfies approximately the quadratic equation for $S _ { \mu _ { W } } ( z )$ , from 4.5. 

(4) Let us use for the resolvents of our matrices $A$ the notation 

$$
R _ {A} (z) = \frac {1}{A - z 1}, \qquad \mathrm {s o t h a t} \qquad S _ {\mu_ {N}} (z) = \mathbb {E} \left[ \mathrm {t r} (R _ {A _ {N}} (z)) \right].
$$

In the following we will usually suppress the index $N$ at our matrices; thus write just $A$ instead of $A _ { N }$ , as long as the $N$ is fixed and clear. 

We have then $( A - z 1 ) R _ { A } ( z ) = 1$ , or $A \cdot R _ { A } ( z ) - z R _ { A } ( z ) = 1$ , thus 

$$
R _ {A} (z) = - \frac {1}{z} 1 + \frac {1}{z} A R _ {A} (z).
$$

Taking the normalized trace and expectation of this yields 

$$
\mathbb {E} \left[ \operatorname {t r} \left(R _ {A} (z)\right) \right] = - \frac {1}{z} + \frac {1}{z} \mathbb {E} \left[ \operatorname {t r} \left(A R _ {A} (z)\right) \right].
$$

The left hand side is our Stieltjes transform, but what about the right hand side; can we relate this also to the Stieltjes transform? Note that the function under the expectation is $\begin{array} { r } { \frac { 1 } { N } \sum _ { k , l } x _ { k l } [ R _ { A } ( z ) ] _ { l k } } \end{array}$ ; thus a sum of terms which are the product of one of our Gaussian variables times a function of all the independent Gaussian variables. There exists actually a very nice and important formula to deal with such expectations of independent Gaussian variables. In a sense, this is the analytic version of the combinatorial Wick formula. 

# 5.2 Stein’s identity for independent Gaussian variables

Proposition 5.3 (Stein’s identity). Let $X _ { 1 } , \ldots , X _ { k }$ be independent random variables with Gaussian distribution, with mean zero and variances $\mathbb { E } \left[ X _ { i } \right] = \sigma _ { i } ^ { 2 }$ . Let h : $\mathbb { R } ^ { k } \to \mathbb { C }$ be continuously differentiable such that h and all partial derivatives are of polynomial growth. Then we have for $i = 1 , \ldots , k$ : 

$$
\mathbb {E} \left[ X _ {i} h \left(X _ {1}, \dots , X _ {k}\right) \right] = \sigma_ {i} ^ {2} \mathbb {E} \left[ \frac {\partial h}{\partial x _ {i}} \left(X _ {1}, \dots , X _ {k}\right) \right].
$$

More explicitly, 

$$
\begin{array}{l} \int_ {\mathbb {R} ^ {k}} x _ {i} h \left(x _ {1}, \dots , x _ {k}\right) \exp \left(- \frac {x _ {1} ^ {2}}{2 \sigma_ {1} ^ {2}} - \dots - \frac {x _ {k} ^ {2}}{2 \sigma_ {k} ^ {2}}\right) d x _ {1} \dots d x _ {k} = \\ \sigma_ {i} ^ {2} \int_ {\mathbb {R} ^ {k}} \frac {\partial h}{\partial x _ {i}} (x _ {1}, \ldots , x _ {k}) \exp \left(- \frac {x _ {1} ^ {2}}{2 \sigma_ {1} ^ {2}} - \dots - \frac {x _ {k} ^ {2}}{2 \sigma_ {k} ^ {2}}\right) d x _ {1} \ldots d x _ {k} \\ \end{array}
$$

Proof. The main argument happens for $k = 1$ . Since $x e ^ { - x ^ { 2 } / ( 2 \sigma ^ { 2 } ) } = [ - \sigma ^ { 2 } e ^ { - x ^ { 2 } / ( 2 \sigma ^ { 2 } ) } ] ^ { \prime }$ we get by partial integration 

$$
\int_ {\mathbb {R}} x h (x) e ^ {- x ^ {2} / \left(2 \sigma^ {2}\right)} d x = \int_ {\mathbb {R}} h (x) [ - \sigma^ {2} e ^ {- x ^ {2} / \left(2 \sigma^ {2}\right)} ] ^ {\prime} d x = \int_ {\mathbb {R}} h ^ {\prime} (x) \sigma^ {2} e ^ {- x ^ {2} / \left(2 \sigma^ {2}\right)} d x;
$$

our assumptions on $h$ are just such that the boundary terms vanish. 

For general $k$ , we just do partial integration for the $i$ -th coordinate. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/f04897aff6377de7aeedf760b148c9a7aa9b8b6d613c1bd0e1ec77e1ee1769e7.jpg)


We want to apply this now to our Gaussian random matrices, with Gaussian random variables $x _ { i j }$ ( $1 \leq i \leq j \leq N$ ) of variance 

$$
\sigma_ {i j} ^ {2} = \left\{ \begin{array}{l l} \frac {1}{N}, & i \neq j \\ \frac {2}{N}, & i = j \end{array} \right.
$$

and for the function 

$$
h (x _ {i j} \mid i \leq j) = h (A) = [ R _ {A} (z) ] _ {l k}, \quad \text {w h e r e} \quad R _ {A} (z) = \frac {1}{A - z 1}.
$$

To use Stein’s identitiy 5.3 in this case we need the partial derivatives of the resolvents. 

Lemma 5.4. For $A = ( x _ { i j } ) _ { i , j = 1 } ^ { N }$ with $x _ { i j } = x _ { j i }$ for al l $i , j$ , we have for all $i , j , k , l$ 

$$
\frac {\partial}{\partial x _ {i j}} [ R _ {A} (z) ] _ {l k} = \left\{ \begin{array}{l l} - [ R _ {A} (z) ] _ {l i} \cdot [ R _ {A} (z) ] _ {i k}, & i = j, \\ - [ R _ {A} (z) ] _ {l i} \cdot [ R _ {A} (z) ] _ {j k} - [ R _ {A} (z) ] _ {l j} \cdot [ R _ {A} (z) ] _ {i k}, & i \neq j. \end{array} \right.
$$

Proof. Note first that 

$$
\frac {\partial A}{\partial x _ {i j}} = \left\{ \begin{array}{l l} E _ {i i}, & i = j \\ E _ {i j} + E _ {j i}, & i \neq j \end{array} \right.
$$

where $E _ { i j }$ is a matrix unit with 1 at position $( i , j )$ and 0 elsewhere. 

We have $R _ { A } ( z ) \cdot ( A - z 1 ) = 1$ , which yields by differentiating 

$$
\frac {\partial R _ {A} (z)}{\partial x _ {i j}} \cdot (A - z 1) + R _ {a} (z) \cdot \frac {\partial A}{\partial x _ {i j}} = 0,
$$

and thus 

$$
\frac {\partial R _ {A} (z)}{\partial x _ {i j}} = - R _ {A} (z) \cdot \frac {\partial A}{\partial x _ {i j}} \cdot R _ {A} (z).
$$

This gives, for $i = j$ , 

$$
\frac {\partial}{\partial x _ {i i}} [ R _ {A} (z) ] _ {l k} = - [ R _ {A} (z) \cdot E _ {i i} \cdot R _ {A} (z) ] _ {l k} = - [ R _ {A} (z) ] _ {l i} \cdot [ R _ {A} (z) ] _ {i k},
$$

and, for $i \neq j$ , 

$$
\begin{array}{l} \frac {\partial}{\partial x _ {i j}} [ R _ {A} (z) ] _ {l k} = - [ R _ {A} (z) \cdot E _ {i j} \cdot R _ {A} (z) ] _ {l k} - [ R _ {A} (z) \cdot E _ {j i} \cdot R _ {A} (z) ] _ {l k} \\ = - [ R _ {A} (z) ] _ {l i} \cdot [ R _ {A} (z) ] _ {j k} - [ R _ {A} (z) ] _ {l j} \cdot [ R _ {A} (z) ] _ {i k}. \\ \end{array}
$$

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/6da3bdd6e99bbacb983c15abed12bfecac18fc11107433976eb3ab010520f310.jpg)


# 5.3 Semicircle law for GOE

Theorem 5.5. Let $A _ { N }$ be goe random matrices as in 5.1. Then its averaged eigenvalue distribution $\mu _ { N } \stackrel { w } { \to } \mu _ { W }$ . $\mu _ { N } : = \mathbb { E } \left[ \mu _ { A _ { N } } \right]$ converges weakly to the semicircle distribution: 

Proof. By Theorem 4.14, it suffices to show $\begin{array} { r } { \operatorname* { l i m } _ { N \to \infty } S _ { \mu _ { N } } ( z ) = S _ { \mu _ { W } } ( z ) } \end{array}$ for all $z \in \mathbb { C } ^ { + }$ 

In Remark 5.2(4) we have seen that (where we write $A$ instead of $A _ { N }$ ) 

$$
S _ {\mu_ {N}} (z) = \mathbb {E} \left[ \operatorname {t r} \left(R _ {A} (z) \right] \right] = - \frac {1}{z} + \frac {1}{z} \mathbb {E} \left[ \operatorname {t r} \left[ A R _ {A} (z) \right] \right].
$$

$A = ( x _ { i j } ) _ { i , j = 1 } ^ { N }$ 

$$
\begin{array}{l} \mathbb {E} \left[ \operatorname {t r} \left[ A R _ {A} (z) \right] \right] = \frac {1}{N} \sum_ {k, l = 1} ^ {N} \mathbb {E} \left[ x _ {k l} \cdot \left[ R _ {A} (z) \right] _ {l k} \right] \\ = \frac {1}{N} \sum_ {k, l = 1} ^ {N} \sigma_ {k l} ^ {2} \cdot \mathbb {E} \left[ \frac {\partial}{\partial x _ {k l}} [ R _ {A} (z) ] _ {l k} \right] \\ = - \frac {1}{N} \sum_ {k, l = 1} ^ {N} \frac {1}{N} \cdot \left(\left[ R _ {A} (z) \right] _ {l k} \cdot \left[ R _ {A} (z) \right] _ {l k} + \left[ R _ {A} (z) \right] _ {l l} \cdot \left[ R _ {A} (z) \right] _ {k k}\right). \\ \end{array}
$$

(Note that the combination of the different covariances and of the different form of the formula in Lemma 5.4 for on-diagonal and for off-diagonal entries gives in the end the same result for all pairs of $( k , l )$ .) 

Now note that $\left( A - z 1 \right)$ is symmetric, hence the same is true for its inverse $R _ { A } ( z ) = ( A - z 1 ) ^ { - 1 }$ and thus: $[ R _ { A } ( z ) ] _ { l k } = [ R _ { A } ( z ) ] _ { k l }$ . Thus we get finally 

$$
\mathbb {E} \left[ \operatorname {t r} \left[ A R _ {A} (z) \right] \right] = - \frac {1}{N} \mathbb {E} \left[ \operatorname {t r} \left[ R _ {A} (z) ^ {2} \right] \right] - \mathbb {E} \left[ \operatorname {t r} \left[ R _ {A} (z) \right] \cdot \operatorname {t r} \left[ R _ {A} (z) \right] \right].
$$

To proceed further we need to deal with the two summands on the right hand side; we expect 

• the first term, $\textstyle { \frac { 1 } { N } } \mathbb { E } \left[ \operatorname { t r } [ R _ { A } ( z ) ^ { 2 } ] \right]$ , should go to zero, for $N  \infty$ 

• the second term, $\mathbb { E } \left[ \operatorname { t r } [ R _ { A } ( z ) ] \cdot \operatorname { t r } [ R _ { A } ( z ) ] \right]$ , should be close to its factorized version $\mathbb { E } \left[ \mathrm { t r } [ R _ { A } ( z ) ] \right] \cdot \mathbb { E } \left[ \mathrm { t r } [ R _ { A } ( z ) ] \right] = S _ { \mu _ { N } } ( z ) ^ { \mathrm { \prime } }$ 

Both these ideas are correct; let us try to make them rigorous. 

• $A$ as a symmetric matrix can be diagonalized by an orthogonal matrix $U$ , 

$$
A = U \left( \begin{array}{c c c} \lambda_ {1} & \ldots & 0 \\ \vdots & \ddots & \vdots \\ 0 & \ldots & \lambda_ {N} \end{array} \right) U ^ {*}, \quad \text {a n d t h u s} \quad R _ {A} (z) ^ {2} = \left( \begin{array}{c c c} \frac {1}{(\lambda_ {1} - z) ^ {2}} & \ldots & 0 \\ \vdots & \ddots & \vdots \\ 0 & \ldots & \frac {1}{(\lambda_ {N} - z) ^ {2}} \end{array} \right) U ^ {*},
$$

which yields 

$$
| \operatorname {t r} [ R _ {A} (z) ^ {2} ] | \leq \frac {1}{N} \sum_ {i = 1} ^ {N} | \frac {1}{(\lambda_ {i} - z) ^ {2}} |.
$$

Note that for all $\lambda \in \mathbb { R }$ and all $z \in \mathbb { C } ^ { + }$ 

$$
| \frac {1}{\lambda - z} | \leq \frac {1}{\operatorname {I m} z}
$$

and hence 

$$
\frac {1}{N} \left| \right. \mathbb {E} \left[ \right. \operatorname {t r} \left( \right.R _ {A} (z) ^ {2} \left. \right]\left. \right] \mid \leq \frac {1}{N} \mathbb {E} \left[\left| \operatorname {t r} [ R _ {A} (z) ^ {2} ] \right|\right] \leq \frac {1}{N} \frac {1}{(\operatorname {I m} z) ^ {2}} \rightarrow 0 \quad \text {f o r} N \rightarrow \infty .
$$

• By definition of the variance we have 

$$
\mathbb {V} \operatorname {a r} [ X ] := \mathbb {E} \left[ (X - \mathbb {E} [ X ]) ^ {2} \right] = \mathbb {E} \left[ X ^ {2} \right] - \mathbb {E} [ X ] ^ {2},
$$

and thus 

$$
\mathbb {E} \left[ X ^ {2} \right] = \mathbb {E} \left[ X \right] ^ {2} + \mathbb {V a r} \left[ X \right].
$$

Hence we can replace $\mathbb { E } \left[ \operatorname { t r } [ R _ { A } ( z ) ] \cdot \operatorname { t r } [ R _ { A } ( z ) ] \right]$ by 

$$
\mathbb {E} \left[ \mathrm {t r} [ R _ {A} (z) ] \right] ^ {2} + \mathbb {V a r} \left[ \mathrm {t r} [ R _ {A} (z) ] \right] = S _ {\mu_ {N}} (z) ^ {2} + \mathbb {V a r} \left[ S _ {\mu_ {A}} (z) \right].
$$

In the next chapter we will show that we have concentration, i.e., the variance Var $\big [ S _ { \mu _ { A } } ( z ) \big ]$ goes to zero for $N  \infty$ . 

With those two ingredients we have then 

$$
S _ {\mu_ {N}} (z) = - \frac {1}{z} + \frac {1}{z} \mathbb {E} [ \mathrm {t r} [ A R _ {A} (z) ] ] = - \frac {1}{z} - \frac {1}{z} S _ {\mu_ {N}} (z) ^ {2} + \varepsilon_ {N},
$$

where $\varepsilon _ { N } $ for $N \to \infty$ . 

Note that, as above, for any Stieltjes transform $S _ { \nu }$ we have 

$$
| S _ {\nu} (z) | = | \int \frac {1}{t - z} d \nu (t) | \leq \int | \frac {1}{t - z} | d \nu (t) \leq \frac {1}{\operatorname {I m} z},
$$

and thus $( S _ { \mu _ { N } } ( z ) ) _ { N }$ is a bounded sequence of complex numbers. Hence, by compactness, there exists a convergent subsequence $( S _ { \mu _ { N ( m ) } } ( z ) ) _ { m }$ , which converges to some $S ( z )$ . This $S ( z )$ must then satisfy the limit $N  \infty$ of the above equation, thus 

$$
S (z) = - \frac {1}{z} - \frac {1}{z} S (z) ^ {2}.
$$

Since all $S _ { \mu _ { N } } ( z )$ are in $\mathbb { C } ^ { + }$ , the limit $S ( z )$ must be in $\mathbb { C } ^ { + }$ , which leaves for $S ( z )$ only the possibility that 

$$
S (z) = \frac {- z + \sqrt {z ^ {2} - 4}}{2} = S _ {\mu_ {W}} (z)
$$

(as the other solution is in $\mathbb { C } ^ { - }$ ). 

In the same way, it follows that any subsequence of $( S _ { \mu _ { N } } ( z ) ) _ { N }$ has a convergent subsequence which converges to $S _ { \mu _ { W } } ( z )$ ; this forces all cluster points of $( S _ { \mu _ { N } } ( z ) ) _ { N }$ to be $S _ { \mu _ { W } } ( z )$ . Thus the whole sequence converges to $S _ { \mu _ { N } } ( z )$ . This holds for any $z \in \mathbb { C } ^ { + }$ , and thus implies that $\mu _ { N } \xrightarrow { w } \mu _ { W }$ . □ 

To complete the proof we still have to see the concentration to get the asymptotic vanishing of the variance. We will address such concentration questions in the next chapter. 

# 6 Concentration Phenomena and Stronger Forms of Convergence for the Semicircle Law

# 6.1 Forms of convergence

Remark 6.1. (1) Recall that our random matrix ensemble is given by probability measures $\mathbb { P } _ { N }$ on sets $\Omega _ { N }$ of $N \times N$ matrices and we want to see that $\mu _ { A _ { N } }$ converges weakly to $\mu { W }$ , or, equivalently, that, for all $z \in \mathbb { C } ^ { + }$ , $S _ { \mu _ { A _ { N } } } ( z )$ converges to $S _ { \mu _ { W } } ( z )$ . There are different levels of this convergence with respect to $\mathbb { P } _ { N }$ : 

(i) convergence in average, i.e., 

$$
\mathbb {E} \left[ S _ {\mu_ {A _ {N}}} (z) \right] \stackrel {N \to \infty} {\longrightarrow} S _ {\mu_ {W}} (z)
$$

(ii) convergence in probability, i.e., 

$$
\mathbb {P} _ {N} \{A _ {N} \mid | S _ {\mu_ {A _ {N}}} (z) - S _ {\mu_ {W}} (z) | \geq \varepsilon \} \stackrel {N \to \infty} {\longrightarrow} 0 \quad \mathrm {f o r a l l} \varepsilon > 0
$$

(iii) almost sure convergence, i.e., 

$$
\mathbb {P} \{(A _ {N}) _ {N} \mid S _ {\mu_ {A _ {N}}} (z) \mathrm {d o e s n o t c o n v e r g e t o} S _ {\mu_ {W}} (z) \} = 0;
$$

instead of making this more precise, let us just point out that this almost sure convergence is guaranteed, by the Borel-Cantelli Lemma, if the convergence in (ii) to zero is sufficiently fast in $N$ , so that for all $\varepsilon > 0$ 

$$
\sum_ {N = 1} ^ {\infty} \mathbb {P} _ {N} \{A _ {N} \mid | S _ {\mu_ {A _ {N}}} (z) - S _ {\mu_ {W}} (z) | \geq \varepsilon \} <   \infty .
$$

(2) Note that we have here convergence of probabilistic quantities to a deterministic limit, thus (ii) and (iii) are saying that for large $N$ the eigenvalue distribution of $A _ { N }$ concentrates in a small neighborhood of $\mu _ { W }$ . This is an instance of a quite general “concentration of measure” phenomenon; according 

to a dictum of M. Talagrand: “A random variable that depends (in a smooth way) on the influence of many independent variables (but not too much on any of them) is essentially constant.” 

(3) Note also that many classical results in probability theory (like law of large numbers) can be seen as instances of this, dealing with linear functions. However, this principle also applies to non-linear functions - like in our case, to $\operatorname { t r } [ ( A - z 1 ) ^ { - 1 } ]$ , considered as function of the entries of $A$ . 

(4) Often control of the variance of the considered function is a good way to get concentration estimates. We develop in the following some of the basics for this. 

# 6.2 Markov’s and Chebyshev’s inequality

Notation 6.2. A probability space $( \Omega , \mathbb { P } )$ consists of a set $\Omega$ , equipped with a $\sigma$ - algebra of measurable sets, and a probability measure $\mathbb { P }$ on the measurable sets of $\Omega$ . A random variable $X$ is a measurable function $X : \Omega  \mathbb { R }$ ; its expectation or mean is given by 

$$
\mathbb {E} \left[ X \right] := \int_ {\Omega} X (\omega) d \mathbb {P} (\omega),
$$

and its variance is given by 

$$
\mathbb {V a r} \left[ X \right] := \mathbb {E} \left[ (X - \mathbb {E} \left[ X \right]) ^ {2} \right] = \mathbb {E} \left[ X ^ {2} \right] - \mathbb {E} \left[ X \right] ^ {2} = \int_ {\Omega} (X (\omega) - \mathbb {E} \left[ (J X)\right) ^ {2} d \mathbb {P} (\omega).
$$

Theorem 6.3 (Markov’s Inequality). Let $X$ be a random variable taking nonnegative values. Then, for any $t > 0$ , 

$$
\mathbb {P} \{\omega \mid X (\omega) \geq t \} \leq \frac {\mathbb {E} [ X ]}{t}.
$$

$\mathbb { E } \left\lfloor X \right\rfloor$ could here also be $\infty$ , but then the statement is not very useful. The Markov inequality only gives useful information if $X$ has finite mean, and then only for $t > \mathbb { E } \left[ X \right]$ . 

Proof. Since $X ( \omega ) \geq 0$ for all $\omega \in \Omega$ we can estimate as follows: 

$$
\begin{array}{l} \mathbb {E} [ X ] = \int_ {\Omega} X (\omega) d \mathbb {P} (\omega) \\ = \int_ {\{X (\omega) \geq t \}} X (\omega) d \mathbb {P} (\omega) + \int_ {\{X (\omega) <   t \}} X (\omega) d \mathbb {P} (\omega) \\ \geq \int_ {\{X (\omega) \geq t \}} X (\omega) d \mathbb {P} (\omega) \\ \geq \int_ {\{X (\omega) \geq t \}} t d \mathbb {P} (\omega) \\ = t \cdot \mathbb {P} \{X (\omega) \geq t \}. \\ \end{array}
$$

Theorem 6.4 (Chebyshev’s Inequality). Let $X$ be a random variable with finite mean $\mathbb { E } \left\lfloor X \right\rfloor$ and variance Var [X]. Then, for any $\varepsilon > 0$ , 

$$
\mathbb {P} \{\omega \mid | X (\omega) - \mathbb {E} [ X ] \mid \geq \varepsilon \} \leq \frac {\mathbb {V a r} [ X ]}{\varepsilon^ {2}}.
$$

Proof. We use Markov’s inequality 6.3 for the positive random variable $Y : = ( X -$ $\mathbb { E } \left[ X \right] ) ^ { 2 }$ . Note that 

$$
\mathbb {E} [ Y ] = \mathbb {E} \left[ (X - \mathbb {E} [ X ]) ^ {2} \right] = \operatorname {V a r} [ X ].
$$

Thus we have for $\varepsilon > 0$ 

$$
\begin{array}{l} \mathbb {P} \left\{\omega \mid | X (\omega - \mathbb {E} [ (X) | \geq \varepsilon \right\} = \mathbb {P} \left\{\omega \mid (X (\omega) - \mathbb {E} [ X ]) ^ {2} \geq \varepsilon^ {2} \right\} \\ = \mathbb {P} [ \{\omega \mid Y (\omega) \geq \varepsilon^ {2} \} \\ \leq \frac {\mathbb {E} [ Y ]}{\varepsilon^ {2}} \\ = \frac {\operatorname {V a r} [ X ]}{\varepsilon^ {2}}. \\ \end{array}
$$

Remark 6.5. Our goal will thus be to control the variance of $X = f ( X _ { 1 } , \ldots , X _ { n } )$ for $X _ { 1 } , \ldots , X _ { n }$ independent random variables. (In our case, the $X _ { i }$ will be the entries of the GOE matrix $A$ and $f$ will be the function $f = \mathrm { t r } [ ( A - z 1 ) ^ { - 1 } ]$ .) A main idea in this context is to have estimates which go over from separate control of each variable to control of all variables together; i.e., which are stable under tensorization. There are two prominent types of such estimates, namely 

(i) Poincaré inequality 

(ii) LSI=logarithmic Sobolev inequality 

We will focus here on (i) and say a few words on (ii) later. 

# 6.3 Poincaré inequality

Definition 6.6. A random variable $X = ( X _ { 1 } , \ldots , X _ { n } ) : \Omega  \mathbb { R } ^ { n }$ satisfies a Poincaré inequality with constant $c > 0$ if for any differentiable function $f : \mathbb { R } ^ { n } \to \mathbb { R }$ with $\mathbb { E } \left[ f ( X ) ^ { 2 } \right] < \infty$ we have 

$$
\mathbb {V a r} \left[ f (X) \right] \leq c \cdot \mathbb {E} \left[ \| \nabla f (X) \| _ {2} ^ {2} \right] \qquad \mathrm {w h e r e} \qquad \| \nabla f \| _ {2} ^ {2} = \sum_ {i = 1} ^ {n} (\frac {\partial f}{\partial x _ {i}}) ^ {2}.
$$

Remark 6.7. Let us write this also “explicitly” in terms of the distribution $\mu$ of the random variable $X : \Omega \to \mathbb { R } ^ { n }$ ; recall that $\mu$ is the push-forward of the probability measure $\mathbb { P }$ under the map $X$ to a probability measure on $\mathbb { R } ^ { n }$ . In terms of $\mu$ we have then 

$$
\mathbb {E} \left[ f (X) \right] = \int_ {\mathbb {R} ^ {n}} f (x _ {1}, \dots , x _ {n}) d \mu (x _ {1}, \dots , x _ {n})
$$

and the Poincaré inequality asks then for 

$$
\begin{array}{l} \int_ {\mathbb {R} ^ {n}} \left(f (x _ {1}, \dots , x _ {n}) - \mathbb {E} [ f (X) ]\right) ^ {2} d \mu (x _ {1}, \dots , x _ {n}) \\ \leq c \cdot \sum_ {i = 1} ^ {n} \int_ {\mathbb {R} ^ {n}} \left(\frac {\partial f}{\partial x _ {i}} (x _ {1}, \ldots , x _ {n})\right) ^ {2} d \mu (x _ {1}, \ldots , x _ {n}). \\ \end{array}
$$

Theorem 6.8 (Efron-Stein Inequality). Let $X _ { 1 } , \ldots , X _ { n }$ be independent random variables and let $f ( X _ { 1 } , \ldots , X _ { n } )$ be a square-integrable function of $X = ( X _ { 1 } , \ldots , X _ { n } ) $ . Then we have 

$$
\mathbb {V} a r [ f (X) ] \leq \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \mathbb {V} a r ^ {(i)} [ f (X) ] \right],
$$

where $\mathbb { V } a r ^ { ( i ) }$ denotes taking the variance in the i-th variable, keeping all the other variables fixed, and the expectation is then integrating over all the other variables. 

Proof. We denote the distribution of $X _ { i }$ by $\mu _ { i }$ ; this is, for each $i$ , a probability measure on $\mathbb { R }$ . Since $X _ { 1 } , \ldots , X _ { n }$ are independent, the distribution of $X = ( X _ { 1 } , \ldots , X _ { n } )$ is given by the product measure $\mu _ { 1 } \times \cdots \times \mu _ { n }$ on $\mathbb { R } ^ { n }$ . 

Putting $Z = f ( X _ { 1 } , \ldots , X _ { n } )$ , we have 

$$
\mathbb {E} [ Z ] = \int_ {\mathbb {R} ^ {n}} f (x _ {1}, \dots , x _ {n}) d \mu_ {1} \dots d \mu_ {n} (x _ {n})
$$

and 

$$
\mathbb {V} \operatorname {a r} [ Z ] = \int_ {\mathbb {R} ^ {n}} \left(f (x _ {1}, \dots , x _ {n}) - \mathbb {E} [ Z ]\right) ^ {2} d \mu_ {1} \dots d \mu_ {n}.
$$

We will now do the integration $\mathbb { E }$ by integrating one variable at a time and control each step. For this we write 

$$
\begin{array}{l} Z - \mathbb {E} [ Z ] = Z - \mathbb {E} _ {1} [ Z ] \\ + \mathbb {E} _ {1} [ Z ] - \mathbb {E} _ {1, 2} [ Z ] \\ + \mathbb {E} _ {1, 2} [ Z ] - \mathbb {E} _ {1, 2, 3} [ Z ] \\ \begin{array}{c} \bullet \\ \bullet \\ \bullet \end{array} \\ + \mathbb {E} _ {1, 2, \dots , n - 1} [ Z ] - \mathbb {E} [ Z ], \\ \end{array}
$$

where $\mathbb { E } _ { 1 , \ldots , k }$ denotes integration over the variables $x _ { 1 } , \ldots , x _ { k }$ , leaving a function of the variables $x _ { k + 1 } , \ldots , x _ { n }$ . Thus, with 

$$
\Delta_ {i} := \mathbb {E} _ {1, \dots , i - 1} [ Z ] - \mathbb {E} _ {1, \dots , i - 1, i} [ Z ]
$$

(which is a function of the variables $x _ { i } , x _ { i + 1 } , \ldots , x _ { n } .$ ), we have $Z - \mathbb { E } \left[ Z \right] = \sum _ { i = 1 } ^ { n } \Delta _ { i }$ , and thus 

$$
\begin{array}{l} \mathbb {V} \operatorname {a r} [ Z ] = \mathbb {V} \operatorname {a r} \left[ (Z - \mathbb {E} [ Z ]) ^ {2} \right] \\ = \operatorname {V a r} \left[ \left(\sum_ {i = 1} ^ {n} \Delta_ {i}\right) ^ {2} \right] \\ = \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \Delta_ {i} ^ {2} \right] + \sum_ {i \neq j} \mathbb {E} \left[ \Delta_ {i} \Delta_ {j} \right]. \\ \end{array}
$$

Now observe that for all $i \neq j$ we have $\mathbb { E } \left[ \Delta _ { i } \Delta _ { j } \right] = 0$ . Indeed, consider, for example, $n = 2$ and $i = 1$ , $j = 2$ : 

$$
\begin{array}{l} \mathbb {E} \left[ \Delta_ {1} \Delta_ {2} \right] = \mathbb {E} \left[ (Z - \mathbb {E} _ {1} [ Z ]) \cdot (\mathbb {E} _ {1} [ Z ] - \mathbb {E} _ {1, 2} [ Z ]) \right] \\ = \int \left[ f \left(x _ {1}, x _ {2}\right) - \int f \left(\tilde {x} _ {1}, x _ {2}\right) d \mu_ {1} \left(\tilde {x} _ {1}\right) \right] \cdot \\ \cdot \left[ \int f (\tilde {x} _ {1}, x _ {2}) d \mu_ {1} (\tilde {x} _ {1}) - \int f (\tilde {x} _ {1}, \tilde {x} _ {2}) d \mu_ {1} (\tilde {\mu} _ {1}) d \mu_ {2} (\tilde {x} _ {2}) \right] d \mu_ {1} (x _ {1}) d \mu_ {2} (x _ {2}) \\ \end{array}
$$

Integration with respect to $x _ { 1 }$ now affects only the first factor and integrating this gives zero. The general case $i \neq j$ works in the same way. Thus we get 

$$
\operatorname {V a r} \left[ Z \right] = \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \Delta_ {i} ^ {2} \right].
$$

We denote now with $\mathbb { E } ^ { ( i ) }$ integration with respect to the variable $x _ { i }$ , leaving a function of the other variables $x _ { 1 } , \ldots , x _ { i - 1 } , x _ { i + 1 } , \ldots , x _ { n }$ , and 

$$
\mathbb {V} \mathrm {a r} ^ {(i)} [ Z ] := \mathbb {E} ^ {(i)} [ (Z - \mathbb {E} ^ {(i)} [ Z ]) ^ {2} ].
$$

Then we have 

$$
\Delta_ {i} = \mathbb {E} _ {1, \dots , i - 1} [ Z ] - \mathbb {E} _ {1, \dots , i} [ Z ] = \mathbb {E} _ {1, \dots , i - 1} [ Z - \mathbb {E} ^ {(i)} [ Z ] ],
$$

and thus by Jensen’s inequality (which is here just the fact that variances are nonnegative), 

$$
\Delta_ {i} ^ {2} \leq \mathbb {E} _ {1, \dots , i - 1} [ (Z - \mathbb {E} ^ {(i)} [ Z ]) ^ {2} ].
$$

This gives finally 

$$
\operatorname {V a r} [ Z ] = \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \Delta_ {i} ^ {2} \right] \leq \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \mathbb {E} ^ {(i)} \left[ (Z - \mathbb {E} ^ {(i)} [ Z ]) ^ {2} \right] \right],
$$

which is the assertion. 

Theorem 6.9. Let $X _ { 1 } , \ldots , X _ { n }$ be independent random variables in $\mathbb { R }$ , such that each $X _ { i }$ satisfies a Poincaré inequality with constant $c _ { i }$ . Then $X = ( X _ { 1 } , \ldots , X _ { n } ) $ satisfies a Poicaré inequality in $\mathbb { R } ^ { n }$ iwth constant $c = \operatorname* { m a x } ( c _ { 1 } , \ldots , c _ { n } )$ . 

Proof. By the Efron-Stein inequality 6.8, we have 

$$
\begin{array}{l} \operatorname {V a r} [ f (X) ] \leq \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \operatorname {V a r} ^ {(i)} [ f (X) ] \right] \\ \leq \sum_ {i = 1} ^ {n} \mathbb {E} \left[ c _ {i} \cdot \mathbb {E} ^ {(i)} \left[ \left(\frac {\partial f}{\partial x _ {i}}\right) ^ {2} \right] \right] \\ \leq c \cdot \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \left(\frac {\partial f}{\partial x _ {i}}\right) ^ {2} \right] \\ = c \cdot \mathbb {E} \left[ \| \nabla f (X) \| _ {2} ^ {2} \right]. \\ \end{array}
$$

In the step from the first to the second line we have used, for fixed $i$ , the Poincaré inequality for $X _ { i }$ and the function $x _ { i } \mapsto f ( x _ { 1 } , \ldots , x _ { i - 1 } , x _ { i } , x _ { i + 1 } , \ldots , x _ { n } )$ , for each fixed x1, . . . , xi−1, xi+1, . . . , xn. $x _ { 1 } , \ldots , x _ { i - 1 } , x _ { i + 1 } , \ldots , x _ { n }$ □ 

Theorem 6.10 (Gaussian Poincaré Inequality). Let $X _ { 1 } , \ldots , X _ { n }$ be independent standard Gaussian random variables, $\mathbb { E } \left[ X _ { i } \right] ~ = ~ 0$ and $\mathbb { E } \left[ X _ { i } ^ { 2 } \right] ~ = ~ 1$ . Then $\boldsymbol { X } \ =$ $( X _ { 1 } , \ldots , X _ { n } )$ satisfies a Poincaré inequality with constant $\mathit { 1 }$ ; i.e., for each continuously differentiable $f : \mathbb { R } ^ { n }  \mathbb { R }$ we have 

$$
\mathbb {V} a r [ f (X) ] \leq \mathbb {E} \left[ \| \nabla f (X) \| ^ {2} \right].
$$

Remark 6.11. (1) Note the independence of $n$ ! 

(2) By Theorem 6.9 it suffices to prove the statement for $n = 1$ . But even in this one-dimensional case the statement is not obvious. Let us see what we are actually claiming in this case: $X$ is a standard Gaussian random variable and $f : \mathbb { R } \to \mathbb { R }$ , and the Poincaré inequality says 

$$
\operatorname {V a r} [ f (X) ] \leq \mathbb {E} \left[ f ^ {\prime} (X) ^ {2} \right].
$$

We might also assume that $\mathbb { E } \left[ f ( X ) \right] = 0$ , then this means explicitly: 

$$
\int_ {\mathbb {R}} f (x) ^ {2} e ^ {- x ^ {2} / 2} d x \leq \int_ {\mathbb {R}} f ^ {\prime} (x) ^ {2} e ^ {- x ^ {2} / 2} d x.
$$

Proof. As remarked in Remark 6.11, the general case can, by Theorem 6.9, be reduced to the one-dimensional case and, by shifting our function $f$ by a constant, we can also assume that $f ( X )$ has mean zero. One possible proof is to approximate $X$ via a central limit theorem by independent Bernoulli variables $Y _ { i }$ . 

So let $Y _ { 1 } , Y _ { 2 } , \ldots$ be independent Bernoulli variables, i.e., $\mathbb { P } \left[ Y _ { i } = 1 \right] = 1 / 2 =$ $\mathbb { P } \left[ Y _ { i } = - 1 \right]$ and put 

$$
S _ {n} = \frac {Y _ {1} + \cdots + Y _ {n}}{\sqrt {n}}.
$$

Then, by the central limit theorem, the distribution of $S _ { n }$ converges weakly, for $n \to \infty$ , to a standard Gaussian distribution. So we can approximate $f ( X )$ by 

$$
g \left(Y _ {1}, \dots , Y _ {n}\right) = f \left(S _ {n}\right) = f \left(\frac {1}{\sqrt {n}} \left(Y _ {1} + \dots + Y _ {n}\right)\right).
$$

By the Efron-Stein inequality 6.8, we have 

$$
\begin{array}{l} \operatorname {V a r} \left[ f \left(S _ {n}\right) \right] = \operatorname {V a r} \left[ g \left(Y _ {1}, \dots , Y _ {n}\right) \right] \\ \leq \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \operatorname {V a r} ^ {(i)} [ g (Y _ {1}, \dots , Y _ {n}) ] \right] \\ = \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \operatorname {V a r} ^ {(i)} \left[ f \left(S _ {n}\right) \right] \right]. \\ \end{array}
$$

Put 

$$
S _ {n} ^ {[ i ]} := S _ {n} - \frac {1}{\sqrt {n}} Y _ {i} = \frac {1}{\sqrt {n}} (Y _ {1} + \dots Y _ {i - 1} + Y _ {i + 1} + \dots + Y _ {n}).
$$

Then 

$$
\mathbb {E} ^ {(i)} [ f (S _ {n}) ] = \frac {1}{2} \left(f \Big (S _ {n} ^ {[ i ]} + \frac {1}{\sqrt {n}} \Big) + f \Big (S _ {n} ^ {[ i ]} - \frac {1}{\sqrt {n}} \Big)\right)
$$

and 

$$
\begin{array}{l} \mathbb {V a r} ^ {(i)} \left[ f \left(S _ {n}\right) \right] \\ = \frac {1}{2} \left\{\left(f \left(S _ {n} ^ {[ i ]} + \frac {1}{\sqrt {n}}\right) - \mathbb {E} ^ {(i)} [ f (S _ {n}) ]\right) ^ {2} + \left(f \left(S _ {n} ^ {[ i ]} - \frac {1}{\sqrt {n}}\right) - \mathbb {E} ^ {(i)} [ f (S _ {n}) ]\right) ^ {2} \right\} \\ = \frac {1}{4} \left(f \left(S _ {n} ^ {[ i ]} + \frac {1}{\sqrt {n}}\right) - f \left(S _ {n} ^ {[ i ]} - \frac {1}{\sqrt {n}}\right)\right) ^ {2}, \\ \end{array}
$$

and thus 

$$
\mathbb {V} \mathrm {a r} \left[ f (S _ {n}) \right] \leq \frac {1}{4} \sum_ {i = 1} ^ {n} \mathbb {E} \left[ \left(f \left(S _ {n} ^ {[ i ]} + \frac {1}{\sqrt {n}}\right) - f \left(S _ {n} ^ {[ i ]} - \frac {1}{\sqrt {n}}\right)\right) ^ {2} \right].
$$

By Taylor’s theorem we have now 

$$
f \left(S _ {n} ^ {[ i ]} + \frac {1}{\sqrt {n}}\right) = f \left(S _ {n} ^ {[ i ]}\right) + \frac {1}{\sqrt {n}} f ^ {\prime} \left(S _ {n} ^ {[ i ]}\right) + \frac {1}{2 n} f ^ {\prime \prime} (\xi_ {+})
$$

$$
f \left(S _ {n} ^ {[ i ]} - \frac {1}{\sqrt {n}}\right) = f \left(S _ {n} ^ {[ i ]}\right) - \frac {1}{\sqrt {n}} f ^ {\prime} \left(S _ {n} ^ {[ i ]}\right) + \frac {1}{2 n} f ^ {\prime \prime} (\xi_ {+})
$$

We assume that $f$ is twice differentiable and $f ^ { \prime }$ and $f ^ { \prime \prime }$ are bounded: $| f ^ { \prime } ( \xi ) | \le K$ and $| f ^ { \prime \prime } ( \xi ) | \le K$ for all $\xi \in \mathbb { R }$ . (The general situation can be approximated by this.) Then we have 

$$
\begin{array}{l} \left(f \left(S _ {n} ^ {[ i ]} + \frac {1}{\sqrt {n}}\right) - f \left(S _ {n} ^ {[ i ]} - \frac {1}{\sqrt {n}}\right)\right) ^ {2} = \left(\frac {2}{\sqrt {n}} f ^ {\prime} \left(S _ {n} ^ {[ i ]}\right) + \frac {1}{2 n} \left(f ^ {\prime \prime} (\xi_ {+}) - f ^ {\prime \prime} (\xi_ {-})\right)\right) ^ {2} \\ = \frac {4}{n} f ^ {\prime} \left(S _ {n} ^ {[ i ]}\right) ^ {2} + \frac {2}{n ^ {3 / 2}} R _ {1} R _ {2} + \frac {1}{4 n ^ {2}} R _ {2} ^ {2}, \\ \end{array}
$$

where we have put $R _ { 1 } : = f ^ { \prime } \bigl ( S _ { n } ^ { [ i ] } \bigr )$ and $R _ { 2 } : = f ^ { \prime \prime } ( \xi _ { + } ) - f ^ { \prime \prime } ( \xi _ { - } )$ . Note that $| R _ { 1 } | \le K$ and $| R _ { 2 } | \le 2 K$ , and thus 

$$
\mathbb {V} \mathrm {a r} \left[ f (S _ {n}) \right] \leq \frac {1}{4} n \left\{\frac {4}{n} \mathbb {E} \left[ f ^ {\prime} \left(S _ {n} ^ {[ i ]}\right) ^ {2} \right] + \frac {2}{n ^ {3 / 2}} 2 K ^ {2} + \frac {1}{4 n ^ {2}} 4 K ^ {2} \right\}.
$$

Note that the first term containing $S _ { n } ^ { [ i ] }$ is actually independent of $i$ . Now we take the limit $n \to \infty$ in this inequality; since both $S _ { n }$ and $S _ { n } ^ { [ i ] }$ converge to our standard Gaussian variable $X$ we obtain finally the wanted 

$$
\operatorname {V a r} [ f (X) ] \leq \mathbb {E} \left[ f ^ {\prime} (X) ^ {2} \right].
$$

# 6.4 Concentration for $\operatorname { t r } [ R _ { A } ( z ) ]$ via Poincaré inequality

We apply this Gaussian Poincaré inequality now to our random matrix setting $A =$ $( x _ { i j } ) _ { i , j = 1 } ^ { N }$ , where $\{ x _ { i j j } \mid i \le j \}$ are independent Gaussian random variables with $\mathbb { E } \left[ x _ { i j } \right] = 0$ and $\mathbb { E } \left[ x _ { i i } \right] = 2 / N$ on the diagonal and $\mathbb { E } \left[ x _ { i j } \right] = 1 / N$ ( $i \neq j$ ) off the diagonal. Note that by a change of variable the constant in the Poincare inequality for this variances is given by $\operatorname* { m a x } \{ \sigma _ { i j } ^ { 2 } \mid i \leq j \} = 2 / N$ . Thus we have in our setting for nice real-valued $f$ : 

$$
\mathbb {V} \mathrm {a r} [ f (A) ] \leq \frac {2}{N} \cdot \mathbb {E} \left[ \| f (A) \| _ {2} ^ {2} \right].
$$

We take now 

$$
g (A) := \mathrm {t r} [ (A - z 1) ^ {- 1} ] = \mathrm {t r} [ R _ {A} (z) ]
$$

and want to control $\mathbb { V } \mathrm { a r } [ g ( A _ { N } ]$ for $N  \infty$ . Note that $g$ is complex-valued (since $z \in \mathbb { C } ^ { + }$ ), but we can estimate 

$$
\left| \mathbb {V} \operatorname {a r} [ g (A) ] \right| = \left| \mathbb {V} \operatorname {a r} \left[ \operatorname {R e} g (A) + \sqrt {- 1} \operatorname {I m} g (A) \right] \right| \leq 2 \Big (\mathbb {V} \operatorname {a r} [ \operatorname {R e} g (A) ] + \mathbb {V} \operatorname {a r} [ \operatorname {I m} g (A) ] \Big).
$$

Thus it suffices to estimate the variance of real and imaginary part of $g ( A )$ . 

We have, for $i < j$ 

$$
\begin{array}{l} \frac {\partial g (A)}{\partial x _ {i j}} = \frac {\partial}{\partial x _ {i j}} \operatorname {t r} [ R _ {A} (z) ] \\ = \frac {1}{N} \sum_ {k = 1} ^ {N} \frac {\partial \left[ R _ {A} (z) \right] _ {k k}}{\partial x _ {i j}} \\ = - \frac {1}{N} \sum_ {k = 1} ^ {N} \left(\left[ R _ {A} (z) \right] _ {k i} \cdot \left[ R _ {A} (z) \right] _ {j k} + \left[ R _ {A} (z) \right] _ {k j} \cdot \left[ R _ {A} (z) \right] _ {i k}\right) \quad \text {b y} \\ \end{array}
$$

$$
\begin{array}{l} = - \frac {2}{N} \sum_ {k = 1} ^ {N} \left[ R _ {A} (z) \right] _ {i k} \cdot \left[ R _ {A} (z) \right] _ {k j} \quad \text {s i n c e} R _ {A} (z) \text {i s s y m m e t r i c , s e e p r o o f 5 . 5} \\ = - \frac {2}{N} \left[ R _ {A} (z) ^ {2} \right] _ {i j}, \\ \end{array}
$$

and the same for $i = j$ with $2 / N$ replaced by $1 / N$ . 

Thus we get for $f ( A ) : = \mathrm { R e } g ( A ) = \mathrm { R e } \mathrm { t r } [ R _ { A } ( z ) ]$ 

$$
| \frac {\partial f (A)}{\partial x _ {i j}} | = | \operatorname {R e} \frac {\partial g (A)}{\partial x _ {i j}} | \leq \frac {2}{N} | [ R _ {A} (z) ^ {2} ] _ {i j} | \leq \frac {2}{N} \| R _ {A} (z) ^ {2} \| \leq \frac {2}{N \cdot (\operatorname {I m} z) ^ {2}},
$$

where in the last step we used the usual estimate for resolvents as in the proof of Theorem 5.5. Hence we have 

$$
| \frac {\partial f (A)}{\partial x _ {i j}} | ^ {2} \leq \frac {4}{N ^ {2} . (\operatorname {I m} z) ^ {4}},
$$

and thus our Gaussian Poincaré inequality 6.10 (with constant $2 / N$ ) yields 

$$
\mathbb {V a r} \left[ f (A) \right] \leq \frac {2}{N} \cdot \sum_ {i \leq j} | \frac {\partial f (A)}{\partial x _ {i j}} | ^ {2} \leq \frac {8}{N \cdot (\operatorname {I m} z) ^ {4}}.
$$

The same estimate holds for the imaginary part and thus, finally, we have for the variance of the trace of the resolvent: 

$$
\mathbb {V a r} \left[ \mathrm {t r} [ R _ {A} (z) ] \right] \leq \frac {3 2}{N \cdot (\operatorname {I m} z) ^ {4}}.
$$

The fact that $\mathbb { V } \mathrm { a r } \left[ \mathrm { t r } [ R _ { A } ( z ) ] \right]$ goes to zero for $N \to \infty$ closes the gap in our proof of Theorem 5.5. Furthermore, it also improves the type of convergence in Wigner’s semicircle law. 

Theorem 6.12. Let $A _ { N }$ be goe random matrices as in 5.1. Then the eigenvalue distribution $\mu _ { A _ { N } }$ converges in probability to the semicircle distribution. Namely, for each $z \in \mathbb { C } ^ { + }$ and al l $\varepsilon > 0$ we have 

$$
\lim _ {N \to \infty} \mathbb {P} _ {N} \{A _ {N} | | S _ {\mu_ {A _ {N}}} (z) - S _ {\mu_ {W}} (z) | \geq \varepsilon \} = 0.
$$

Proof. By the Chebyshev inequality 6.4, our above estimate for the variance implies for any $\varepsilon > 0$ that 

$$
\begin{array}{l} \mathbb {P} _ {N} \left\{A _ {N} \mid \mid \operatorname {t r} \left[ R _ {A _ {N}} (z) \right] - \mathbb {E} \left[ \operatorname {t r} \left[ R _ {A _ {N}} (z) \right] \right] \mid \geq \varepsilon \right\} \leq \frac {\operatorname {V a r} \left[ \operatorname {t r} \left[ R _ {A _ {N}} \right] \right]}{\varepsilon^ {2}} \\ \leq \frac {3 2}{N \cdot (\operatorname {I m} z) ^ {4} \cdot \varepsilon^ {2}} \stackrel {N \rightarrow \infty} {\longrightarrow} 0. \\ \end{array}
$$

Since we already know, by Theorem 5.5, that $\begin{array} { r } { \operatorname* { l i m } _ { N  \infty } \mathbb { E } [ \mathrm { t r } [ R _ { A _ { N } } ( z ) ] ] = S _ { \mu _ { W } } ( z ) } \end{array}$ , this gives the assertion. □ 

Remark 6.13. Note that our estimate $\mathbb { V } \mathrm { a r } [ . . . ] \sim 1 / N$ is not strong enough to get almost sure convergence; one can, however, improve our arguments to get $\mathbb { V } \mathrm { a r } \left[ \ldots \right] \sim$ $1 / N ^ { 2 }$ , which implies then also almost sure convergence. 

# 6.5 Logarithmic Sobolev inequalities

One actually has typcially even exponential convergence in $N$ . Such stronger concentration estimates rely usually on so called logarithmic Sobolev inequalities 

Definition 6.14. A probability measure on $\mathbb { R } ^ { n }$ satisfies a logarithmic Sobolev inequality (LSI) with constant $c > 0$ , if for all nice $f$ : 

$$
\operatorname {E n t} _ {\mu} (f ^ {2}) \leq 2 c \int_ {\mathbb {R} ^ {n}} \| \nabla f \| _ {2} ^ {2} d \mu ,
$$

where 

$$
\operatorname {E n t} _ {\mu} (f) := \int_ {\mathbb {R} ^ {n}} f \log f d \mu - \int_ {\mathbb {R} ^ {n}} f d \mu \cdot \log \int_ {\mathbb {R} ^ {n}} f d \mu
$$

is an entropy like quantity. 

Remark 6.15. (1) As for Poincaré inequalities, logarithmic Sobolev inqualities are stable under tensorization and Gaussian measures satisfy LSI. 

(2) From a logarithmic Sobolev inequality one can then derive a concentration inequality for our random matrices of the form 

$$
P _ {N} \left\{A _ {N} \mid \mid \operatorname {t r} \left[ R _ {A _ {N}} (z) \right] - \mathbb {E} \left[ \operatorname {t r} \left[ R _ {A _ {N}} (z) \right] \right] \mid \geq \varepsilon \right\} \leq c o n s t \cdot \exp \left(- \frac {N ^ {2} \varepsilon^ {2}}{2} \cdot (\operatorname {I m} z) ^ {4}\right).
$$

# 7 Analytic Description of the Eigenvalue Distribution of Gaussian Random Matrices

In Exercise 7 we showed that the joint distribution of the entries $a _ { i j } = x _ { i j } + \sqrt { - 1 } y _ { i j }$ of a gue $A = \left( a _ { i j } \right) _ { i , j = 1 } ^ { N }$ has density 

$$
c \cdot \exp \left(- \frac {N}{2} \operatorname {T r} A ^ {2}\right) \mathrm {d} A.
$$

This clearly shows the invariance of the distribution under unitary transformations: Let $U$ be a unitary $N \times N$ matrix and let $B = U ^ { * } A U = ( b _ { i j } ) _ { i , j = 1 } ^ { N }$ . Then we have $\operatorname { T r } B ^ { 2 } = \operatorname { T r } A ^ { 2 }$ and the volume element is invariant under unitary transformations, $\mathrm { d } B = \mathrm { d } A$ . Therefore, for the joint distributions of entries of $A$ and of $B$ , respectively, we have 

$$
c \cdot \exp \left(- \frac {N}{2} \operatorname {T r} B ^ {2}\right) \mathrm {d} B = c \cdot \exp \left(- \frac {N}{2} \operatorname {T r} A ^ {2}\right) \mathrm {d} A.
$$

Thus the joint distribution of entries of a gue is invariant under unitary transformations, which explains the name Gaussian Unitary Ensemble. What we are interested in, however, are not the entries but the eigenvalues of our matrices. Thus we should transform this density from entries to eigenvalues. Instead of gue, we will mainly consider the real case, i.e., goe. 

# 7.1 Joint eigenvalue distribution for GOE and GUE

Let us recall the definition of goe, see also Definition 5.1. 

Definition 7.1. A Gaussian orthogonal random matrix (goe) $A = ( x _ { i j } ) _ { i , j = 1 } ^ { N }$ is given by real-valued entries $x _ { i j }$ with $x _ { i j } = x _ { j i }$ for all $i , j = 1 , \dots , N$ and joint distribution 

$$
c _ {N} \exp \left(- \frac {N}{4} \operatorname {T r} A ^ {2}\right) \prod_ {i \geq j} \mathrm {d} x _ {i j}.
$$

With goe(n) we denote the goe of size $N \times N$ . 

Remark 7.2. (1) This is clearly invariant under orthogonal transformation of the entries. 

(2) This is equivalent to independent real Gaussian random variables. Note, however, that the variance for the diagonal entries has to be chosen differently from the off-diagonals; see Remark 5.2. Let us check this for $N = 2$ with 

$$
A = \left( \begin{array}{c c} x _ {1 1} & x _ {1 2} \\ x _ {1 2} & x _ {2 2}. \end{array} \right)
$$

Then 

$$
\begin{array}{l} \exp \left(- \frac {N}{4} \operatorname {T r} \left( \begin{array}{l l} x _ {1 1} & x _ {1 2} \\ x _ {1 2} & x _ {2 2}. \end{array} \right) ^ {2}\right) = \exp \left(- \frac {N}{4} \left(x _ {1 1} ^ {2} + 2 x _ {1 2} ^ {2} + x _ {2 2} ^ {2}\right)\right) \\ = \exp \left(- \frac {N}{4} x _ {1 1} ^ {2}\right) \exp \left(- \frac {N}{2} x _ {1 2} ^ {2}\right) \exp \left(- \frac {N}{4} x _ {2 2} ^ {2}\right); \\ \end{array}
$$

those give the density of a Gaussian of variance $1 / N$ for $x _ { 1 1 }$ and $x _ { 2 2 }$ and of variance $1 / N$ for $x _ { 1 2 }$ . 

(3) From this one can easily determine the normalization constant $c _ { N }$ (as a function of $N$ ). 

Since we are usually interested in functions of the eigenvalues, we will now transform this density to eigenvalues. 

Example 7.3. As a warmup, let us consider the goe(2) case, 

$$
A = \left( \begin{array}{c c} x _ {1 1} & x _ {1 2} \\ x _ {1 2} & x _ {2 2} \end{array} \right) \qquad \text {w i t h d e n s i t y} \qquad p (A) = c _ {2} \exp \left(- \frac {N}{4}   \operatorname {T r} A ^ {2}\right).
$$

We parametrize $A$ by its eigenvalues $\lambda _ { 1 }$ and $\lambda _ { 2 }$ and an angle $\theta$ by diagonalization $A = O ^ { T } D O$ , where 

$$
D = \left( \begin{array}{c c} \lambda_ {1} & 0 \\ 0 & \lambda_ {2} \end{array} \right) \qquad \text {a n d} \qquad O = \left( \begin{array}{c c} \cos \theta & - \sin \theta \\ \sin \theta & \cos \theta \end{array} \right);
$$

explicityly 

$$
x _ {1 1} = \lambda_ {1} \cos^ {2} \theta + \lambda_ {2} \sin^ {2} \theta ,
$$

$$
x _ {1 2} = \left(\lambda_ {1} - \lambda_ {2}\right) \cos \theta \sin \theta ,
$$

$$
x _ {2 2} = \lambda_ {1} \sin^ {2} \theta + \lambda_ {2} \cos^ {2} \theta .
$$

Note that $O$ and $D$ are not uniquely determined by $A$ . In particular, if $\lambda _ { 1 } = \lambda _ { 2 }$ then any orthogonal $O$ works. However, this case has probability zero and thus can be ignored (see Remark 7.4). If $\lambda _ { 1 } \neq \lambda _ { 2 }$ , then we can choose $\lambda _ { 1 } < \lambda _ { 2 }$ ; $O$ contains then the normalized eigenvectors for $\lambda _ { 1 }$ and $\lambda _ { 2 }$ . Those are unique up to a sign, which can be fixed by requiring that $\cos \theta \geq 0$ . Hence $\theta$ is not running from $- \pi$ to $\pi$ , but instead it can be restricted to $[ - \pi / 2 , \pi / 2 ]$ . We will now transform 

$$
p (x _ {1 1}, x _ {2 2}, x _ {1 2}) \mathrm {d} x _ {1 1} \mathrm {d} x _ {2 2} \mathrm {d} x _ {1 2} \rightarrow q (\lambda_ {1}, \lambda_ {2}, \theta) \mathrm {d} \lambda_ {1} \mathrm {d} \lambda_ {2} \mathrm {d} \theta
$$

by the change of variable formula $q = p \left| \operatorname* { d e t } \mathrm { D } F \right|$ , where D $F ^ { \prime }$ is the Jacobian of 

$$
F \colon (x _ {1 1}, x _ {2 2}, x _ {1 2}) \mapsto (\lambda_ {1}, \lambda_ {2}, \theta).
$$

We calculate 

$$
\det \mathrm {D} F = \det \left( \begin{array}{c c c} \cos^ {2} \theta & \sin^ {2} \theta & - 2 (\lambda_ {1} - \lambda_ {2}) \sin \theta \cos \theta \\ \cos \theta \sin \theta & - \cos \theta \sin \theta & (\lambda_ {1} - \lambda_ {2}) (- \sin^ {2} \theta + \cos^ {2} \theta) \\ \sin^ {2} \theta & \cos^ {2} \theta & 2 (\lambda_ {1} - \lambda_ {2}) \sin \theta \cos \theta \end{array} \right) = - (\lambda_ {1} - \lambda_ {2}),
$$

and hence $| \mathrm { d e t } \mathrm { D } \boldsymbol { F } | = | \lambda _ { 1 } - \lambda _ { 2 } |$ . Thus, 

$$
q (\lambda_ {1}, \lambda_ {2}, \theta) = c _ {2} e ^ {- \frac {N}{4} (\mathrm {T r} (A ^ {2}))} | \lambda_ {1} - \lambda_ {2} | = c _ {2} e ^ {- \frac {N}{4} (\lambda_ {1} ^ {2} + \lambda_ {2} ^ {2})} | \lambda_ {1} - \lambda_ {2} |.
$$

Note that $q$ is independent of $\theta$ , i.e., we have a uniform distribution in $\theta$ . Consider a function $f = f ( \lambda _ { 1 } , \lambda _ { 2 } )$ of the eigenvalues. Then 

$$
\begin{array}{l} \mathbb {E} \left[ f \left(\lambda_ {1}, \lambda_ {2}\right) \right] = \iint \int q \left(\lambda_ {1}, \lambda_ {2}, \theta\right) f \left(\lambda_ {1}, \lambda_ {2}\right) d \lambda_ {1} d \lambda_ {2} d \theta \\ = \int_ {- \frac {\pi}{2}} ^ {\frac {\pi}{2}} \iint_ {\lambda_ {1} <   \lambda_ {2}} f (\lambda_ {1}, \lambda_ {2}) c _ {2} e ^ {- \frac {N}{4} (\lambda_ {1} ^ {2} + \lambda_ {2} ^ {2})} | \lambda_ {1} - \lambda_ {2} | d \lambda_ {1} d \lambda_ {2} d \theta \\ = \pi c _ {2} \int_ {\lambda_ {1} <   \lambda_ {2}} f (\lambda_ {1}, \lambda_ {2}) e ^ {- \frac {N}{4} \left(\lambda_ {1} ^ {2} + \lambda_ {2} ^ {2}\right)} | \lambda_ {1} - \lambda_ {2} | d \lambda_ {1} d \lambda_ {2}. \\ \end{array}
$$

Thus, the density for the joint distribution of the eigenvalues on $\{ ( \lambda _ { 1 } , \lambda _ { 2 } ) ; \lambda _ { 1 } < \lambda _ { 2 } \}$ is given by 

$$
\tilde {c} _ {2} \cdot e ^ {- \frac {N}{4} (\lambda_ {1} ^ {2} + \lambda_ {2} ^ {2})} | \lambda_ {1} - \lambda_ {2} |
$$

with $\ddot { c } _ { 2 } = \pi c _ { 2 }$ . 

Remark 7.4. Let us check that the probability of $\lambda _ { 1 } = \lambda _ { 2 }$ is zero. 

$\lambda _ { 1 } , \lambda _ { 2 }$ are the solutions of the characteristic equation 

$$
\begin{array}{l} 0 = \det (\lambda I - A) = (\lambda - x _ {1 1}) (\lambda - x _ {2 2}) - x _ {1 2} ^ {2} \\ = \lambda^ {2} - (x _ {1 1} + x _ {2 2}) \lambda + (x _ {1 1} x _ {2 2} - x _ {1 2} ^ {2}) \\ = \lambda^ {2} - b \lambda + c. \\ \end{array}
$$

Then there is only one solution if and only if the discriminant $d = b ^ { 2 } - 4 a c$ is zero. However, 

$$
\{(x _ {1 1}, x _ {2 2}, x _ {1 2}); d (x _ {1 1}, x _ {2 2}, x _ {1 2}) = 0 \}
$$

is a two-dimensional surface in $\mathbb { R } ^ { 3 }$ , i.e., its Lebesgue measure is zero. 

Now we consider general goe(n). 

Theorem 7.5. The joint distribution of the eigenvalues of a goe(n) is given by a density 

$$
\tilde {c} _ {N} e ^ {- \frac {N}{4} (\lambda_ {1} ^ {2} + \dots + \lambda_ {N} ^ {2})} \prod_ {k <   l} (\lambda_ {l} - \lambda_ {k})
$$

restricted on $\lambda _ { 1 } < \cdots < \lambda _ { N }$ . 

Proof. In terms of the entries of the goe matrix $A$ we have density 

$$
p \left(x _ {k l} \mid k \geq l\right) = c _ {N} e ^ {- \frac {N}{4} \operatorname {T r} A ^ {2}},
$$

where $A = ( x _ { k l } ) _ { k , l = 1 } ^ { N }$ with $x _ { k l }$ real and $x _ { k l } = x _ { l k }$ for all $l , k$ . Again we diagonalize $A = O ^ { T } D O$ with $O$ orthogonal and $D = \mathrm { d i a g } ( \lambda _ { 1 } , . . . , \lambda _ { N } )$ with $\lambda _ { 1 } \leq \cdots \leq \lambda _ { N }$ . As before, degenerated eigenvalues have probability zero, hence this case can be neglected and we assume $\lambda _ { 1 } < \cdots < \lambda _ { N }$ . We parametrize $O$ via $\textit { O } = e ^ { - H }$ by a skew-symmetric matrix $H$ , that is, $H ^ { T } = - H$ , i.e., $H = ( h _ { i j } ) _ { i , j = 1 } ^ { N }$ with $h _ { i j } \in \mathbb { R }$ and $h _ { i j } = - h _ { j i }$ for all $i , j$ . In particular, $h _ { i i } = 0$ for all $i$ . We have 

$$
\boldsymbol {O} ^ {T} = \left(\boldsymbol {e} ^ {- H}\right) ^ {T} = \boldsymbol {e} ^ {- H ^ {T}} = \boldsymbol {e} ^ {H}
$$

and thus $O$ is indeed orthogonal: 

$$
O ^ {T} O = e ^ {H} e ^ {- H} = e ^ {H - H} = e ^ {0} = I = O O ^ {T}.
$$

${ \cal O } = e ^ { - H }$ is actually a parametrization of the Lie group SO( $N$ ) by the Lie algebra $\mathrm { s o } ( N )$ of skew-symmetric matrices. 

Note that our parametrization $A = e ^ { H } D e ^ { - H }$ has the right number of parameters. For $A$ we have the variables $\{ x _ { i j } ; j \leq i \}$ and for $e ^ { H } D e ^ { - H }$ we have the $N$ eigenvalues 

$\{ \lambda _ { 1 } , \ldots , \lambda _ { N } \}$ and the $\frac { 1 } { 2 } \big ( N ^ { 2 } - N \big )$ many parameters $\{ h _ { i j } ; i > j \}$ . In both cases we have $\textstyle { \frac { 1 } { 2 } } N ( N + 1 )$ many variables. This parametrization is locally bijective; so we need to compute the Jacobian of the map $S \colon A \mapsto e ^ { H } D e ^ { - H }$ . We have 

$$
\begin{array}{l} \mathrm {d} A = (\mathrm {d e} ^ {H}) D e ^ {- H} + e ^ {H} (\mathrm {d} D) e ^ {- H} + e ^ {H} D (\mathrm {d e} ^ {- H}) \\ = e ^ {H} \left[ e ^ {- H} (\mathrm {d e} ^ {H}) D + \mathrm {d} D - D (\mathrm {d e} ^ {- H}) e ^ {H} \right] e ^ {- H}. \\ \end{array}
$$

This transports the calculation of the derivative at any arbitrary point $e ^ { H }$ to the identity element $I = e ^ { 0 }$ in the Lie group. Since the Jacobian is preserved under this transformation, it suffices to calculate the Jacobian at $H = 0$ , i.e., for $e ^ { H } = I$ and $\mathrm { d } e ^ { H } = \mathrm { d } H$ . Then 

$$
\mathrm {d} A = \mathrm {d} H \cdot D - D \cdot \mathrm {d} H + \mathrm {d} D,
$$

i.e., 

$$
\mathrm {d} x _ {i j} = \mathrm {d} h _ {i j} \lambda_ {j} - \lambda_ {i} \mathrm {d} h _ {i j} + \mathrm {d} \lambda_ {i} \delta_ {i j}
$$

This means that we have 

$$
\frac {\partial x _ {i j}}{\partial \lambda_ {k}} = \delta_ {i j} \delta_ {i k} \qquad \mathrm {a n d} \qquad \frac {\partial x _ {i j}}{\partial h _ {k l}} = \delta_ {i k} \delta_ {j l} (\lambda_ {l} - \lambda_ {k}).
$$

Hence the Jacobian is given by 

$$
J = \det D S = \prod_ {k <   l} (\lambda_ {l} - \lambda_ {k}).
$$

Thus, 

$$
\begin{array}{l} q \left(\lambda_ {1}, \dots , \lambda_ {N}, h _ {k l}\right) = p \left(x _ {i j} \mid i \geq j\right) J = c _ {N} e ^ {- \frac {N}{4} \operatorname {T r} A ^ {2}} \prod_ {k <   l} \left(\lambda_ {l} - \lambda_ {k}\right) \\ = c _ {N} e ^ {- \frac {N}{4} (\lambda_ {1} ^ {2} + \dots + \lambda_ {N} ^ {2})} \prod_ {k <   l} (\lambda_ {l} - \lambda_ {k}). \\ \end{array}
$$

This is independent of the “angles” $h _ { k l }$ , so integrating over those variables just changes the constant $c _ { N }$ into another constant $\ddot { c } _ { N }$ . □ 

In a similar way, the complex case can be treated; see Exercise 19. One gets the following. 

Theorem 7.6. The joint distribution of the eigenvalues of a gue(n) is given by a density 

$$
\hat {c} _ {N} e ^ {- \frac {N}{2} (\lambda_ {1} ^ {2} + \dots + \lambda_ {N} ^ {2})} \prod_ {k <   l} (\lambda_ {l} - \lambda_ {k}) ^ {2}
$$

restricted on $\lambda _ { 1 } < \cdots < \lambda _ { N }$ . 

# 7.2 Rewriting the Vandermonde

Definition 7.7. The function 

$$
\Delta (\lambda_{1},\ldots ,\lambda_{N}) = \prod_{\substack{k,l = 1\\ k <   l}}^{N}(\lambda_{l} - \lambda_{k})
$$

is called the Vandermonde determinant. 

Proposition 7.8. For $\lambda _ { 1 } , \dots , \lambda _ { N } \in \mathbb { R }$ we have that 

$$
\Delta (\lambda_ {1}, \ldots , \lambda_ {N}) = \det  \left(\lambda_ {j} ^ {i - 1}\right) _ {i, j = 1} ^ {N} = \det  \left( \begin{array}{c c c c} 1 & 1 & \dots & 1 \\ \lambda_ {1} & \lambda_ {2} & \ldots & \lambda_ {N} \\ \vdots & \vdots & \ddots & \vdots \\ \lambda_ {1} ^ {N - 1} & \lambda_ {2} ^ {N - 1} & \ldots & \lambda_ {N} ^ {N - 1} \end{array} \right).
$$

Proof. $\operatorname* { d e t } ( \lambda _ { j } ^ { i - 1 } )$ is a polynomial in $\lambda _ { 1 } , \ldots , \lambda _ { N }$ . If $\lambda _ { l } = \lambda _ { k }$ for some $l , k \in \{ 1 , \ldots , N \}$ then $\operatorname* { d e t } ( \lambda _ { j } ^ { i - 1 } ) = 0$ . Thus $\operatorname* { d e t } ( \lambda _ { j } ^ { i - 1 } )$ contains a factor $\lambda _ { l } - \lambda _ { k }$ for each $k < l$ , hence $\Delta ( \lambda _ { 1 } , \ldots , \lambda _ { N } )$ divides $\operatorname* { d e t } ( \lambda _ { j } ^ { i - 1 } )$ . 

Since $\operatorname* { d e t } ( \lambda _ { j } ^ { i - 1 } )$ is a sum of products with one factor from each row, we have that the degree of $\operatorname* { d e t } ( \lambda _ { j } ^ { i - 1 } )$ is equal to 

$$
0 + 1 + 2 + \dots + (N - 1) = \frac {1}{2} N (N - 1),
$$

which is the same as the degree of $\Delta ( \lambda _ { 1 } , \ldots , \lambda _ { N } )$ . This shows that 

$$
\Delta (\lambda_ {1}, \ldots , \lambda_ {N}) = c \cdot \det  (\lambda_ {j} ^ {i - 1}) \qquad \text {f o r s o m e} c \in \mathbb {R}.
$$

By comparing the coefficient of $1 \cdot \lambda _ { 2 } \cdot \lambda _ { 3 } ^ { 2 } \cdot \cdot \cdot \lambda _ { N } ^ { N - 1 }$ on both sides one can check that $c = 1$ . 

The advantage of being able to write our density in terms of a determinant comes from the following observation: In $\operatorname* { d e t } ( \lambda _ { j } ^ { i - 1 } )$ we can add arbitrary linear combinations of smaller rows to the $k$ -th row without changing the value of the determinant, i.e., we can replace $\lambda ^ { k }$ by any arbitrary monic polynomial $p _ { k } ( \lambda ) =$ $\lambda ^ { k } + \alpha _ { k - 1 } \lambda ^ { k - 1 } + \cdot \cdot \cdot + \alpha _ { 1 } \lambda + \alpha _ { 0 }$ of degree $k$ . Hence we have the following statement. 

Proposition 7.9. Let $p _ { 0 } , \ldots , p _ { N - 1 }$ be monic polynomials with $\deg p _ { k } = k$ . Then we have 

$$
\det  (p_{i - 1}(\lambda_{j}))_{i,j = 1}^{N} = \Delta (\lambda_{1},\ldots ,\lambda_{N}) = \prod_{\substack{k,l = 1\\ k <   l}}^{N}(\lambda_{l} - \lambda_{k}).
$$

# 7.3 Rewriting the GUE density in terms of Hermite kernels

In the following, we will make a special choice for the $p _ { k }$ . We will choose them as the Hermite polynomials, which are orthogonal with respect to the Gaussian distribution $\frac { 1 } { c } e ^ { - \frac { 1 } { 2 } \lambda ^ { 2 } }$ . 

Definition 7.10. The Hermite polynomials $H _ { n }$ are defined by the following requirements. 

(i) $H _ { n }$ is a monic polynomial of degree $n$ 

(ii) For all $n , m \geq 0$ : 

$$
\int_ {\mathbb {R}} H _ {n} (x) \overline {{H _ {m} (x)}} \frac {1}{\sqrt {2 \pi}} e ^ {- \frac {1}{2} x ^ {2}} \mathrm {d} x = \delta_ {n m} n!
$$

Remark 7.11. (1) One can get the $H _ { n } ( x )$ from the monomials $1 , x , x ^ { 2 } , \ldots$ via Gram-Schmidt orthogonalization as follows. 

• We define an inner product on the polynomials by 

$$
\langle f, g \rangle = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} f (x) \overline {{g (x)}} e ^ {- \frac {1}{2} x ^ {2}} d x.
$$

• We put $H _ { 0 } ( x ) = 1$ . This is monic of degree 0 with 

$$
\langle H _ {0}, H _ {0} \rangle = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} e ^ {- \frac {1}{2} x ^ {2}} \mathrm {d} x = 1 = 0!.
$$

• We put $H _ { 1 } ( x ) = x$ . This is monic of degree 1 with 

$$
\langle H _ {1}, H _ {0} \rangle = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} x e ^ {- \frac {1}{2} x ^ {2}} \mathrm {d} x = 0
$$

and 

$$
\langle H _ {1}, H _ {1} \rangle = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} x ^ {2} e ^ {- \frac {1}{2} x ^ {2}} \mathrm {d} x = 1 = 1!.
$$

• For $H _ { 2 }$ , note that 

$$
\langle x ^ {2}, H _ {1} \rangle = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} x ^ {3} e ^ {- \frac {1}{2} x ^ {2}} \mathrm {d} x = 0
$$

and 

$$
\langle x ^ {2}, H _ {0} \rangle = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} x ^ {2} e ^ {- \frac {1}{2} x ^ {2}} \mathrm {d} x = 1.
$$

Hence we set $H _ { 2 } ( x ) : = x ^ { 2 } - H _ { 0 } ( x ) = x ^ { 2 } - 1$ . Then we have 

$$
\langle H _ {2}, H _ {0} \rangle = 0 = \langle H _ {2}, H _ {1} \rangle
$$

and 

$$
\begin{array}{l} \langle H _ {2}, H _ {2} \rangle = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} (x ^ {2} - 1) ^ {2} e ^ {- \frac {1}{2} x ^ {2}} d x \\ = \frac {1}{\sqrt {2 \pi}} \int_ {\mathbb {R}} (x ^ {4} - 2 x ^ {2} + 1) e ^ {- \frac {1}{2} x ^ {2}} \mathrm {d} x = 3 - 2 + 1 = 2! \\ \end{array}
$$

• Continue in this way. 

Note that the $H _ { n }$ are uniquely determined by the requirements that $H _ { n }$ is monic and that $\langle H _ { m } , H _ { n } \rangle = 0$ for all $m \neq n$ . That we have $\langle H _ { n } , H _ { n } \rangle = n !$ , is then a statement which has to be proved. 

(2) The Hermite polynomials satisfy many explicit relations; important is the three-term recurrence relation 

$$
x H _ {n} (x) = H _ {n + 1} (x) + n H _ {n - 1} (x)
$$

for all $n \geq 1$ ; see Exercise 22. 

(3) The first few $H _ { n }$ are 

$$
\begin{array}{l} H _ {0} (x) = 1, \\ H _ {1} (x) = x, \\ H _ {2} (x) = x ^ {2} - 1, \\ H _ {3} (x) = x ^ {3} - 3 x, \\ H _ {4} (x) = x ^ {4} - 6 x ^ {2} + 3. \\ \end{array}
$$

(4) By Proposition 7.9, we can now use the $H _ { n }$ for writing our Vandermonde determinant as 

$$
\Delta (\lambda_ {1}, \dots , \lambda_ {N}) = \det  \left(H _ {i - 1} \left(\lambda_ {j}\right)\right) _ {i, j = 1} ^ {N}.
$$

We want to use this for our gue(n) density 

$$
\begin{array}{l} q (\lambda_ {1}, \ldots , \lambda_ {N}) = \hat {c} _ {N} e ^ {- \frac {N}{2} (\lambda_ {1} ^ {2} + \dots + \lambda_ {N} ^ {2})} \Delta (\lambda_ {1}, \ldots , \lambda_ {N}) ^ {2} \\ = \hat {c} _ {N} e ^ {- \frac {1}{2} (\mu_ {1} ^ {2} + \dots + \mu_ {N} ^ {2})} \Delta \left(\frac {\mu_ {1}}{\sqrt {N}}, \ldots , \frac {\mu_ {N}}{\sqrt {N}}\right) ^ {2}. \\ = \hat {c} _ {N} e ^ {- \frac {1}{2} \left(\mu_ {1} ^ {2} + \dots + \mu_ {N} ^ {2}\right)} \Delta (\mu_ {1}, \ldots , \mu_ {N}) ^ {2} \left(\frac {1}{\sqrt {N}}\right) ^ {N (N - 1)}, \\ \end{array}
$$

where the $\mu _ { i } = \sqrt { N } \lambda _ { i }$ are the eigenvalues of the “unnormalized” gue matrix $\sqrt { N } A _ { N }$ . It will be easier to deal with those. We now will also go over from ordered eigenvalues $\lambda _ { 1 } < \lambda _ { 2 } < \dots < \lambda _ { N }$ to unordered eigenvalues $( \mu _ { 1 } , \ldots , \mu _ { N } ) \in \mathbb { R } ^ { N }$ . Since in the latter case each ordered tuple shows up $N !$ times, this gives an additional factor $N !$ in our density. We collect all these $N$ -dependent factors in our constant $\ddot { c } _ { N }$ . So we now have the density 

$$
\begin{array}{l} p (\mu_ {1}, \ldots , \mu_ {N}) = \tilde {c} _ {N} e ^ {- \frac {1}{2} (\mu_ {1} ^ {2} + \dots + \mu_ {N} ^ {2})} \Delta (\mu_ {1}, \ldots , \mu_ {N}) ^ {2} \\ = \tilde {c} _ {N} e ^ {- \frac {1}{2} \left(\mu_ {1} ^ {2} + \dots + \mu_ {N} ^ {2}\right)} \left[ \det  \left(H _ {i - 1} \left(\mu_ {j}\right)\right) _ {i, j = 1} ^ {N} \right] ^ {2} \\ = \tilde {c} _ {N} \left[ \det \left(e ^ {- \frac {1}{4} \mu_ {j} ^ {2}} H _ {i - 1} (\mu_ {j})\right) _ {i, j = 1} ^ {N} \right] ^ {2}. \\ \end{array}
$$

Definition 7.12. The Hermite functions $\Psi _ { n }$ are defined by 

$$
\Psi_ {n} (x) = (2 \pi) ^ {- \frac {1}{4}} (n!) ^ {- \frac {1}{2}} e ^ {- \frac {1}{4} x ^ {2}} H _ {n} (x).
$$

Remark 7.13. (1) We have 

$$
\int_ {\mathbb {R}} \Psi_ {n} (x) \Psi_ {m} (x) \mathrm {d} x = \frac {1}{\sqrt {2 \pi}} \frac {1}{\sqrt {n ! m !}} \int_ {\mathbb {R}} e ^ {- \frac {1}{4} x ^ {2}} H _ {n} (x) H _ {m} (x) \mathrm {d} x = \delta_ {n m},
$$

i.e., the $\Psi _ { n }$ are orthonormal with respect to the Lebesgue measure. Actually, they form an orthonormal Hilbert space basis of $L ^ { 2 } ( \mathbb { R } )$ . 

(2) Now we can continue the calculation 

$$
p (\mu_ {1}, \ldots , \mu_ {N}) = c _ {N} \left[ \det \left(\Psi_ {i - 1} (\mu_ {j})\right) _ {i, j = 1} ^ {N} \right] ^ {2}
$$

with a new constant $c _ { N }$ . Denote $V _ { i j } = \Psi _ { i - 1 } ( \mu _ { j } )$ . Then we have 

$$
(\det  V) ^ {2} = \det  V ^ {T} \det  V = \det  (V ^ {T} V)
$$

such that 

$$
(V ^ {T} V) _ {i j} = \sum_ {k = 1} ^ {N} V _ {k i} V _ {k j} = \sum_ {k = 1} ^ {N} \Psi_ {k - 1} (\mu_ {i}) \Psi_ {k - 1} (\mu_ {j}).
$$

Definition 7.14. The $N$ -th Hermite kernel $K _ { N }$ is defined by 

$$
K _ {N} (x, y) = \sum_ {k = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {k} (y).
$$

Collecting all our notations and calculations we have thus proved the following. 

Theorem 7.15. The unordered joint eigenvalue distribution of an unnormalized gue(n) is given by the density 

$$
p (\mu_ {1}, \dots , \mu_ {N}) = c _ {N} \det  \left(K _ {N} (\mu_ {i}, \mu_ {j})\right) _ {i, j = 1} ^ {N}.
$$

Proposition 7.16. $K _ { N }$ is a reproducing kernel, i.e., 

$$
\int_ {\mathbb {R}} K _ {N} (x, u) K _ {N} (u, y) \mathrm {d} u = K _ {N} (x, y).
$$

Proof. We calculate 

$$
\begin{array}{l} \int_ {\mathbb {R}} K _ {N} (x, u) K _ {N} (u, y) \mathrm {d} u = \int_ {\mathbb {R}} \left(\sum_ {k = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {k} (u)\right) \left(\sum_ {l = 0} ^ {N - 1} \Psi_ {l} (u) \Psi_ {l} (y)\right) \mathrm {d} u \\ = \sum_ {k, l = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {l} (y) \int_ {\mathbb {R}} \Psi_ {k} (u) \Psi_ {l} (u) d u \\ = \sum_ {k, l = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {l} (y) \delta_ {k l} \\ = \sum_ {k = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {k} (y) \\ = K _ {N} (x, y). \\ \end{array}
$$

Lemma 7.17. Let $K \colon  { \mathbb { R } } ^ { 2 } \to  { \mathbb { R } }$ be a reproducing kernel, i.e., 

$$
\int_ {\mathbb {R}} K (x, u) K (u, y) \mathrm {d} u = K (x, y).
$$

Put $\begin{array} { r } { d = \int _ { \mathbb { R } } K ( x , x ) \mathrm { d } x } \end{array}$ . Then, for all $n \geq 2$ , 

$$
\int_ {\mathbb {R}} \det  \left(K (\mu_ {i}, \mu_ {j})\right) _ {i, j = 1} ^ {n} \mathrm {d} \mu_ {n} = (d - n + 1) \cdot \det  \left(K (\mu_ {i}, \mu_ {j})\right) _ {i, j = 1} ^ {n - 1}.
$$

We assume that all those integrals make sense, as it is the case for our Hermite kernels. 

Proof. Consider the case $n = 2$ . Then 

$$
\begin{array}{l} \int_ {\mathbb {R}} \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \end{array} \right)   \mathrm {d} \mu_ {2} \\ = K \left(\mu_ {1}, \mu_ {1}\right) \int_ {\mathbb {R}} K \left(\mu_ {2}, \mu_ {2}\right) \mathrm {d} \mu_ {2} - \int_ {\mathbb {R}} K \left(\mu_ {1}, \mu_ {2}\right) K \left(\mu_ {2}, \mu_ {1}\right) \mathrm {d} \mu_ {2} \\ = (d - 1) K \left(\mu_ {1}, \mu_ {1}\right) \\ = (d - 1) K \left(\mu_ {1}, \mu_ {1}\right) \det  \left(K \left(\mu_ {1}, \mu_ {1}\right)\right). \\ \end{array}
$$

For $n = 3$ 

$$
\begin{array}{l} \det  \left( \begin{array}{c c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) & K (\mu_ {1}, \mu_ {3}) \\ K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) & K (\mu_ {2}, \mu_ {3}) \\ K (\mu_ {3}, \mu_ {1}) & K (\mu_ {3}, \mu_ {2}) & K (\mu_ {3}, \mu_ {3}) \end{array} \right) \\ = \det  \left( \begin{array}{c c} K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \\ K (\mu_ {3}, \mu_ {1}) & K (\mu_ {3}, \mu_ {2}) \end{array} \right) K (\mu_ {1}, \mu_ {3}) - \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {3}, \mu_ {1}) & K (\mu_ {3}, \mu_ {2}) \end{array} \right) K (\mu_ {2}, \mu_ {3}) \\ + \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \end{array} \right) K (\mu_ {3}, \mu_ {3}), \\ \end{array}
$$

with 

$$
\int_ {\mathbb {R}} \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \end{array} \right) K (\mu_ {3}, \mu_ {3})   \mathrm {d} \mu_ {3} = \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \end{array} \right) \cdot d,
$$

and 

$$
\begin{array}{l} - \int_ {\mathbb {R}} \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {3}, \mu_ {1}) & K (\mu_ {3}, \mu_ {2}) \end{array} \right) K (\mu_ {2}, \mu_ {3})   \mathrm {d} \mu_ {3} \\ = - \int_ {\mathbb {R}} \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {2}, \mu_ {3}) K (\mu_ {3}, \mu_ {1}) & K (\mu_ {2}, \mu_ {3}) K (\mu_ {3}, \mu_ {2}) \end{array} \right)   \mathrm {d} \mu_ {3} \\ = - \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \end{array} \right), \\ \end{array}
$$

and 

$$
\begin{array}{l} \int_ {\mathbb {R}} \det  \left( \begin{array}{c c} K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \\ K (\mu_ {3}, \mu_ {1}) & K (\mu_ {3}, \mu_ {2}) \end{array} \right) K (\mu_ {1}, \mu_ {3})   \mathrm {d} \mu_ {3} \\ = \int_ {\mathbb {R}} \det  \left( \begin{array}{c c} K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \\ K (\mu_ {1}, \mu_ {3}) K (\mu_ {3}, \mu_ {1}) & K (\mu_ {1}, \mu_ {3}) K (\mu_ {3}, \mu_ {2}) \end{array} \right)   \mathrm {d} \mu_ {3} \\ = \det  \left( \begin{array}{c c} K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \\ K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \end{array} \right) \\ = - \det  \left( \begin{array}{c c} K (\mu_ {1}, \mu_ {1}) & K (\mu_ {1}, \mu_ {2}) \\ K (\mu_ {2}, \mu_ {1}) & K (\mu_ {2}, \mu_ {2}) \end{array} \right). \\ \end{array}
$$

Putting all terms together gives 

$$
\int_ {\mathbb {R}} \det  (K (\mu_ {i}, \mu_ {j})) _ {i, j = 1} ^ {3} \mathrm {d} \mu_ {3} = (d - 2) \det  (K (\mu_ {i}, \mu_ {j})) _ {i, j = 1} ^ {2}.
$$

The general case works in the same way. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/c7121ba2fe6ae183480b089dccaf25c8dae2f566b4ac5e815fff2b2a676e8cdb.jpg)


Iteration of Lemma 7.17 gives then the following. 

Corollary 7.18. Under the assumptions of Lemma 7.17 we have 

$$
\int_ {\mathbb {R}} \dots \int_ {\mathbb {R}} \det  \left(K \left(\mu_ {i}, \mu_ {j}\right)\right) _ {i, j = 1} ^ {n} \mathrm {d} \mu_ {1} \dots \mathrm {d} \mu_ {n} = (d - n + 1) (d - n + 2) \dots (d - 1) d.
$$

Remark 7.19. We want to apply this to the Hermite kernel $K = K _ { N }$ . In this case we have 

$$
\begin{array}{l} d = \int_ {\mathbb {R}} K _ {N} (x, x) \mathrm {d} x \\ = \int_ {\mathbb {R}} \sum_ {k = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {k} (x) d x \\ = \sum_ {k = 0} ^ {N - 1} \int_ {\mathbb {R}} \Psi_ {k} (x) \Psi_ {k} (x) d x \\ = N, \\ \end{array}
$$

and thus, since now $d = N = n$ 

$$
\int_ {\mathbb {R}} \dots \int_ {\mathbb {R}} \det  \left(K _ {N} \left(\mu_ {i}, \mu_ {j}\right)\right) _ {i, j = 1} ^ {N} d \mu_ {1} \dots d \mu_ {n} = N!.
$$

This now allows us to determine the constant $c _ { N }$ in the density $p ( \mu _ { 1 } , \ldots , \mu _ { n } )$ in Theorem 7.15. Since $p$ is a probability density on $\mathbb { R } ^ { N }$ , we have 

$$
\begin{array}{l} 1 = \int_ {\mathbb {R} ^ {N}} p (\mu_ {1}, \dots , \mu_ {n})   d \mu_ {1} \dots d \mu_ {N} \\ = c _ {N} \int_ {\mathbb {R}} \dots \int_ {\mathbb {R}} \det  \left(K _ {N} \left(\mu_ {i}, \mu_ {j}\right)\right) _ {i, j = 1} ^ {N} d \mu_ {1} \dots d \mu_ {N} \\ = c _ {N} N!, \\ \end{array}
$$

and thus $\begin{array} { r } { c _ { N } = \frac { 1 } { N ! } } \end{array}$ . 

Theorem 7.20. The unordered joint eigenvalue distribution of an unnormalized gue(n) is given by a density 

$$
p (\mu_ {1}, \dots , \mu_ {N}) = \frac {1}{N !} \det  \left(K _ {N} (\mu_ {i}, \mu_ {j})\right) _ {i, j = 1} ^ {N},
$$

where $K _ { N }$ is the Hermite kernel 

$$
K _ {N} (x, y) = \sum_ {k = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {k} (x).
$$

Theorem 7.21. The averaged eigenvalue density of an unnormalized gue(n) is given by 

$$
p _ {N} (\mu) = \frac {1}{N} K _ {N} (\mu , \mu) = \frac {1}{N} \sum_ {k = 0} ^ {N - 1} \Psi_ {k} (\mu) ^ {2} = \frac {1}{\sqrt {2 \pi}} \frac {1}{N} \sum_ {k = 0} ^ {N - 1} \frac {1}{k !} H _ {k} (\mu) ^ {2} e ^ {- \frac {\mu^ {2}}{2}}.
$$

Proof. Note that $p ( \mu _ { 1 } , \ldots , \mu _ { N } )$ is the probability density to have $N$ eigenvalues at the positions $\mu _ { 1 } , \ldots , \mu _ { N }$ . If we are integrating out $N - 1$ variables we are left with the probability for one eigenvalue (without caring about the others). With the notation $\mu _ { N } = \mu$ we get 

$$
\begin{array}{l} p _ {N} (\mu) = \int_ {\mathbb {R} ^ {N - 1}} p \left(\mu_ {1}, \dots , \mu_ {N - 1}, \mu\right) d \mu_ {1} \dots d \mu_ {N - 1} \\ = \frac {1}{N !} \int_ {\mathbb {R} ^ {N - 1}} \det  \left(K _ {N} \left(\mu_ {i}, \mu_ {j}\right)\right) _ {i, j = 1} ^ {N} d \mu_ {1} \dots d \mu_ {N - 1} \\ = \frac {1}{N !} (N - 1)! \det  (K _ {N} (\mu , \mu)) \\ = \frac {1}{N} K _ {N} (\mu , \mu). \\ \end{array}
$$

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/1e31c91681c550dd7dc5f874759ce7cafed92ea79d316c3f58acea9823948cf9.jpg)


# 8 Determinantal Processes and Non-Crossing Paths: Karlin–McGregor and Gessel–Viennot

Our probability distributions for the eigenvalues of gue have a determinantal structure, i.e., are of the form 

$$
p (\mu_ {1}, \dots , \mu_ {n}) = \frac {1}{N !} \det  (K _ {N} (\mu_ {i}, \mu_ {j})) _ {i, j = 1} ^ {N}.
$$

They describe $N$ eigenvalues which repel each other (via the factor $( \mu _ { i } - \mu _ { j } ) ^ { 2 }$ ). If we consider corresponding processes, then the paths of the eigenvalues should not cross; for this see also Section 8.3. There is a quite general relation between determinants as above and non-crossing paths. This appeared in fundamental papers in different contexts: 

• in a paper by Karlin and McGregor, 1958, in the context of Markov chains and Brownian motion 

• in a paper of Lindström, 1973, in the context of matroids 

• in a paper of Gessel and Viennot, 1985, in combinatorics 

# 8.1 Stochastic version à la Karlin–McGregor

Consider a random walk on the integers Z: 

• $Y _ { k }$ : position at time $k$ 

• $\mathbb { Z }$ : possible positions 

• Transition probability (to the two neighbors) might depend on position: 

$$
i - 1 \stackrel {q _ {i}} {\leftarrow} i \stackrel {p _ {i}} {\rightarrow} i + 1, \quad q _ {i} + p _ {1} = 1
$$

We now consider $n$ copies of such a random walk, which at time $k = 0$ start at different positions $x _ { i }$ . We are interested in the probability that the paths don’t 

cross. Let $x _ { i }$ be such that all distances are even, i.e., if two paths cross they have to meet. 

Theorem 8.1 (Karlin–McGregor). Consider n copies of $Y _ { k }$ , i.e., $( Y _ { k } ^ { ( 1 ) } , \ldots , Y _ { k } ^ { ( n ) } )$ with $Y _ { 0 } ^ { ( i ) } = x _ { i }$ , where $x _ { 1 } > x _ { 2 } > \cdots > x _ { n }$ . Consider now $t \in \mathbb { N }$ and $y _ { 1 } > y _ { 2 } > \cdots >$ $y _ { n }$ . Denote by 

$$
P _ {t} (x _ {i}, y _ {j}) = \mathbb {P} \left[ Y _ {t} = y _ {j} \mid Y _ {0} = x _ {i} \right]
$$

the probability of one random walk to get from $x _ { i }$ to $y _ { j }$ in t steps. Then we have 

$$
\mathbb {P} \left[ Y _ {t} ^ {(i)} = y _ {i} f o r a l l i, Y _ {s} ^ {(1)} > Y _ {s} ^ {(2)} > \dots > Y _ {s} ^ {(n)} f o r a l l 0 \leq s \leq t \right] = \det (P _ {t} (x _ {i}, y _ {j})) _ {i, j = 1} ^ {n}.
$$

Example 8.2. For one symmetric random walk $Y _ { t }$ we have the following probabilities to go in two steps from 0 to -2,0,2: 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/b28958c24c3119c41a6359234aae3aa7d57da07823b4c393b33ab2cf616d4d2b.jpg)


$$
p _ {0} p _ {1} = \frac {1}{4}
$$

$$
p _ {0} q _ {1} + q _ {0} p _ {- 1} = \frac {1}{2}
$$

$$
q _ {0} q _ {- 1} = \frac {1}{4}
$$

Now consider two such symmetric random walks and set $x _ { 1 } = 2 = y _ { 1 }$ , $x _ { 2 } = 0 = y _ { 2 }$ . Then 

$$
\mathbb {P} \left[ Y _ {2} ^ {(1)} = 2 = Y _ {0} ^ {(1)}, Y _ {2} ^ {(2)} = 0 = Y _ {0} ^ {(2)}, Y _ {1} ^ {(1)} > Y _ {1} ^ {(2)} \right]
$$

$$
= \mathbb {P} \left[ \left\{\begin{array}{l}\overbrace {\bullet \longrightarrow \bullet} ^ {\rightarrow \bullet},\\\overbrace {\bullet \longrightarrow \bullet} ^ {\rightarrow \bullet},\end{array}\right. \right.
$$

$$
\begin{array}{c} \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\
$$

$$
\left. \begin{array}{c} \left. \begin{array}{c} \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ \bullet \\ 3 & = \frac {3}{1 6}. \\ 1 6 & = 3 / 1 6. \\ 1 6 & = 3 / 1 6. \\ 1 6 & = 3 / 1 6. \\ 1 6 & = 3 / 1 6. \\ 1 6 & = 3 / 1 6. \\ 1 6 & = 3 / 1 6. \\ 1 6 & = 3 / 1 6. \\ 1 6 & = 3/ 1 6. \\ 1 6 & = 3/ 1 6. \\ 1 6 & = 3/ 1 6. \\ 1 6 & = 3/ 1 6. \\ 1 6 & = 3/ 1 6. \\ 1 6 & = 3/ 1 6. \\ 1 6 & = 3/ 1 6. \\ 1 7 & = - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {3}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} - \frac {\cdot}{2} + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots + \dots ] & = - (\frac {3}{1 6}) ^ {- 1}. \\ (4) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (5) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (6) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (7) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (8) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (9) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (10) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (11) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (12) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (13) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (14) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (15) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (16) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (17) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (18) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (19) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (20) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (21) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (22) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (23) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (24) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (25) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (26) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (27) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (28) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (29) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (30) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (31) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (32) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (33) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (34) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (35) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (36) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (37) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (38) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (39) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (40) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (41) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (42) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (43) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (44) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (45) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (46) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (47) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (48) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (49) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (50) & = - (\frac {3}{1 6}) ^ {- 1}. \\ (50) & = - (\frac {3}{\mathrm {一}}).
$$

Note that is not allowed. 

Theorem 8.1 says that we also obtain this probability from the transition probabilities of one random walk as 

$$
\det  \left( \begin{array}{c c} 1 / 2 & 1 / 4 \\ 1 / 4 & 1 / 2 \end{array} \right) = \frac {1}{4} - \frac {1}{1 6} = \frac {3}{1 6}.
$$

Proof of Theorem 8.1. Let $\Omega _ { i j }$ be the set of all possible paths in $t$ steps from $x _ { i }$ to $y _ { j }$ . Denote by $\mathbb { P } \left[ \pi \right]$ the probability for such a path $\pi \in \Omega _ { i j }$ . Then we have 

$$
P _ {t} \left(x _ {i}, y _ {j}\right) = \sum_ {\pi \in \Omega_ {i j}} \mathbb {P} [ \pi ]
$$

and we have to consider the determinant 

$$
\det \left(P _ {t} (x _ {i}, y _ {j})\right) _ {i, j = 1} ^ {n} = \det \left(\sum_ {\pi \in \Omega_ {i j}} \mathbb {P} [ \pi ]\right) _ {i, j = 1} ^ {n}.
$$

Let us consider the case $n = 2$ : 

$$
\det \left( \begin{array}{c c} \sum_ {\pi \in \Omega_ {1 1}} \mathbb {P} [ \pi ] & \sum_ {\pi \in \Omega_ {1 2}} \mathbb {P} [ \pi ] \\ \sum_ {\pi \in \Omega_ {2 1}} \mathbb {P} [ \pi ] & \sum_ {\pi \in \Omega_ {2 2}} \mathbb {P} [ \pi ] \end{array} \right) = \sum_ {\pi \in \Omega_ {1 1}} \mathbb {P} [ \pi ] \cdot \sum_ {\sigma \in \Omega_ {2 2}} \mathbb {P} [ \sigma ] - \sum_ {\pi \in \Omega_ {1 2}} \mathbb {P} [ \pi ] \cdot \sum_ {\sigma \in \Omega_ {2 1}} \mathbb {P} [ \sigma ]
$$

Here, the first term counts all pairs of paths $x _ { 1 }  y _ { 1 }$ and $x _ { 2 }  y _ { 2 }$ ; hence noncrossing ones, but also crossing ones. However, such a crossing pair of paths is, via the “reflection principle” (where we exchange the parts of the two paths after their first crossing), in bijection with a pair of paths from $x _ { 1 }  y _ { 2 }$ and $x _ { 2 }  y _ { 1 }$ ; this bijection also preserves the probabilities. 

Those paths, $x _ { 1 } \  \ y _ { 2 }$ and $x _ { 2 } \ \to \ y _ { 1 }$ , are counted by the second term in the determinant. Hence the second term cancels out all the crossing terms in the first term, leaving only the non-crossing paths. 

For general $n$ it works in a similar way. 

# 8.2 Combinatorial version à la Gessel–Viennot

Let $G$ be a weighted directed graph without directed cycles, e.g. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/585fc68093a68e78e48ebb8c8c2618f3537873e12b093d74966535e73b40c697.jpg)


where we have weights $m _ { i j } = m _ { e }$ on each edge $i \stackrel { e } { \to } j$ . This gives weights for directed paths 

$$
P = \begin{array}{c c} \hline \bullet & \bullet \\ \bullet & \bullet \end{array} \begin{array}{c c} \hline \bullet & \bullet \\ \bullet & \bullet \end{array} \begin{array}{c c} \hline \bullet & \bullet \\ \bullet & \bullet \end{array} \quad \mathrm {v i a} \qquad m (P) = \prod_ {e \in P} m _ {e},
$$

and then also a weight for connecting two vertices $a , b$ , 

$$
m (a, b) = \sum_ {P: a \to b} m (P),
$$

where we sum over all directed paths from $a$ to $b$ . Note that this is a finite sum, because we do not have directed cycles in our graph. 

Definition 8.3. Consider two $n$ -tuples of vertices $A \ = \ ( a _ { 1 } , \ldots , a _ { n } )$ and $B \ =$ $\left( b _ { 1 } , \ldots , b _ { n } \right)$ . A path system $P \colon A  B$ is given by a permutation $\sigma \in S _ { n }$ and paths $P _ { i } \colon a _ { i } \to b _ { \sigma ( i ) }$ for $i = 1 , \ldots , n$ . We also put $\sigma ( P ) = \sigma$ and $\operatorname { s g n } P = \operatorname { s g n } \sigma$ . A vertex-disjoint path system is a path system $( P _ { 1 } , \ldots , P _ { n } )$ , where the paths $P _ { 1 } , \ldots , P _ { n }$ do not have a common vertex. 

Lemma 8.4 (Gessel–Viennot). Let $G$ be a finite acyclic weighted directed graph and let $A = \left( a _ { 1 } , \ldots , a _ { n } \right)$ and $B = ( b _ { 1 } , \ldots , b _ { n } )$ be two $n$ -sets of vertices. Then we have 

$$
\det \left(m(a_{i},b_{j})\right)_{i,j = 1}^{n} = \sum_{\substack{P\colon A\to B\\ vertex - disjoint}}\operatorname {sgn}\sigma (P)\prod_{i = 1}^{n}m(P_{i}).
$$

Proof. Similar as the proof of Theorem 8.1; the crossing paths cancel each other out in the determinant. □ 

This lemma can be useful in two directions. Whereas in the stochastic setting one uses mainly the determinant to count non-crossing paths, one can also count vertex-disjoint path systems to calculate determinants. The following is an example of this. 

Example 8.5. Let $C _ { n }$ be the Catalan numbers 

$$
C _ {0} = 1, C _ {1} = 1, C _ {2} = 2, C _ {3} = 5, C _ {4} = 1 4, \dots
$$

and consider 

$$
M _ {n} = \left( \begin{array}{c c c c} C _ {0} & C _ {1} & \dots & C _ {n} \\ C _ {1} & C _ {2} & \dots & C _ {n + 1} \\ \vdots & & \ddots & \vdots \\ C _ {n} & C _ {n + 1} & \dots & C _ {2 n} \end{array} \right).
$$

Then we have 

$$
\det  M _ {0} = \det  (1) = 1,
$$

$$
\det  M _ {1} = \det  \left( \begin{array}{c c} 1 & 1 \\ 1 & 2 \end{array} \right) = 2 - 1 = 1,
$$

$$
\det  M _ {2} = \det  \left( \begin{array}{c c c} 1 & 1 & 2 \\ 1 & 2 & 5 \\ 2 & 5 & 1 4 \end{array} \right) = 2 8 + 1 0 + 1 0 - 8 - 1 4 - 2 5 = 1.
$$

This is actually true for all $n$ : $\operatorname* { d e t } M _ { n } = 1$ . This is not obvious directly, but follows easily from Gessel–Viennot, if one chooses the right setting. 

Let us show it for $M _ { 2 }$ . For this, consider the graph 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/a6cd6ed5f67f0ba1d821ddb7607669ccf6ce0e7a9d00ce3e201106115969bad1.jpg)


The possible directions in the graph are up and right, and all weights are chosen as 1. Paths in this graph correspond to Dyck graphs, and thus the weights for connecting the $a$ ’s with the $b$ ’s are counted by Catalan numbers; e.g., 

$$
m \left(a _ {0}, b _ {0}\right) = C _ {0},
$$

$$
m \left(a _ {0}, b _ {1}\right) = C _ {1},
$$

$$
m \left(a _ {0}, b _ {2}\right) = C _ {2},
$$

$$
m \left(a _ {2}, b _ {2}\right) = C _ {4}.
$$

Thus 

$$
M _ {2} = \det  \left( \begin{array}{c c c} m (a _ {0}, b _ {0}) & m (a _ {0}, b _ {1}) & m (a _ {0}, b _ {2}) \\ m (a _ {1}, b _ {0}) & m (a _ {1}, b _ {1}) & m (a _ {1}, b _ {2}) \\ m (a _ {2}, b _ {0}) & m (a _ {2}, b _ {1}) & m (a _ {2}, b _ {2}) \end{array} \right)
$$

and hence, by Gessel-Viennot, 

$$
\det M_{2} = \det \left(m(a_{i},b_{j})\right)_{i,j = 0}^{2} = \sum_{\substack{P: (a_{0},a_{1},a_{2})\to (b_{0},b_{1},b_{2})\\ \text{vertex - disjoint}}}1 = 1,
$$

since there is only one such vertex-disjoint system of three paths, corresponding to $\sigma = \mathrm { i d }$ . This is given as follows; note that the path from $a _ { 0 }$ to $b _ { 0 }$ is actually a path with 0 steps. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/29cb2d5d288e7eca0d7d2c2d0e2cd611e55fd88fa2cbd5e5614c97467d07c5ef.jpg)


# 8.3 Dyson Brownian motion and non-intersecting paths

We have seen that the eigenvalues of random matrices repel each other. This becomes even more apparent when we consider process versions of our random matrices, where the eigenvalue processes yield then non-intersecting paths. Those process versions of our Gaussian ensembles are called Dyson Brownian motions. They are defined as $A _ { N } ( t ) : = ( a _ { i j } ( t ) ) _ { i , j = 1 } ^ { N } \left( t \geq 0 \right)$ , where each $a _ { i j } ( t )$ is a classical Brownian motion (complex or real) and they are independent, apart from the symmetry condition $a _ { i j } ( t ) = \bar { a } _ { j i } ( t )$ for all $t \geq 0$ and all $i , j = 1 , \dots , N$ . The eigenvalues $\lambda _ { 1 } ( t ) , \ldots , \lambda _ { N } ( t )$ of $A _ { N } ( t )$ give then $N$ non-intersecting Brownian motions. 

Here are plots for discretized random walk versions of the Dyson Brownian motion, corresponding to goe(13), gue(13) and, for comparision, also 13 independent 

Brownian motions; see also Exercise 24. Guess which is which! 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/34d298639902bda78efe74777a47567d3a94c15970ec3b9763176485ff3d7ae5.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/193b13c03cfadc3cc051dafc9eb4cb6834fa1628fce9e8db6eeefd1ed0ec2f11.jpg)


![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/ad3d0258b019afe31baebeea4002b47c53fd2493d93d5372933c46dff7466d3f.jpg)


# 9 Statistics of the Largest Eigenvalue and Tracy–Widom Distribution

Consider gue(n) or goe(n). For large $N$ , the eigenvalue distribution is close to a semircircle with density 

$$
p (x) = \frac {1}{2 \pi} \sqrt {4 - x ^ {2}}.
$$

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/bf272af4406848ec461ecb7943408a4bd4fbfd477223794f19a9a446b1084513.jpg)


We will now zoom to a microscopic level and try to understand the behaviour of a single eigenvalue. The behaviour in the bulk and at the edge is different. We are particularly interested in the largest eigenvalue. Note that at the moment we do not even know whether the largest eigenvalue sticks close to 2 with high probability. Wigner’s semicircle law implies that it cannot go far below 2, but it does not prevent it from being very large. We will in particular see that this cannot happen. 

# 9.1 Some heuristics on single eigenvalues

Let us first check heuristically what we expect as typical order of fluctuations of the eigenvalues. For this we assume (without justification) that the semicircle predicts the behaviour of eigenvalues down to the microscopic level. 

Behaviour in the bulk: In $[ \lambda , \lambda + t ]$ there should be $\sim t p ( \lambda ) N$ eigenvalues. This is of order 1 if we choose $t \sim 1 / N$ . This means that eigenvalues in the bulk have 

for their position an interval of size $\sim 1 / N$ , so this is a good guess for the order of fluctuations for an eigenvalue in the bulk. 

Behaviour at the edge: In $[ 2 - t , 2 ]$ there should be roughly 

$$
N \int_ {2 - t} ^ {2} p (x) \mathrm {d} x = \frac {N}{2 \pi} \int_ {2 - t} ^ {2} \sqrt {(2 - x) (2 + x)} \mathrm {d} x
$$

many eigenvalues. To have this of order 1, we should choose $t$ as follows: 

$$
1 \approx \frac {N}{2 \pi} \int_ {2 - t} ^ {2} \sqrt {(2 - x) (2 + x)} \mathrm {d} x \approx \frac {N}{\pi} \int_ {2 - t} ^ {2} \sqrt {2 - x} \mathrm {d} x = \frac {N}{\pi} \frac {2}{3} t ^ {\frac {3}{2}}
$$

Thus $1 \sim t ^ { 3 / 2 } N$ , i.e., $t \sim N ^ { - 2 / 3 }$ . Hence we expect for the largest eigenvalue an interval or fluctuations of size $N ^ { - 2 / 3 }$ . Very optimistically, we might expect 

$$
\lambda_ {\mathrm {m a x}} \approx 2 + N ^ {- 2 / 3} X,
$$

where $X$ has $N$ -independent distribution. 

# 9.2 Tracy–Widom distribution

This heuristics (at least its implication) is indeed true and one has that the limit 

$$
F _ {\beta} (x) := \lim _ {N \to \infty} \mathbb {P} \left[ N ^ {2 / 3} (\lambda_ {\max} - 2) \leq x \right]
$$

exists. It is called the Tracy–Widom distribution. 

Remark 9.1. (1) Note the parameter $\beta$ ! This corresponds to: 

<table><tr><td>ensemble</td><td>β</td><td>repulsion</td></tr><tr><td>GOE</td><td>1</td><td>(λi-λj)1</td></tr><tr><td>GUE</td><td>2</td><td>(λi-λj)2</td></tr><tr><td>GSE</td><td>4</td><td>(λi-λj)4</td></tr></table>

It turns out that the statistics of the largest eigenvalue is different for real, complex, quaternionic Gaussian random matrices. The behaviour on the microscopic level is more sensitive to the underlying symmetry than the macroscopic behaviour; note that we get the semicircle as the macroscopic limit for all three ensembles. (In models in physics the choice of $\beta$ corresponds often to underlying physical symmetries; e.g., goe is used to describe systems which have a time-reversal symmetry.) 

(2) On the other hand, when $\beta$ is fixed, there is a large universality class for the corresponding Tracy–Widom distribution. $F _ { 2 } ^ { \prime }$ shows up as limiting fluctuations for 

(a) largest eigenvalue of gue (Tracy, Widom, 1993), 

(b) largest eigenvalue of more general Wigner matrices (Soshnikov, 1999), 

(c) largest eigenvalue of general unitarily invariant matrix ensembles (Deift et al., 1994-2000), 

(d) length of the longest increasing subsequence of random permutations (Baik, Deift, Johansson, 1999; Okounkov, 2000), 

(e) arctic cicle for Aztec diamond (Johansson, 2005), 

(f) various growth processes like ASEP (“asymmetric single exclusion process”), TASEP (“totally asymmetric ...”). 

(3) There is still no uniform explanation for this universality. The feeling is that the Tracy-Widom distribution is somehow the analogue of the normal distribution for a kind of central limit theorem, where independence is replaced by some kind of dependence. But no one can make this precise at the moment. 

(4) Proving Tracy–Widom for gue is out of reach for us, but we will give some ideas. In particular, we try to derive rigorous estimates which show that our $N ^ { - 2 / 3 }$ -heuristic is of the right order and, in particular, we will prove that the largest eigenvalue converges almost surely to 2. 

# 9.3 Convergence of the largest eigenvalue to 2

We want to derive an estimate, in the gue case, for the probability $\mathbb { P } \left[ \lambda _ { \operatorname* { m a x } } \geq 2 + \varepsilon \right]$ which is compatible with our heuristic that $\varepsilon$ should be of the order $N ^ { - 2 / 3 }$ . We will refine our moment method for this. Let $A _ { N }$ be our normalized gue(n). We have for all $k \in \mathbb N$ : 

$$
\begin{array}{l} \mathbb {P} \left[ \lambda_ {\max } \geq 2 + \varepsilon \right] = \mathbb {P} \left[ \lambda_ {\max } ^ {2 k} \geq (2 + \varepsilon) ^ {2 k} \right] \\ \leq \mathbb {P} \left[ \sum_ {j = 1} ^ {N} \lambda_ {j} ^ {2 k} \geq (2 + \varepsilon) ^ {2 k} \right] \\ = \mathbb {P} \left[ \operatorname {t r} A _ {N} ^ {2 k} \geq \frac {(2 + \varepsilon) ^ {2 k}}{N} \right] \\ \leq \frac {N}{(2 + \varepsilon) ^ {2 k}} \mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {2 k} \right]. \\ \end{array}
$$

In the last step we used Markov’s inequality 6.3; note that we have even powers, and hence the random variable $\mathrm { t r } ( A _ { N } ^ { 2 k } )$ is positive. 

In Theorem 2.15 we calculated the expectation in terms of a genus expansion as 

$$
\mathbb {E} \left[ \mathrm {t r} (A _ {N} ^ {2 k}) \right] = \sum_ {\pi \in \mathcal {P} _ {2} (2 k)} N ^ {\# (\gamma \pi) - k - 1} = \sum_ {g \geq 0} \varepsilon_ {g} (k) N ^ {- 2 g},
$$

where 

$$
\varepsilon_ {g} (k) = \# \left\{\pi \in \mathcal {P} _ {2} (2 k) \mid \pi \text {h a s g e n u s} g \right\}.
$$

The inequality 

$$
\mathbb {P} \left[ \lambda_ {\max } \geq 2 + \varepsilon \right] \leq \frac {N}{(2 + \varepsilon) ^ {2 k}} \mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {2 k} \right]
$$

is useless if $k$ is fixed for $N \to \infty$ , because then the right hand side goes to $\infty$ . Hence we also have to scale $k$ with $N$ (we will use $k \sim N ^ { 2 / 3 }$ ), but then the sub-leading terms in the genus expansion become important. Up to now we only know that $\varepsilon _ { 0 } ( k ) = C _ { k }$ , but now we need some information on the other $\varepsilon _ { g } ( k )$ . This is provided by a theorem of Harer and Zagier. 

Theorem 9.2 (Harer–Zagier, 1986). Let us define $b _ { k }$ by 

$$
\sum_ {g \geq 0} \varepsilon_ {g} (k) N ^ {- 2 g} = C _ {k} b _ {k},
$$

where $C _ { k }$ are the Catalan numbers. (Note that the $b _ { k }$ depend also on $N$ , but we suppress this dependency in the notation.) Then we have the recursion formula 

$$
b _ {k + 1} = b _ {k} + \frac {k (k + 1)}{4 N ^ {2}} b _ {k - 1}
$$

for al l $k \geq 2$ . 

We will prove this later; see Section 9.6. For now, let us just check it for small examples. 

Example 9.3. From Remark 2.16 we know 

$$
C _ {1} b _ {1} = \mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {2} \right] = 1,
$$

$$
C _ {2} b _ {2} = \mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {4} \right] = 2 + \frac {1}{N ^ {2}},
$$

$$
C _ {3} b _ {3} = \mathbb {E} \left[ \mathrm {t r} A _ {N} ^ {6} \right] = 5 + \frac {1 0}{N ^ {2}},
$$

$$
C _ {4} b _ {4} = \mathbb {E} \left[ \mathrm {t r} A _ {N} ^ {8} \right] = 1 4 + \frac {7 0}{N ^ {2}} + \frac {2 1}{N ^ {4}},
$$

which gives 

$$
b _ {1} = 1, \qquad b _ {2} = 1 + \frac {1}{2 N ^ {2}}, \qquad b _ {3} = 1 + \frac {2}{N ^ {2}}, \qquad b _ {4} = 1 + \frac {5}{N ^ {2}} + \frac {3}{2 N ^ {4}}.
$$

We now check the recursion from Theorem 9.2 for $k = 3$ : 

$$
\begin{array}{l} b _ {3} + \frac {k (k + 1)}{4 N ^ {2}} b _ {2} = 1 + \frac {2}{N ^ {2}} + \frac {1 2}{4 N ^ {2}} \left(1 + \frac {1}{2 N ^ {2}}\right) \\ = 1 + \frac {5}{N ^ {2}} + \frac {3}{2 N ^ {4}} \\ = b _ {4} \\ \end{array}
$$

Corollary 9.4. For all $N , k \in \mathbb { N }$ we have for a gue(n) matrix $A _ { N }$ that 

$$
\mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {2 k} \right] \leq C _ {k} \exp \left(\frac {k ^ {3}}{2 N ^ {2}}\right).
$$

Proof. Note that, by definition, $b _ { k } > 0$ for all $k \in \mathbb N$ and hence, by Theorem 9.2, $b _ { k + 1 } > b _ { k }$ . Thus, 

$$
b _ {k + 1} = b _ {k} + \frac {k (k + 1)}{4 N ^ {2}} b _ {k - 1} \leq b _ {k} \left(1 + \frac {k (k + 1)}{4 N ^ {2}}\right) \leq b _ {k} \left(1 + \frac {k ^ {2}}{2 N ^ {2}}\right);
$$

iteration of this yields 

$$
\begin{array}{l} b _ {k} \leq \left(1 + \frac {(k - 1) ^ {2}}{2 N ^ {2}}\right) \left(1 + \frac {(k - 2) ^ {2}}{2 N ^ {2}}\right) \dots \left(1 + \frac {1 ^ {2}}{2 N ^ {2}}\right) \\ \leq \left(1 + \frac {k ^ {2}}{2 N ^ {2}}\right) ^ {k} \\ \leq \exp \left(\frac {k ^ {2}}{2 N ^ {2}}\right) ^ {k} \quad \text {s i n c e} 1 + x \leq e ^ {x} \\ = \exp \left(\frac {k ^ {3}}{2 N ^ {2}}\right) \\ \end{array}
$$

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/c5b6ca4f24f12439acb564a87466e03d9040b34a252825811b8596c6da8ab0ef.jpg)


We can now continue our estimate for the largest eigenvalue. 

$$
\begin{array}{l} \mathbb {P} \left[ \lambda_ {\max } \geq 2 + \varepsilon \right] \leq \frac {N}{(2 + \varepsilon) ^ {2 k}} \mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {2 k} \right] \\ = \frac {N}{(2 + \varepsilon) ^ {2 k}} C _ {k} b _ {k} \\ \leq \frac {N}{(2 + \varepsilon) ^ {2 k}} C _ {k} \exp \left(\frac {k ^ {3}}{2 N ^ {2}}\right) \\ \leq \frac {N}{(2 + \varepsilon) ^ {2 k}} \frac {4 ^ {k}}{k ^ {3 / 2}} \exp \left(\frac {k ^ {3}}{2 N ^ {2}}\right). \\ \end{array}
$$

For the last estimate, we used (see Exercise 26) 

$$
C _ {k} \leq \frac {4 ^ {k}}{\sqrt {\pi} k ^ {3 / 2}} \leq \frac {4 ^ {k}}{k ^ {3 / 2}}.
$$

Let us record our main estimate in the following proposition. 

Proposition 9.5. For a normalized gue(n) matrix $A _ { N }$ we have for all $N , k \in \mathbb { N }$ and all $\varepsilon > 0$ 

$$
\mathbb {P} \left[ \lambda_ {\max } \left(A _ {N}\right) \geq 2 + \varepsilon \right] \leq \frac {N}{(2 + \varepsilon) ^ {2 k}} \frac {4 ^ {k}}{k ^ {3 / 2}} \exp \left(\frac {k ^ {3}}{2 N ^ {2}}\right).
$$

This estimate is now strong enough to see that the largest eigenvalue has actually to converge to 2. For this, let us fix $\varepsilon ~ > ~ 0$ and choose $k$ depending on $N$ as $k _ { N } : = \lfloor N ^ { 2 / 3 } \rfloor$ , where $\lfloor x \rfloor$ denotes the smallest integer $\geq x$ . Then 

$$
\frac {N}{k _ {N} ^ {3 / 2}} \xrightarrow {N \to \infty} 1 \qquad \text {a n d} \qquad \frac {k _ {N} ^ {3}}{2 N ^ {2}} \xrightarrow {N \to \infty} \frac {1}{2}.
$$

Hence 

$$
\lim  _ {N \rightarrow \infty} \mathbb {P} \left[ \lambda_ {\max } \geq 2 + \varepsilon \right] \leq \lim  _ {N \rightarrow \infty} \left(\frac {2}{2 + \varepsilon}\right) ^ {2 k _ {N}} \cdot 1 \cdot e ^ {1 / 2} = 0,
$$

and thus for all $\varepsilon > 0$ , 

$$
\lim  _ {N \to \infty} \mathbb {P} \left[ \lambda_ {\max } \geq 2 + \varepsilon \right] = 0.
$$

This says that the largest eigenvalue $\lambda _ { \mathrm { m a x } }$ of a gue converges in probability to 2. 

Corollary 9.6. For a normalized gue(n) matrix $A _ { N }$ we have that its largest eigenvalue converges in probability, and also almost surely, to 2, i.e., 

$$
\lambda_ {\max } \left(A _ {N}\right) \xrightarrow {N \rightarrow \infty} 2 \quad a l m o s t s u r e l y.
$$

Proof. The convergence in probability was shown above. For the strenghtening to almost sure convergence one has to use Borel–Cantelli and the fact that 

$$
\sum_ {N} \left(\frac {2}{2 + \varepsilon}\right) ^ {2 k _ {N}} <   \infty .
$$

See Exercise 28. 

# 9.4 Estimate for fluctuations

Our estimate from Proposition 9.5 gives also some information about the fluctuations of $\lambda _ { \mathrm { m a x } }$ about 2, if we choose $\varepsilon$ also depending on $N$ . Let us use there now 

$$
k _ {N} = \left\lfloor N ^ {2 / 3} r \right\rfloor \qquad \mathrm {a n d} \qquad \varepsilon_ {N} = N ^ {- 2 / 3} t.
$$

Then 

$$
\frac {N}{k _ {N} ^ {3 / 2}} \xrightarrow {N \to \infty} \frac {1}{r ^ {3 / 2}} \qquad \mathrm {a n d} \qquad \frac {k _ {N} ^ {3}}{2 N ^ {2}} \xrightarrow {N \to \infty} \frac {r ^ {3}}{2},
$$

and 

$$
\frac {4 ^ {k _ {N}}}{(2 + \varepsilon_ {N}) ^ {2 k _ {N}}} = \left(\frac {1}{1 + \frac {1}{2 N ^ {2 / 3}} t}\right) ^ {2 \left\lfloor N ^ {2 / 3} r \right\rfloor} \xrightarrow {N \to \infty} e ^ {- r t},
$$

and thus 

$$
\lim _ {N \to \infty} \sup _ {\lambda \geq 2 + t N ^ {- 2 / 3}} \mathbb {P} \left[ \lambda_ {\max} \geq 2 + t N ^ {- 2 / 3} \right] \leq \frac {1}{r ^ {3 / 2}} e ^ {r ^ {3} / 2} e ^ {- r t}
$$

for arbitrary $r > 0$ . We optimize this now by choosing $r = { \sqrt { t } }$ for $t > 0$ and get 

Proposition 9.7. For a normalized gue(n) matrix $A _ { N }$ we have for all $t > 0$ 

$$
\lim  _ {N \rightarrow \infty} \mathbb {P} \left[ \lambda_ {\max } (A _ {N}) \geq 2 + t N ^ {- \frac {2}{3}} \right] \leq t ^ {- 3 / 4} \exp \left(- \frac {1}{2} t ^ {3 / 2}\right).
$$

Although this estimate does not prove the existence of the limit on the left hand side, it turns out that the right hand side is quite sharp and captures the tail behaviour of the Tracy–Widom distribution quite well. 

# 9.5 Non-rigorous derivation of Tracy–Widom distribution

For determining the Tracy–Widom fluctuations in the limit $N \to \infty$ one has to use the analytic description of the gue joint density. Recall from Theorem 7.20 that the joint density of the unordered eigenvalues of an unnormalized gue(n) is given by 

$$
p (\mu_ {1}, \dots , \mu_ {N}) = \frac {1}{N !} \det  (K _ {N} (\mu_ {i}, \mu_ {j})) _ {i, j = 1} ^ {N},
$$

where $K _ { N }$ is the Hermite kernel 

$$
K _ {N} (x, y) = \sum_ {k = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {k} (y)
$$

with the Hermite functions $\Psi _ { k }$ from Definition 7.12. Because $K _ { N }$ is a reproducing kernel, we can integrate out some of the eigenvalues and get a density of the same form. If we are integrate out all but $r$ eigenvalues we get, by Lemma 7.17, 

$$
\begin{array}{l} \int_ {\mathbb {R}} \dots \int_ {\mathbb {R}} p \left(\mu_ {1}, \dots , \mu_ {N}\right) d \mu_ {r + 1} \dots d \mu_ {N} = \frac {1}{N !} \cdot 1 \cdot 2 \dots (N - r) \cdot \det  \left(K _ {N} \left(\mu_ {i}, \mu_ {j}\right)\right) _ {i, j = 1} ^ {r} \\ = \frac {(N - r) !}{N !} \det  \left(K _ {N} \left(\mu_ {i}, \mu_ {j}\right)\right) _ {i, j = 1} ^ {r} \\ =: p _ {N} \left(\mu_ {1}, \dots , \mu_ {r}\right). \\ \end{array}
$$

Now consider 

$$
\begin{array}{l} \mathbb {P} \left[ \mu_ {\max } ^ {(N)} \leq t \right] = \mathbb {P} [ \text {t h e r e i s n o e i g e n v a l u e i n} (t, \infty) ] \\ = 1 - \mathbb {P} [ \text {t h e r e i s a n e i g e n v a l u e i n} (t, \infty) ] \\ = 1 - \left[ N \mathbb {P} \left[ \mu_ {1} \in (t, \infty) \right] - \binom {N} {2} \mathbb {P} \left[ \mu_ {1}, \mu_ {2} \in (t, \infty) \right] + \binom {N} {3} \mathbb {P} \left[ \mu_ {1}, \mu_ {2}, \mu_ {3} \in (t, \infty) \right] - \dots \right] \\ = 1 + \sum_ {r = 1} ^ {N} (- 1) ^ {r} \binom {N} {r} \int_ {t} ^ {\infty} \dots \int_ {t} ^ {\infty} p _ {N} (\mu_ {1}, \ldots , \mu_ {r})   \mathrm {d} \mu_ {1} \dots \mathrm {d} \mu_ {r} \\ = 1 + \sum_ {r = 1} ^ {N} (- 1) ^ {r} \frac {1}{r !} \int_ {t} ^ {\infty} \dots \int_ {t} ^ {\infty} \det  \left(K \left(\mu_ {i}, \mu_ {j}\right)\right) _ {i, j = 1} ^ {r} d \mu_ {1} \dots d \mu_ {r}. \\ \end{array}
$$

Does this have a limit for $N  \infty$ ? 

Note that √ $p$ is the distribution for a gue(n) without normalization, i.e., $\mu _ { \mathrm { m a x } } ^ { ( N ) } \approx$ $2 \sqrt { N }$ . More precisely, we expect fluctutations 

$$
\mu_ {\mathrm {m a x}} ^ {(N)} \approx \sqrt {N} \left(2 + t N ^ {- 2 / 3}\right) = 2 \sqrt {N} + t N ^ {- 1 / 6}.
$$

We put 

$$
\tilde {K} _ {N} (x, y) = N ^ {- 1 / 6} \cdot K _ {N} \left(2 \sqrt {N} + x N ^ {- 1 / 6}, 2 \sqrt {N} + y N ^ {- 1 / 6}\right)
$$

so that we have 

$$
\mathbb {P} \left[ N ^ {2 / 3} \left(\frac {\mu_ {\max } ^ {(N)} - 2}{\sqrt {N}} - 2\right) \leq t \right] = \sum_ {r = 0} ^ {N} \frac {(- 1) ^ {r}}{r !} \int_ {t} ^ {\infty} \dots \int_ {t} ^ {\infty} \det  \left(\tilde {K} (x _ {i}, x _ {j})\right) _ {i, j = 1} ^ {r} \mathrm {d} x _ {1} \dots \mathrm {d} x _ {r}.
$$

We expect that the limit 

$$
F _ {2} (t) := \lim _ {N \to \infty} \mathbb {P} \left[ N ^ {2 / 3} \left(\frac {\mu_ {\mathrm {m a x}} ^ {(N)} - 2}{\sqrt {N}} - 2\right) \leq t \right]
$$

exists. For this, we need the limit $\operatorname* { l i m } _ { N  \infty } \dot { K } _ { N } ( x , y )$ . Recall that 

$$
K _ {N} (x, y) = \sum_ {k = 0} ^ {N - 1} \Psi_ {k} (x) \Psi_ {k} (y).
$$

As this involves $\Psi _ { k }$ for all $k = 0 , 1 , \ldots , N - 1$ this is not amenable to taking the limit $N  \infty$ . However, by the Christoffel–Darboux identity for the Hermite functions (see Exercise 27)) 

$$
\sum_ {k = 0} ^ {n - 1} \frac {H _ {k} (x) H _ {k} (y)}{k !} = \frac {H _ {n} (x) H _ {n - 1} (y) - H _ {n - 1} (x) H _ {n} (y)}{(x - y) (n - 1) !}
$$

and with 

$$
\Psi_ {k} (x) = (2 \pi) ^ {- 1 / 4} (k!) ^ {- 1 / 2} e ^ {- \frac {1}{4} x ^ {2}} H _ {k} (x),
$$

as defined in Definition 7.12, we can rewrite $K _ { N }$ in the form 

$$
\begin{array}{l} K _ {N} (x, y) = \frac {1}{\sqrt {2 \pi}} \sum_ {k = 0} ^ {N - 1} \frac {1}{k !} e ^ {- \frac {1}{4} \left(x ^ {2} + y ^ {2}\right)} H _ {k} (x) H _ {k} (y) \\ = \frac {1}{\sqrt {2 \pi}} e ^ {- \frac {1}{4} (x ^ {2} + y ^ {2})} \frac {H _ {N} (x) H _ {N - 1} (y) - H _ {N - 1} (x) H _ {N} (y)}{(x - y) (N - 1) !} \\ = \sqrt {N} \cdot \frac {\Psi_ {N} (x) \Psi_ {N - 1} (y) - \Psi_ {N - 1} (x) \Psi_ {N} (y)}{x - y}. \\ \end{array}
$$

Note that the $\Psi _ { N }$ satisfy the differential equation (see Exercise 30) 

$$
\Psi_ {N} ^ {\prime} (x) = - \frac {x}{2} \Psi_ {N} (x) + \sqrt {N} \Psi_ {N - 1} (x),
$$

and thus 

$$
\begin{array}{l} K _ {N} (x, y) = \frac {\Psi_ {N} (x) \left[ \Psi_ {N} ^ {\prime} (y) + \frac {y}{2} \Psi_ {N} (y) \right] - \left[ \Psi_ {N} ^ {\prime} (x) + \frac {x}{2} \Psi_ {N} (x) \right] \Psi_ {N} (y)}{x - y} \\ = \frac {\Psi_ {N} (x) \Psi_ {N} ^ {\prime} (y) - \Psi_ {N} ^ {\prime} (x) \Psi_ {N} (y)}{x - y} - \frac {1}{2} \Psi_ {N} (x) \Psi_ {N} (y). \\ \end{array}
$$

Now put 

$$
\widetilde {\Psi} _ {N} (x) := N ^ {1 / 1 2} \cdot \Psi_ {N} \left(2 \sqrt {N} + x N ^ {- 1 / 6}\right),
$$

thus 

$$
\widetilde {\Psi} _ {N} ^ {\prime} (x) = N ^ {1 / 1 2} \cdot \Psi_ {N} ^ {\prime} \left(2 \sqrt {N} + x N ^ {- 1 / 6}\right) \cdot N ^ {- 1 / 6} = N ^ {- 1 / 1 2} \cdot \Psi_ {N} ^ {\prime} \left(2 \sqrt {N} + x N ^ {- 1 / 6}\right).
$$

Then 

$$
\tilde {K} (x, y) = \frac {\widetilde {\Psi} _ {N} (x) \widetilde {\Psi} _ {N} ^ {\prime} (y) - \widetilde {\Psi} _ {N} ^ {\prime} (x) \widetilde {\Psi} _ {N} (y)}{x - y} - \frac {1}{2 N ^ {1 / 3}} \widetilde {\Psi} _ {N} ^ {\prime} (x) \widetilde {\Psi} _ {N} ^ {\prime} (y).
$$

One can show, by a quite non-trivial steepest descent method, that $\tilde { \Psi } _ { N } ( x )$ converges to a limit. Let us call this limit the Airy function 

$$
\operatorname {A i} (x) = \lim _ {N \to \infty} \widetilde {\Psi} _ {N} (x).
$$

The convergence is actually so strong that also 

$$
\mathrm {A i} ^ {\prime} (x) = \lim _ {N \to \infty} \widetilde {\Psi} _ {N} ^ {\prime} (x),
$$

and hence 

$$
\lim _ {N \to \infty} \tilde {K} (x, y) = \frac {\operatorname {A i} (x) \operatorname {A i} ^ {\prime} (y) - \operatorname {A i} ^ {\prime} (x) \operatorname {A i} (y)}{x - y} =: \operatorname {A} (x, y).
$$

A is called the Airy kernel. 

Let us try, again non-rigorously, to characterize this limit function Ai. For the Hermite functions we have (see Exercise 30) 

$$
\Psi_ {N} ^ {\prime \prime} (x) + \left(N + \frac {1}{2} - \frac {x ^ {2}}{4}\right) \Psi_ {N} (x) = 0.
$$

For the $\tilde { \Psi } _ { N }$ we have 

$$
\widetilde {\Psi} _ {N} ^ {\prime} (x) = N ^ {- 1 / 1 2} \cdot \Psi_ {N} ^ {\prime} \left(2 \sqrt {N} + x N ^ {- 1 / 6}\right)
$$

and 

$$
\widetilde {\Psi} _ {N} ^ {\prime \prime} (x) = N ^ {- 1 / 4} \cdot \Psi_ {N} ^ {\prime \prime} \left(2 \sqrt {N} + x N ^ {- 1 / 6}\right).
$$

Thus, 

$$
\begin{array}{l} \widetilde {\Psi} _ {N} ^ {\prime \prime} (x) = - N ^ {- 1 / 4} \left[ N + \frac {1}{2} - \frac {\left(2 \sqrt {N} + x N ^ {- 1 / 6}\right) ^ {2}}{4} \right] \Psi_ {N} \left(2 \sqrt {N} + x N ^ {- 1 / 6}\right) \\ = - N ^ {- 1 / 3} \left[ N + \frac {1}{2} - \frac {4 N + 4 \sqrt {N} x N ^ {- 1 / 6} + x ^ {2} N ^ {- 1 / 3}}{4} \right] \widetilde {\Psi} _ {N} (x) \\ = - N ^ {- 1 / 3} \left[ \frac {1}{2} - \frac {4 x N ^ {1 / 3} + x ^ {2} N ^ {- 1 / 3}}{4} \right] \widetilde {\Psi} _ {N} (x) \\ \approx x \tilde {\Psi} _ {N} (x) \qquad \text {f o r l a r g e N}. \\ \end{array}
$$

Hence we expect that Ai should satisfy the differential equation 

$$
\operatorname {A i} ^ {\prime \prime} (x) - x \operatorname {A i} (x) = 0.
$$

This is indeed the case, but the proof is again beyond our tools. Let us just give the formal definition of the Airy function and formulate the final result. 

Definition 9.8. The Airy function Ai: $\mathbb { R } \to \mathbb { R }$ is a solution of the Airy ODE 

$$
u ^ {\prime \prime} (x) = x u (x)
$$

determined by the following asymptotics as $x \to \infty$ : 

$$
\operatorname {A i} (x) \sim \frac {1}{2 \sqrt {\pi}} x ^ {- 1 / 4} \exp \left(- \frac {2}{3} x ^ {3 / 2}\right).
$$

The Airy kernel is defined by 

$$
\mathrm {A} (x, y) = \frac {\mathrm {A i} (x) \mathrm {A i} ^ {\prime} (y) - \mathrm {A i} ^ {\prime} (x) \mathrm {A i} (y)}{x - y}.
$$

Theorem 9.9. The random variable $N ^ { 2 / 3 } ( \lambda _ { \operatorname* { m a x } } ( A _ { N } ) - 2 )$ of a normalized gue(n) has a limiting distribution as $N  \infty$ . Its limiting distribution function is 

$$
\begin{array}{l} F _ {2} (t): = \lim _ {N \to \infty} \mathbb {P} \left[ N ^ {\frac {2}{3}} (\lambda_ {\max} - 2) \leq t \right] \\ = \sum_ {r = 0} ^ {N} \frac {(- 1) ^ {r}}{r !} \int_ {t} ^ {\infty} \dots \int_ {t} ^ {\infty} \det (A (x _ {i}, x _ {j})) _ {i, j = 1} ^ {r} \mathrm {d} x _ {1} \dots \mathrm {d} x _ {r}. \\ \end{array}
$$

The form of $F _ { 2 } ^ { \prime }$ from Theorem 9.9 is more of a theoretical nature and not very convenient for calculations. A main contribution of Tracy–Widom in this context was that they were able to derive another, quite astonishing, representation of $F _ { 2 }$ . 

Theorem 9.10 (Tracy–Widom, 1994). The distribution function $F _ { 2 }$ satisfies 

$$
F _ {2} (t) = \exp \left(- \int_ {t} ^ {\infty} (x - t) q (x) ^ {2} \mathrm {d} x\right),
$$

where $q$ is a solution of the Painlevé II equation $q ^ { \prime \prime } ( x ) - x q ( x ) + 2 q ( x ) ^ { 3 } = 0$ with $q ( x ) \sim \mathrm { A i } ( x )$ as $x \to \infty$ . 

Here is a plot of the Tracy–Widom distribution $F _ { 2 }$ , via solving the Painlevé II equation from above, and a comparision with the histogram for the rescaled largest eigenvalue of 5000 gue(200); see also Exercise 31. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/abb8d11d614c6e13e2ee6477a9aa2dbb49800fbc73dd50c14aa8e3ef05b3263e.jpg)


# 9.6 Proof of the Harer–Zagier recursion

We still have to prove the recursion of Harer–Zagier, Theorem 9.2. 

Let us denote 

$$
T (k, N) := \mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {2 k} \right] = \sum_ {g \geq 0} \varepsilon_ {g} (k) N ^ {- 2 g}.
$$

The genus expansion shows that $T ( k , N )$ is, for fixed $k$ , a polynomial in $N ^ { - 1 }$ . Expressing it in terms of integrating over eigenvalues reveals the surprising fact that, up to a Gaussian factor, it is also a polynomial in $k$ for fixed $N$ . We show this in the next lemma. This is actually the only place where we need the random matrix interpretation of this quantity. 

Lemma 9.11. The expression 

$$
N ^ {k} \frac {1}{(2 k - 1) ! !} T (k, N)
$$

is a polynomial of degree $N - 1$ in $k$ . 

Proof. First check the easy case $N = 1$ : $T ( k , 1 ) = ( 2 k - 1 ) ! !$ is the $2 k$ -th moment of a normal variable and 

$$
\frac {T (k , 1)}{(2 k - 1) ! !} = 1
$$

is a polynomial of degree 0 in $k$ . 

For general $N$ we have 

$$
\begin{array}{l} T (k, N) = \mathbb {E} \left[ \operatorname {t r} A _ {N} ^ {2 k} \right] \\ = c _ {N} \int_ {\mathbb {R} ^ {N}} \left(\lambda_ {1} ^ {2 k} + \dots + \lambda_ {N} ^ {2 k}\right) e ^ {- \frac {N}{2} \left(\lambda_ {1} ^ {2} + \dots + \lambda_ {N} ^ {2}\right)} \prod_ {i <   j} \left(\lambda_ {i} - \lambda_ {j}\right) ^ {2} d \lambda_ {1} \dots d \lambda_ {N} \\ = N c _ {N} \int_ {\mathbb {R} ^ {N}} \lambda_ {1} ^ {2 k} e ^ {- \frac {N}{2} \left(\lambda_ {1} ^ {2} + \dots + \lambda_ {N} ^ {2}\right)} \prod_ {i \neq j} \left| \lambda_ {i} - \lambda_ {j} \right| d \lambda_ {1} \dots d \lambda_ {N} \\ = N c _ {N} \int_ {\mathbb {R}} \lambda_ {1} ^ {2 k} e ^ {- \frac {N}{2} \lambda_ {1} ^ {2}} p _ {N} (\lambda_ {1})   \mathrm {d} \lambda_ {1}, \\ \end{array}
$$

where $p _ { N }$ is the result of integrating the Vandermonde over $\lambda _ { 2 } , \ldots , \lambda _ { N }$ . It is an even polynomial in $\lambda _ { 1 }$ of degree $2 ( N - 1 )$ , whose coefficients depend only on $N$ and not on $k$ . Hence 

$$
p _ {N} (\lambda_ {1}) = \sum_ {l = 0} ^ {N - 1} \alpha_ {l} \lambda_ {1} ^ {2 l}
$$

with $\alpha _ { l }$ possibly depending on $N$ . Thus, 

$$
\begin{array}{l} T (k, N) = N c _ {N} \sum_ {l = 0} ^ {N - 1} \alpha_ {l} \int_ {\mathbb {R}} \lambda_ {1} ^ {2 k + 2 l} e ^ {- \frac {N}{2} \lambda_ {1} ^ {2}} d \lambda_ {1} \\ = N c _ {N} \sum_ {l = 0} ^ {N - 1} \alpha_ {l} \cdot k _ {N} \cdot (2 k + 2 l - 1)!! \cdot N ^ {- (k + l)}, \\ \end{array}
$$

since the integral over $\lambda _ { 1 }$ gives the $( 2 k + 2 l )$ -th moment of a Gauss variable of variance $N ^ { - 1 }$ , where $k _ { N }$ contains the $N$ -dependent normalization constants of the Gaussian measure; hence 

$$
\frac {N ^ {k} T (k , N)}{(2 k - 1) ! !}
$$

is a linear combination (with $N$ -dependent coefficients) of terms of the form 

$$
\frac {(2 k + 2 l - 1) ! !}{(2 k - 1) ! !}.
$$

These terms are polynomials in $k$ of degree $l$ 

We now have that 

$$
\begin{array}{l} N ^ {k} \frac {1}{(2 k - 1) ! !} T (k, N) = N ^ {k} \frac {1}{(2 k - 1) ! !} \sum_ {\pi \in \mathcal {P} _ {2} (2 k)} N ^ {\# (\gamma \pi) - k - 1} \\ = \frac {1}{N} \frac {1}{(2 k - 1) ! !} \sum_ {\pi \in \mathcal {P} _ {2} (2 k)} N ^ {\# (\gamma \pi)} \\ = \frac {1}{N} \frac {1}{(2 k - 1) ! !} t (k, N), \\ \end{array}
$$

where the last equality defines $t ( k , N )$ . 

By Lemma 9.11, $t ( k , N ) / ( 2 k - 1 ) ! !$ is a polynomial of degree $N - 1$ in $k$ . We interpret it as follows: 

$$
t (k, N) = \sum_ {\pi \in \mathcal {P} _ {2} (2 k)} \# \left\{\text {c o l o r i n g c y c l e s o f} \gamma \pi \text {w i t h a t m o s t} N \text {d i f f e r e n t c o l o r s} \right\}.
$$

Let us introduce 

$$
\tilde {t} (k, L) = \sum_ {\pi \in \mathcal {P} _ {2} (2 k)} \# \left\{\text {c o l o r i n g c y c l e s o f} \gamma \pi \text {w i t h e x a c t l y} L \text {d i f f e r e n t c o l o r s} \right\},
$$

then we have 

$$
t (k, N) = \sum_ {L = 1} ^ {N} \tilde {t} (k, L) \binom {N} {L},
$$

because if we want to use at most $N$ different colors, then we can do this by using exactly $L$ different colors (for any $L$ between 1 and $N$ ), and after fixing $L$ we have $\binom { N } { L }$ many possibilities to choose the $L$ colors among the $N$ colors. 

This relation can be inverted by 

$$
\tilde {t} (k, N) = \sum_ {L = 1} ^ {N} (- 1) ^ {N - L} \binom {N} {L} t (k, L)
$$

and hence $\bar { t } ( k , N ) / ( 2 k - 1 ) ! !$ is also a polynomial in $k$ of degree $N - 1$ . But now we have 

$$
0 = \tilde {t} (0, N) = \tilde {t} (1, N) = \dots = \tilde {t} (N - 2, N),
$$

since $\gamma \pi$ has, by Proposition 2.20, at most $k + 1$ cycles for $\pi \in \mathcal { P } _ { 2 } ( 2 k )$ ; and thus $\tilde { t } ( k + 1 , N ) = 0$ if $k + 1 < N$ , as we need at least $N$ cycles if we want to use $N$ different colors. 

So, $\tilde { t } ( k , N ) / ( 2 k - 1 ) ! !$ is a polynomial in $k$ of degree $N - 1$ and we know $N - 1$ zeros; hence it must be of the form 

$$
\frac {\tilde {t} (k , N)}{(2 k - 1) ! !} = \alpha_ {N} k (k - 1) \dots (k - N + 2) = \alpha_ {N} \binom {k} {N - 1} (N - 1)!
$$

Hence, 

$$
t (k, N) = \sum_ {L = 1} ^ {N} {\binom {N} {L}} {\binom {k} {L - 1}} (L - 1)! \alpha_ {L} (2 k - 1)!!.
$$

To identify $\alpha _ { N }$ we look at 

$$
\alpha_ {N + 1} \binom {N} {N} N! (2 N - 1)!! = \tilde {t} (N, N + 1) = C _ {N} (N + 1)!
$$

Note that only the NC pairings can be colored with exactly $N + 1$ colors, and for 

each such $\pi$ there are $( N + 1 )$ ! ways of doing so. We conclude 

$$
\begin{array}{l} \alpha_ {N + 1} = \frac {C _ {N} (N + 1) !}{N ! (2 N - 1) ! !} \\ = \frac {C _ {N} (N + 1)}{(2 N - 1) ! !} \\ = \frac {1}{N + 1} \binom {2 N} {N} \frac {N + 1}{(2 N - 1) ! !} \\ = \frac {(2 N) !}{N ! N ! (2 N - 1) ! !} \\ = \frac {2 ^ {N}}{N !}. \\ \end{array}
$$

Thus we have 

$$
\begin{array}{l} T (k, N) = \frac {1}{N ^ {k + 1}} t (k, N) \\ = \frac {1}{N ^ {k + 1}} \sum_ {L = 1} ^ {N} \binom {N} {L} \binom {k} {L - 1} (L - 1)! \frac {2 ^ {L - 1}}{(L - 1) !} (2 k - 1)!! \\ = (2 k - 1)!! \frac {1}{N ^ {k + 1}} \sum_ {L = 1} ^ {N} \binom {N} {L} \binom {k} {L - 1} 2 ^ {L - 1}. \\ \end{array}
$$

To get information from this on how this changes in $k$ we consider a generating function in $k$ , 

$$
\begin{array}{l} \mathcal {T} (s, N) = 1 + 2 \sum_ {k = 0} ^ {\infty} \frac {T (k , N)}{(2 k - 1) ! !} (N s) ^ {k + 1} \\ = 1 + 2 \sum_ {k = 0} ^ {\infty} \sum_ {L = 1} ^ {N} \binom {N} {L} \binom {k} {L - 1} 2 ^ {L - 1} s ^ {k + 1} \\ = \sum_ {L = 0} ^ {N} \binom {N} {L} 2 ^ {L} \sum_ {k = L - 1} ^ {\infty} \binom {k} {L - 1} s ^ {k + 1} \\ = \sum_ {L = 0} ^ {N} \binom {N} {L} 2 ^ {L} \left(\frac {s}{1 - s}\right) ^ {L} \\ = \sum_ {L = 0} ^ {N} \binom {N} {L} \left(\frac {2 s}{1 - s}\right) ^ {L} \\ \end{array}
$$

$$
\begin{array}{l} = \left(1 + \frac {2 s}{1 - s}\right) ^ {N} \\ = \left(\frac {1 + s}{1 - s}\right) ^ {N}. \\ \end{array}
$$

Note that (as in our calculation for the $\alpha _ { N }$ ) 

$$
\frac {1}{(2 k - 1) ! !} = \frac {2 ^ {k}}{k ! C _ {k} (k + 1)}
$$

and hence $T ( s , N )$ can also be rewritten as a generating function in our main quantity of interest, 

$$
b _ {k} ^ {(N)} = \frac {T (k , N)}{C _ {k}} \qquad (\mathrm {w e m a k e n o w t h e d e p e n d e n c e o f} b _ {k} \mathrm {o n} N \mathrm {e x p l i c i t})
$$

as 

$$
\begin{array}{l} \mathcal {T} (s, N) = 1 + 2 \sum_ {k = 0} ^ {\infty} \frac {T (k , N)}{(k + 1) ! C _ {k}} 2 ^ {k} (N s) ^ {k + 1} \\ = 1 + \sum_ {k = 0} ^ {\infty} \frac {b _ {k} ^ {(N)}}{(k + 1) !} (2 N s) ^ {k + 1}. \\ \end{array}
$$

In order to get a recursion for the $b _ { k } ^ { ( N ) }$ , we need some functional relation for $\mathcal { T } ( s , N )$ . Note that the recursion in Harer–Zagier involves $b _ { k }$ , $b _ { k + 1 }$ , $b _ { k - 1 }$ for the same $N$ , thus we need a relation which does not change the $N$ . For this we look on the derivative with respect to $s$ . From 

$$
\mathcal {T} (s, N) = \left(\frac {1 + s}{1 - s}\right) ^ {N}
$$

we get 

$$
\begin{array}{l} \frac {\mathrm {d}}{\mathrm {d} s} \mathcal {T} (s, N) = N \left(\frac {1 + s}{1 - s}\right) ^ {N - 1} \frac {(1 - s) + (1 + s)}{(1 - s) ^ {2}} \\ = 2 N \left(\frac {1 + s}{1 - s}\right) ^ {N} \frac {1}{(1 - s) (1 + s)} \\ = 2 N \cdot \mathcal {T} (s, N) \frac {1}{1 - s ^ {2}}, \\ \end{array}
$$

and thus 

$$
(1 - s ^ {2}) \frac {\mathrm {d}}{\mathrm {d} s} \mathcal {T} (s, N) = 2 N \cdot \mathcal {T} (s, N).
$$

Note that we have 

$$
\frac {\mathrm {d}}{\mathrm {d} s} \mathcal {T} (s, N) = \sum_ {k = 0} ^ {\infty} \frac {b _ {k} ^ {(N)}}{k !} (2 N s) ^ {k} 2 N.
$$

Thus, by comparing coefficients of $s ^ { k + 1 }$ in our differential equation from above, we conclude 

$$
\frac {b _ {k + 1} ^ {(N)}}{(k + 1) !} (2 N) ^ {k + 2} - \frac {b _ {k - 1} ^ {(N)}}{(k - 1) !} (2 N) ^ {k} = 2 N \frac {b _ {k + 1} ^ {(N)}}{(k + 1) !} (2 N) ^ {k + 1},
$$

and thus, finally, 

$$
b _ {k + 1} ^ {(N)} = b _ {k} ^ {(N)} + b _ {k - 1} ^ {(N)} \frac {(k + 1) k}{(2 N) ^ {2}}.
$$

# 10 Statistics of the Longest Increasing Subsequence

# 10.1 Complete order is impossible

Definition 10.1. A permutation $\sigma \in S _ { n }$ is said to have an increasing subsequence of length $k$ if there exist indices $1 \leq i _ { 1 } < \cdots < i _ { k } \leq n$ such that $\sigma ( i _ { 1 } ) < \cdots < \sigma ( i _ { k } )$ . For a decreasing subsequence of length $k$ the above holds with the second set of inequalities reversed. For a given $\sigma \in S _ { n }$ we denote the length of an increasing subsequence of maximal length by $L _ { n } ( \sigma )$ . 

Example 10.2. (1) Maximal length is achieved for the identity permutation 

$$
\sigma = \mathrm {i d} = \left( \begin{array}{c c c c c} 1 & 2 & \dots & n - 1 & n \\ 1 & 2 & \dots & n - 1 & n \end{array} \right);
$$

this has an increasing subsequence of length $n$ , hence $L _ { n } ( \operatorname { i d } ) = n$ . In this case, all decreasing subsequences have length 1. 

(2) Minimal length is achieved for the permutation 

$$
\sigma = \left( \begin{array}{c c c c c} 1 & 2 & \dots & n - 1 & n \\ n & n - 1 & \dots & 2 & 1 \end{array} \right);
$$

in this case all increasing subsequences have length 1, hence $L _ { n } ( \sigma ) = 1$ ; but there is a decreasing subsequence of length $n$ . 

(3) Consider a more “typical” permutation 

$$
\sigma = \left( \begin{array}{c c c c c c c} 1 & 2 & 3 & 4 & 5 & 6 & 7 \\ 4 & 2 & 3 & 1 & 6 & 5 & 7 \end{array} \right);
$$

this has $( 2 , 3 , 5 , 7 )$ and $( 2 , 3 , 6 , 7 )$ as longest increasing subsequences, thus $L _ { 7 } ( \sigma ) = 4$ . Its longest decreasing subsequences are $( 4 , 2 , 1 )$ and $( 4 , 3 , 1 )$ with 

length 3. In the graphical representation 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/9d6fa017b0cd96715e9774bb1459c7de9fd378ebe441ac49fe257ae88392f01e.jpg)


an increasing subsequence corresponds to a path that always goes up. 

Remark 10.3. (1) Longest increasing subsequences are relevant for sorting algorithms. Consider a library of $n$ books, labeled bijectively with numbers $1 , \ldots , n$ , arranged somehow on a single long bookshelf. The configuration of the books corresponds to a permutation $\sigma \in S _ { n }$ . How many operations does one need to sort the books in a canonical ascending order $1 , 2 , \ldots , n$ ? It turns out that the minimum number is $n - L _ { n } ( \sigma )$ . One can sort around an increasing subsequence. 

Example. Around the longest increasing subsequence $( 1 , 2 , 6 , 8 )$ we sort 

<table><tr><td></td><td>4</td><td>1</td><td>9</td><td>3</td><td>2</td><td>7</td><td>6</td><td>8</td><td>5</td></tr><tr><td>→</td><td>4</td><td>1</td><td>9</td><td>2</td><td>3</td><td>7</td><td>6</td><td>8</td><td>5</td></tr><tr><td>→</td><td>1</td><td>9</td><td>2</td><td>3</td><td>4</td><td>7</td><td>6</td><td>8</td><td>5</td></tr><tr><td>→</td><td>1</td><td>9</td><td>2</td><td>3</td><td>4</td><td>5</td><td>7</td><td>6</td><td>8</td></tr><tr><td>→</td><td>1</td><td>9</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td></tr><tr><td>→</td><td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>6</td><td>7</td><td>8</td><td>9</td></tr></table>

in $9 - 4 = 5$ operations. 

(2) One has situations with only small increasing subsequences, but then one has long decreasing subsequences. This is true in general; one cannot avoid both long decreasing and long increasing subsequences at the same time. According to the slogan 

“Complete order is impossible.” (Motzkin) 

Theorem 10.4 (Erdős, Szekeres, 1935). Every permutation $\sigma \in S _ { n ^ { 2 } + 1 }$ has a monotone subsequence of length more than $n$ . 

Proof. Write $\sigma = a _ { 1 } a _ { 2 } \cdot \cdot \cdot a _ { n ^ { 2 } + 1 }$ . Assign labels $( x _ { k } , y _ { k } )$ , where $x _ { k }$ is the length of a longest increasing subsequence ending at $a _ { k }$ ; and $y _ { k }$ is the length of a longest decreasing subsequence ending at $a _ { k }$ . Assume now that there is no monotone subsequence of length $n { + 1 }$ . Hence we have for all $k$ : $1 \leq x _ { k } , y _ { k } \leq n$ ; i.e., there are only $n ^ { 2 }$ possible labels. By the pigeonhole principle there are $i < j$ with $( x _ { i } , y _ { i } ) = ( x _ { j } , y _ { j } )$ . If $a _ { i } < a _ { j }$ we can append $a _ { j }$ to a longest increasing subsequence ending at $a _ { i }$ , but then $x _ { j } > x _ { i }$ . If $a _ { i } > a _ { j }$ we can append $a _ { j }$ to a longest decreasing subsequence ending at $a _ { i }$ , but then $y _ { j } > y _ { i }$ . In both cases we have a contradiction. □ 

# 10.2 Tracy–Widom for the asymptotic distribution of $L _ { n }$

We are now interested in the distribution of $L _ { n } ( \sigma )$ for $n  \infty$ . This means, we put the uniform distribution on permutations, i.e., $\mathbb { P } \left[ \sigma \right] = 1 / n !$ ! for all $\sigma \in S _ { n }$ , and consider $L _ { n } \colon S _ { n } \to \mathbb { R }$ as a random variable. What is the asymptotic distribution of $L _ { n }$ ? This question is called Ulan’s problem and was raised in the 1960’s. In 1972, Hammersley showed that the limit 

$$
\Lambda = \lim  _ {n \rightarrow \infty} \frac {\mathbb {E} \left[ L _ {n} \right]}{\sqrt {n}}
$$

exists and that $L _ { n } / { \sqrt { n } }$ converges to $\Lambda$ in probability. In 1977, Vershik–Kerov and Logan–Shepp showed independently that $\Lambda = 2$ . Then in 1998, Baik, Deift and Johansson proved the asymptotic behaviour of the fluctuations of $L _ { n }$ ; quite surprisingly, this is also captured by the Tracy–Widom distribution: 

$$
\lim _ {n \to \infty} \mathbb {P} \left[ \frac {L _ {n} - 2 \sqrt {n}}{n ^ {1 / 6}} \leq t \right] = F _ {2} (t).
$$

# 10.3 Very rough sketch of the proof of the Baik, Deift, Johansson theorem

Again, we have no chance of giving a rigorous proof of the BDJ theorem. Let us give at least a possible route for a proof, which gives also an idea why the statistics of 

the length of the longest subsequence could be related to the statistics of the largest eigenvalue. 

(1) The RSK correspondence relates permutations to Young diagrams. $L _ { n }$ goes under this mapping to the length of the first row of the diagram. 

(2) These Young diagrams correspond to non-intersecting paths. 

(3) Via Gessel–Viennot the relevant quantities in terms of NC paths have a determinantal form. 

(4) Then one has to show that the involved kernel, suitably rescaled, converges to the Airy kernel. 

In the following we want to give some idea of the first two items in the above list; the main (and very hard part of the proof) is to show the convergence to the Airy kernel. 

# 10.3.1 RSK correspondence

RSK stands for Robinson–Schensted–Knuth after papers from 1938, 1961 and 1973. It gives a bijection 

$$
S_{n}\longleftrightarrow \bigcup_{\substack{\lambda \\ \text{Young diagram}\\ \text{of size $n$}}}\left(\operatorname {Tab}\lambda \times \operatorname {Tab}\lambda\right),
$$

where $\operatorname { T a b } \lambda$ is the set of Young tableaux of shape $\lambda$ . 

Definition 10.5. (1) Let $n \geq 1$ . A partition of $n$ is a sequence of natural numbers $\lambda = ( \lambda _ { 1 } , \ldots , \lambda _ { r } )$ such that 

$$
\lambda_ {1} \geq \lambda_ {2} \geq \dots \geq \lambda_ {r} \quad \text {a n d} \quad \sum_ {i = 1} ^ {r} \lambda_ {i} = n.
$$

We denote this by $\lambda \vdash n$ . Graphically, a partition $\lambda \vdash n$ is represented by a Young diagram with $n$ boxes. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/451dc66222288b74bb020ef81b630823887563a90e4f5bf8b6decbabaa8d572f.jpg)


(2) A Young tableau of shape $\lambda$ is the Young diagram $\lambda$ filled with numbers $1 , \ldots , n$ such that in any row the numbers are increasing from left to right and in any column the numbers are increasing from top to bottom. We denote the set of all Young tableaux of shape $\lambda$ by $\operatorname { T a b } \lambda$ . 

Example 10.6. (1) For $n \ = \ 1$ there is only one Young diagram, , and one corresponding Young tableau: 1 . 

For $n = 2$ , there are two Young diagrams, 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/e6e773548c0ef5993f0e35e0e17f15ea611f28fad07bf372cbfe39998d4d7fe2.jpg)


each of them having one corresponding Young tableau 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/7fda606ec129c6c5eedde7142ea4ed6d06eafd7d2320053f18d8bee14167bcea.jpg)


For $n = 3$ , there are three Young diagrams 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/55c5faec5c0036a8769f9f100bb76500e65a661564cf9790c576e8aa899b5915.jpg)


the first and the third have only one tableau, but the middle one has two: 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/d4dec6522eb8d20bc2651f9645cbcc69c977eb72160b2f424f80c6c60f929db9.jpg)


(2) Note that a tableau of shape $\lambda$ corresponds to a walk from $\emptyset$ to $\lambda$ by adding one box in each step and only visiting Young diagrams. For example, the Young tableau 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/997d7ca95182527f071bf6df8fb86e6e227175f9fd4e5a4e7dbf0868fe5b72b0.jpg)


corresponds to the walk 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/86222a4acbcef69a16aff664a31911436eb953c93b286c5541e379f15ec5956d.jpg)


Remark 10.7. Those objects are extremely important since they parametrize the irreducible representations of $S _ { n }$ : 

λ ` n ←→ irreducible representation $\pi _ { \lambda }$ of $S _ { n }$ 

Furthermore, the dimension of such a representation $\pi _ { \lambda }$ is given by the number of tableaux of shape $\lambda$ . If one recalls that for any finite group one has the general statement that the sum of the squares of the dimensions over all irreducible representations of the group gives the number of elements in the group, then one has for the symmetric group the statement that 

$$
\sum_ {\lambda \vdash n} (\# T a b \lambda) ^ {2} = \# S _ {n} = n!.
$$

This shows that there is a bijection between elements in $S _ { n }$ and pairs of tableaux of the same shape $\lambda \vdash n$ . The RSK correspondence is such a concrete bijection, given by an explicit algorithm. It has the property, that $L _ { n }$ goes under this bijection over to the length of the first row of the corresponding Young diagram $\lambda$ . 

Example 10.8. For example, under the RSK correspondence, the permutation 

$$
\sigma = \left( \begin{array}{c c c c c c c} 1 & 2 & 3 & 4 & 5 & 6 & 7 \\ 4 & 2 & 3 & 6 & 5 & 1 & 7 \end{array} \right)
$$

corresponds to the pair of Young tableaux 

<table><tr><td>1</td><td>3</td><td>5</td><td>7</td></tr><tr><td>2</td><td>6</td><td></td><td></td></tr><tr><td>4</td><td></td><td></td><td></td></tr></table>

Note that $L _ { 7 } ( \sigma ) = 4$ is the length of the first row. 

# 10.3.2 Relation to non-intersecting paths

Pairs $( Q , P ) \in \mathrm { { T a b } } \lambda \times \mathrm { { T a b } } \lambda$ can be identified with $r = \# \mathrm { r o w s } ( \lambda )$ paths. $Q$ gives the positions of where to go up and $P$ of where to go down; the conditions on the Young tableau guarantee that the paths will be non-intersecting. For example, the pair corresponding to the $\sigma$ from Example 10.8 above gives the following nonintersecting paths: 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/c4646665cc9e2c195fc849e61fc37f697ec69177a1c9fb54a63d7b73174b51e7.jpg)


# 11 The Circular Law

# 11.1 Circular law for Ginibre ensemble

The non-selfadjoint analogue of gue is given by the Ginibre ensemble, where all entries are independent and complex Gaussians. A standard complex Gaussian is of the form 

$$
z = \frac {x + i y}{\sqrt {2}},
$$

where $x$ and $y$ are independent standard real Gaussians, i.e., with joint distribution 

$$
p (x, y) \mathrm {d} x \mathrm {d} y = \frac {1}{2 \pi} e ^ {- \frac {x ^ {2}}{2}} e ^ {- \frac {y ^ {2}}{2}} \mathrm {d} x \mathrm {d} y.
$$

If we rewrite this in terms of a density with respect to the Lebesgue measure for real and imaginary part 

$$
z = \frac {x + i y}{\sqrt {2}} = t _ {1} + i t _ {2}, \qquad \overline {{z}} = \frac {x - i y}{\sqrt {2}} = t _ {1} - i t _ {2},
$$

we get 

$$
p (t _ {1}, t _ {2}) \mathrm {d} t _ {1} \mathrm {d} t _ {2} = \frac {1}{\pi} e ^ {- (t _ {1} ^ {2} + t _ {2} ^ {2})} \mathrm {d} t _ {1} \mathrm {d} t _ {2} = \frac {1}{\pi} e ^ {- | z | ^ {2}} \mathrm {d} ^ {2} z,
$$

where $\mathrm { d } ^ { 2 } z = \mathrm { d } t _ { 1 } \mathrm { d } t _ { 2 }$ . 

Definition 11.1. A (complex) unnormalized Ginibre ensemble AN = (aij )Ni,j=1 $A _ { N } = ( a _ { i j } ) _ { i , j = 1 } ^ { N }$ N is given by complex-valued entries with joint distribution 

$$
\frac {1}{\pi^ {N ^ {2}}} \exp \left(- \sum_ {i, j = 1} ^ {N} | a _ {i j} | ^ {2}\right) \mathrm {d} A = \frac {1}{\pi^ {N ^ {2}}} \exp \left(- \operatorname {T r} (A A ^ {*})\right) \mathrm {d} A, \qquad \mathrm {w h e r e} \mathrm {d} A = \prod_ {i, j = 1} ^ {N} \mathrm {d} ^ {2} a _ {i j}.
$$

As for the gue case, Theorem 7.6, we can rewrite the density in terms of eigenvalues. Note that the eigenvalues are now complex. 

Theorem 11.2. The joint distribution of the complex eigenvalues of an $N \times N$ Ginibre ensemble is given by a density 

$$
p (z _ {1}, \ldots , z _ {N}) = c _ {N} \exp \left(- \sum_ {k = 1} ^ {N} | z _ {k} | ^ {2}\right) \prod_ {1 \leq i <   j \leq N} | z _ {i} - z _ {j} | ^ {2}.
$$

Remark 11.3. (1) Note that typically Ginibre matrices are not normal, i.e., $A A ^ { * } \neq$ $A ^ { * } A$ . This means that one loses the relation between functions in eigenvalues and traces of functions in the matrix. The latter is what we can control, the former is what we want to understand. 

(2) As in the selfadjoint case the eigenvalues repel, hence there will almost surely be no multiple eigenvalues. Thus we can also in the Ginibre case diagonalize our matrix, i.e., $A = V D V ^ { - 1 }$ , where $D = \mathrm { d i a g } ( z _ { 1 } , \dots , z _ { N } )$ contains the eigenvalues. However, $V$ is now not unitary anymore, i.e., eigenvectors for different eigenvalues are in general not orthogonal. We can also diagonalize $A ^ { * }$ via $A ^ { * } =$ $( V ^ { - 1 } ) ^ { * } D ^ { * } V ^ { * }$ , but since $V ^ { - 1 } \neq V ^ { * }$ (if $A$ is not normal) we cannot diagonalize $A$ and has $A ^ { * }$ simultaneously. clear relation to that in gene. (Note that $\operatorname { T r } ( A A ^ { * } A ^ { * } A )$ $\textstyle \sum _ { i = 1 } ^ { N } z _ { i } { \bar { z _ { i } } } { \bar { z _ { i } } } z _ { i }$ $\operatorname { T r } ( A A ^ { * } A ^ { * } A ) \neq \operatorname { T r } ( A A ^ { * } A A ^ { * } )$ if $A A ^ { * } \neq A ^ { * } A$ , but of course $\begin{array} { r } { \sum _ { i = 1 } ^ { N } z _ { i } \bar { z _ { i } } \bar { z _ { i } } z _ { i } z _ { i } = \sum _ { i = 1 } ^ { N } z _ { i } \bar { z _ { i } } z _ { 1 } \bar { z _ { i } } } \end{array}$ .) 

(3) In Theorem 11.2 it seems that we have rewritten the density $\exp ( - \operatorname { T r } ( A A ^ { * } ) )$ as $\begin{array} { r } { \exp ( - \sum _ { k = 1 } ^ { N } | z _ { k } | ^ { 2 } ) } \end{array}$ . However, this is more subtle. On can bring any matrix via a unitary conjugation in a triangular form: $A = U T U ^ { * }$ , where $U$ is unitary and 

$$
T = \left( \begin{array}{c c c c} z _ {1} & \star & \dots & \star \\ 0 & \ddots & \ddots & \vdots \\ \vdots & \ddots & \ddots & \star \\ 0 & \dots & 0 & z _ {n} \end{array} \right)
$$

contains on the diagonal the eigenvalues $z _ { 1 } , \ldots , z _ { n }$ of $A$ (this is usually called Schur decomposition). Then $A ^ { * } = U T ^ { * } U ^ { * }$ with 

$$
T ^ {*} = \left( \begin{array}{c c c c} \bar {z _ {1}} & 0 & \dots & 0 \\ \star & \ddots & \ddots & \vdots \\ \vdots & \ddots & \ddots & 0 \\ \star & \dots & \star & \bar {z _ {n}} \end{array} \right)
$$

and 

$$
\mathrm {T r} (A A ^ {*}) = \mathrm {T r} (T T ^ {*}) = \sum_ {k = 1} ^ {N} \left| z _ {k} \right| ^ {2} + \sum_ {j > i} t _ {i j} \bar {t} _ {i j}.
$$

Integrating out the $t _ { i j }$ ${ j > i } )$ gives then the density for the $z _ { i }$ 

(4) As for the gue case (Theorem 7.15) we can write the Vandermonde density in a determinantal form. The only difference is that we have to replace the Hermite polynomials $H _ { k } ( x )$ , which orthogonalize the real Gaussian distribution, by monomials $z ^ { k }$ , which orthogonalize the complex Gaussian distribution. 

Theorem 11.4. The joint eigenvalue distribution of the Ginibre ensemble is of the determinantal form $\begin{array} { r } { p ( z _ { 1 } , \ldots , z _ { n } ) = \frac { 1 } { N ! } \operatorname* { d e t } ( K _ { N } ( z _ { i } , z _ { j } ) ) _ { i , j = 1 } ^ { N } } \end{array}$ with the kernel 

$$
K _ {N} (z, w) = \sum_ {k = 0} ^ {N - 1} \varphi_ {k} (z) \bar {\varphi} _ {k} (w), \qquad w h e r e \qquad \varphi_ {k} (z) = \frac {1}{\sqrt {\pi}} e ^ {- \frac {1}{2} | z | ^ {2}} \frac {1}{\sqrt {k !}} z ^ {k}.
$$

In particular, for the averaged eigenvalue density of an unnormalized Ginibre eigenvalue matrix we have the density 

$$
p _ {N} (z) = \frac {1}{N} K _ {N} (z, z) = \frac {1}{N \pi} e ^ {- | z | ^ {2}} \sum_ {k = 0} ^ {N - 1} \frac {| z | ^ {2 k}}{k !}.
$$

Theorem 11.5 (Circular law for the Ginibre ensemble). The averaged eigenvalue distribution for a normalized Ginibre random matrix $\scriptstyle { \frac { 1 } { \sqrt { N } } } A _ { N }$ converges for $N  \infty$ weakly to the uniform distribution on the unit disc of $\mathbb { C }$ with density $^ { \underline { { 1 } } } _ { } 1 _ { \{ z \in \mathbb { C } | | z | \leq 1 \} }$ . 

Proof. The density $q _ { N }$ of the normalized Ginibre is given by 

$$
q _ {N} (z) = N \cdot p _ {N} (\sqrt {N} z) = \frac {1}{\pi} e ^ {- N | z | ^ {2}} \sum_ {k = 0} ^ {N - 1} \frac {(N | z | ^ {2}) ^ {k}}{k !}.
$$

We have to show that this converges to the circular density. For $| z | < 1$ we have 

$$
\begin{array}{l} e ^ {N | z | ^ {2}} - \sum_ {k = 0} ^ {N - 1} \frac {\left(N | z | ^ {2}\right) ^ {k}}{k !} = \sum_ {k = N} ^ {\infty} \frac {\left(N | z | ^ {2}\right) ^ {k}}{k !} \\ \leq \frac {(N | z | ^ {2}) ^ {N}}{N !} \sum_ {l = 0} ^ {\infty} \frac {(N | z | ^ {2}) ^ {l}}{(N + 1) ^ {l}} \\ \leq \frac {(N | z | ^ {2}) ^ {N}}{N !} \frac {1}{1 - \frac {N | z | ^ {2}}{N + 1}}, \\ \end{array}
$$

Furthermore, using the lower bound $N ! \geq \sqrt { 2 \pi } N ^ { N + \frac { 1 } { 2 } } e ^ { - N }$ for $N !$ , we calculate 

$$
\begin{array}{l} e ^ {- N | z | ^ {2}} \frac {(N | z | ^ {2}) ^ {N}}{N !} \leq e ^ {- N | z | ^ {2}} N ^ {N} | z | ^ {2 N} \frac {1}{\sqrt {2 \pi}} \frac {1}{N ^ {N + \frac {1}{2}}} e ^ {N} \\ = \frac {1}{\sqrt {2 \pi}} \frac {1}{\sqrt {N}} e ^ {- N | z | ^ {2}} e ^ {N \ln | z | ^ {2}} e ^ {N} \\ = \frac {1}{\sqrt {2 \pi}} \frac {\exp [ N (- | z | ^ {2} + \ln | z | ^ {2} + 1) ]}{\sqrt {N}} \stackrel {N \to \infty} {\longrightarrow} 0. \\ \end{array}
$$

Here, we used that $- \left| z \right| ^ { 2 } + \ln \left| z \right| ^ { 2 } + 1 < 0$ for $| z | < 1$ . Hence we conclude 

$$
1 - e ^ {- N | z | ^ {2}} \sum_ {k = 0} ^ {N - 1} \frac {(N | z | ^ {2}) ^ {k}}{k !} \leq e ^ {- N | z | ^ {2}} \frac {(N | z | ^ {2}) ^ {N}}{N !} \frac {1}{1 - \frac {N | z | ^ {2}}{N + 1}} \stackrel {N \rightarrow \infty} {\longrightarrow} 0.
$$

Similarly, for $| z | > 1$ , 

$$
\sum_ {k = 0} ^ {N - 1} \frac {(N | z | ^ {2}) ^ {k}}{k !} \leq \frac {(N | z | ^ {2}) ^ {N - 1}}{(N - 1) !} \sum_ {l = 0} ^ {N - 1} \frac {(N - 1) ^ {l}}{(N | z | ^ {2}) ^ {l}} \leq \frac {(N | z |) ^ {N - 1}}{(N - 1) !} \frac {1}{1 - \frac {N - 1}{N | z | ^ {2}}},
$$

which shows that 

$$
E ^ {- N | z | ^ {2}} \sum_ {k = 0} ^ {N - 1} \frac {(N | z | ^ {2}) ^ {k}}{k !} \stackrel {N \rightarrow \infty} {\longrightarrow} 0.
$$

Remark 11.6. (1) The convergence also holds almost surely. Here is a plot of the 3000 eigenvalues of one realization of a $\mathrm { 3 0 0 0 \times 3 0 0 0 }$ Ginibre matrix. 

![image](https://cdn-mineru.openxlab.org.cn/result/2026-05-03/382b4fe0-0fac-4310-ab6b-49edc664842f/70bc0d76a684961ac73f52aab4a5d10b51e5156370c286e5ecc8e1bfb382fefe.jpg)


(2) The circular law also holds for non-Gaussian entries, but proving this is much harder than the extension for the semicircle law from the Gaussian case to Wigner matrices. 

# 11.2 General circular law

Theorem 11.7 (General circular law). Consider a complex random matrix $A _ { N } =$ $\textstyle \frac { 1 } { \sqrt { N } } \left( a _ { i j } \right) _ { i , j = 1 } ^ { N }$ , where the $a _ { i j }$ are independent and identically distributed complex random variables with variance 1, i.e., $\mathbb { E } [ | a _ { i j } | ^ { 2 } ] - \mathbb { E } \left[ a _ { i j } \right] ^ { 2 } = 1$ . Then the eigenvalue distribution of $A _ { N }$ converges weakly almost surely for $N  \infty$ to the uniform distribution on the unit disc. 

Note that only the existence of the second moment is required, higher moments don’t need to be finite. 

Remark 11.8. (1) It took quite a while to prove this in full generality. Here is a bit about the history of the proof. 

• 60’s, Mehta proved it (see his book) in expectation for Ginibre ensemble; 

• 80’s, Silverstein proved almost sure convergence for Ginibre; 

• 80’s, 90’s, Girko outlined the main ideas for a proof in the general case; 

• 1997, Bai gave the first rigorous proof, under additional assumptions on the distribution 

• papers by Tao–Vu, Götze–Tikhomirov, Pan–Zhou and others, weakening more and more the assumptions; 

• 2010, Tao–Vu gave final version under the assumption of the existence of the second moment. 

(2) For measures on $\mathbb { C }$ one can use $^ *$ -moments or the Stieltjes transform to describe them, but controlling the convergence properties is the main problem. 

(3) For a matrix $A$ its $^ *$ -moments are all expressions of the form $\operatorname { t r } \bigl ( A ^ { \varepsilon ( 1 ) } \cdot \cdot \cdot A ^ { \varepsilon ( m ) } \bigr )$ , where $m \in \mathbb { N }$ and $\varepsilon ( 1 ) , \ldots , \varepsilon ( m ) \in \{ 1 , * \}$ . The eigenvalue distribution 

$$
\mu_ {A} = \frac {1}{N} \left(\delta_ {z _ {1}} + \dots + \delta_ {z _ {N}}\right) \qquad (z _ {1}, \ldots , z _ {n} \mathrm {a r e c o m p l e x e i g e n v a l u e s o f} A)
$$

of $A$ is uniquely determined by the knowledge of all $^ *$ -moments of $A$ , but convergence of $^ *$ -moments does not necessarily imply convergence of the eigenvalue distribution. 

Example. Consider 

$$
A _ {N} = \left( \begin{array}{c c c c c} 0 & 1 & 0 & \dots & 0 \\ \vdots & \ddots & \ddots & \ddots & \vdots \\ \vdots & & \ddots & \ddots & 0 \\ \vdots & & & \ddots & 1 \\ 0 & \dots & \dots & \dots & 0 \end{array} \right) \qquad \text {a n d} \qquad B _ {N} = \left( \begin{array}{c c c c c} 0 & 1 & 0 & \dots & 0 \\ \vdots & \ddots & \ddots & \ddots & \vdots \\ \vdots & & \ddots & \ddots & 0 \\ 0 & & & \ddots & 1 \\ 1 & 0 & \dots & \dots & 0 \end{array} \right).
$$

Then $\mu _ { A _ { N } } = \delta _ { 0 }$ , but is the uniform distribution on the $N$ -th roots of $\mu _ { B _ { N } }$ unity. Hence $\mu _ { A _ { N } }  \delta _ { 0 }$ , whereas $\mu _ { B _ { N } }$ converges to the uniform distribution on the unit circle. However, the limits of the $^ *$ -moments are the same for $A _ { N }$ and $B _ { N }$ . 

(4) For each measure $\mu$ on $\mathbb { C }$ one has the Stieltjes transform 

$$
S _ {\mu} (w) = \int_ {\mathbb {C}} \frac {1}{z - w} \mathrm {d} \mu (z).
$$

This is almost surely defined. However, it is analytic in $w$ only outside the support of $\mu$ . In order to recover $\mu$ from $S _ { \mu }$ one also needs the information about $S _ { \mu }$ inside the support. In order to determine and deal with $\mu _ { A }$ one reduces it via Girko’s “hermitization method” 

$$
\int_ {\mathbb {C}} \log | \lambda - z | \mathrm {d} \mu_ {A} (z) = \int_ {0} ^ {t} \log t \mathrm {d} \mu_ {| A - \lambda 1 |} (t)
$$

to selfadjoint matrices. The left hand side for all $\lambda$ determines $\mu _ { A }$ and the right hand side is about selfadjoint matrices 

$$
\left| A - \lambda 1 \right| = \sqrt {\left(A - \lambda 1\right) \left(A - \lambda 1\right) ^ {*}}.
$$

Note that the eigenvalues of $| B |$ are related to those of 

$$
\left( \begin{array}{c c} 0 & B \\ B ^ {*} & 0 \end{array} \right).
$$

In this analytic approach one still needs to control convergence properties. For this, estimates of probabilities of small singular values are crucial. 

For more details on this one should have a look at the survey of Bordenave– Chafai, Around the circular law. 

# 12 Several Independent GUEs and Asymptotic Freeness

Up to now, we have only considered limits $N \to \infty$ of one random matrix $A _ { N }$ . But often one has several matrix ensembles and would like to understand the “joint” distribution; e.g., in order to use them as building blocks for more complicated random matrix models. 

# 12.1 The problem of non-commutativity

Remark 12.1. (1) Consider two random matrices $A _ { 1 } ^ { ( N ) }$ ) and A(N )2 $A _ { 2 } ^ { ( N ) }$ such that their entries are defined on the same probability space. What is now the “joint” information about the two matrices which survies in the limit $N \to \infty$ ? Note that in general our analytical approach breaks down if $A _ { 1 }$ and $A _ { 2 }$ do not commute, since then we cannot diagonalize them simultaneously. Hence it makes no sense to talk about a joint eigenvalue distribution of $A _ { 1 }$ and $A _ { 2 }$ . The notion $\mu _ { A _ { 1 } , A _ { 2 } }$ has no clear analytic meaning. 

What still makes sense in the multivariate case is the combinatorial approach via “mixed” moments with respect to the normalized trace tr. Hence we consider the collection of all mixed moments $\mathrm { t r } ( A _ { i _ { 1 } } ^ { ( N ) } \cdot \cdot \cdot A _ { i _ { m } } ^ { ( N ) } )$ in $A _ { 1 }$ and $A _ { 2 }$ , with $m \in \mathbb { N }$ , $i _ { 1 } , \ldots , i _ { m } \in \{ 1 , 2 \}$ , as the joint distribution of $A _ { 1 }$ and $A _ { 2 }$ and denote this by $\mu _ { A _ { 1 } , A _ { 2 } }$ . We want to understand, in interesting cases, the behavior of $\mu _ { A _ { 1 } , A _ { 2 } }$ as $N  \infty$ . 

(2) In the case of one selfadjoint matrix $A$ , the notion $\mu _ { A }$ has two meanings: analytic as $\begin{array} { r } { \mu _ { A } = \frac { 1 } { N } \left( \delta _ { \lambda _ { 1 } } + \cdot \cdot \cdot + \delta _ { \lambda _ { N } } \right) } \end{array}$ , which is a probability measure on $\mathbb { R }$ ; combinatorial, where $\mu _ { A }$ is given by all moments $\operatorname { t r } [ A ^ { k } ]$ for all $k \geq 1$ . 

These two points of view are the same (at least when we restrict to cases where the proabability measure $\mu$ is determined by its moments) via 

$$
\operatorname {t r} (A ^ {k}) = \int t ^ {k} \mathrm {d} \mu_ {A} (t).
$$

In the case of two matrices $A _ { 1 }$ , $A _ { 2 }$ the notion $\mu _ { A _ { 1 } , A _ { 2 } }$ has only one meaning, 

namely the collection of all mixed moments $\operatorname { t r } [ A _ { i _ { 1 } } \dots A _ { i _ { m } } ]$ with $m \in \mathbb { N }$ and $i _ { 1 } , \ldots , i _ { m } \in \{ 1 , 2 \}$ . If $A _ { 1 }$ and $A _ { 2 }$ do not commute then there exists no probability measure $\mu$ on $\mathbb { R } ^ { 2 }$ such that 

$$
\operatorname {t r} \left[ A _ {i _ {1}} \dots A _ {i _ {m}} \right] = \int t _ {i _ {1}} \dots t _ {i _ {m}} \mathrm {d} \mu \left(t _ {1}, t _ {2}\right)
$$

for all $m \in \mathbb { N }$ and $i _ { 1 } , \ldots , i _ { m } \in \{ 1 , 2 \}$ . 

# 12.2 Joint moments of independent GUEs

We will now consider the simplest case of several random matrices, namely $r$ gues $A _ { 1 } ^ { ( N ) } , \dots , A _ { r } ^ { ( N ) }$ , which we assume to be independent of each other, i.e., we have A ( N )i $\begin{array} { r } { A _ { i } ^ { ( N ) } = \frac { 1 } { \sqrt { N } } ( a _ { k l } ^ { ( i ) } ) _ { k , l = 1 } ^ { N } } \end{array}$ √1N (akl )k,l=1, where i = 1, . . . , r, each A(N )i is a gue(n) and (i) N $i = 1 , \dots , r$ $A _ { i } ^ { ( N ) }$ 

$$
\left\{a _ {k l} ^ {(1)}; k, l = 1, \dots , N \right\}, \dots , \left\{a _ {k l} ^ {(r)}; k, l = 1, \dots , N \right\}
$$

are independent sets of Gaussian random variables. Equivalently, this can be characterized by the requirement that all entries of all matrices together form a collection of independent standard Gaussian variables (real on the diagonal, complex otherwise). Hence we can express this again in terms of the Wick formula 2.8 as 

$$
\mathbb {E} \left[ a _ {k _ {1} l _ {1}} ^ {(i _ {1})} \dots a _ {k _ {m} l _ {m}} ^ {(i _ {m})} \right] = \sum_ {\pi \in \mathcal {P} _ {2} (m)} \mathbb {E} _ {\pi} \left[ a _ {k _ {1} l _ {1}} ^ {(i _ {1})}, \ldots , a _ {k _ {m} l _ {m}} ^ {(i _ {m})} \right]
$$

for all $m \in \mathbb { N }$ , $1 \leq k _ { 1 } , l _ { 1 } , \ldots , k _ { m } , l _ { m } \leq N$ and $1 \leq i _ { 1 } , . . . , i _ { m } \leq r$ and where the second moments are given by 

$$
\mathbb {E} \left[ a _ {p q} ^ {(i)} a _ {k l} ^ {(j)} \right] = \delta_ {p l} \delta_ {q k} \delta_ {i j}.
$$

Now we can essentially repeat the calculations from Remark 2.14 for our mixed moments: 

$$
\begin{array}{l} \mathbb {E} \left[ \operatorname {t r} \left(A _ {i _ {1}} \dots A _ {i _ {m}}\right) \right] = \frac {1}{N ^ {1 + \frac {m}{2}}} \sum_ {k _ {1}, \dots , k _ {m} = 1} ^ {N} \mathbb {E} \left[ a _ {k _ {1} k _ {2}} ^ {(i _ {1})} a _ {k _ {2} k _ {3}} ^ {(i _ {2})} \dots a _ {k _ {m} k _ {1}} ^ {(i _ {m})} \right] \\ = \frac {1}{N ^ {1 + \frac {m}{2}}} \sum_ {k _ {1}, \dots , k _ {m} = 1} ^ {N} \sum_ {\pi \in \mathcal {P} _ {2} (m)} \mathbb {E} _ {\pi} \left[ a _ {k _ {1} k _ {2}} ^ {(i _ {1})}, a _ {k _ {2} k _ {3}} ^ {(i _ {2})}, \dots , a _ {k _ {m} k _ {1}} ^ {(i _ {m})} \right] \\ = \frac {1}{N ^ {1 + \frac {m}{2}}} \sum_ {k _ {1}, \dots , k _ {m} = 1} ^ {N} \sum_ {\pi \in \mathcal {P} _ {2} (m)} \prod_ {(p, q) \in \pi} \mathbb {E} \left[ a _ {k _ {p} k _ {p + 1}} ^ {(i _ {p})} a _ {k _ {q} k _ {q + 1}} ^ {(i _ {q})} \right] \\ \end{array}
$$

$$
\begin{array}{l} = \frac {1}{N ^ {1 + \frac {m}{2}}} \sum_ {k _ {1}, \dots , k _ {m} = 1} ^ {N} \sum_ {\pi \in \mathcal {P} _ {2} (m)} \prod_ {(p, q) \in \pi} [ k _ {p} = k _ {q + 1} ] [ k _ {q} = k _ {p + 1} ] [ i _ {p} = i _ {q} ] \\ = \frac{1}{N^{1 + \frac{m}{2}}}\sum_{\substack{\pi \in \mathcal{P}_{2}(m)\\ (p,q)\in \pi \\ i_{p} = i_{q}}}\sum_{k_{1},\ldots ,k_{m} = 1}^{N}\prod_{p}\left[k_{p} = k_{\gamma \pi (p)}\right] \\ = \frac{1}{N^{1 + \frac{m}{2}}}\sum_{\substack{\pi \in \mathcal{P}_{2}(m)\\ (p,q)\in \pi \\ i_{p} = i_{q}}}N^{\# (\gamma \pi)}, \\ \end{array}
$$

where $\gamma = ( 1 2 \ldots m ) \in S _ { m }$ is the shift by 1 modulo $m$ . Hence we get the same kind of genus expansion for several gues as for one gue. The only difference is, that in our pairings we only allow to connect the same matrices. 

Notation 12.2. For a given $i = ( i _ { 1 } , \dots , i _ { m } )$ with $1 \leq i _ { 1 } , \ldots , i _ { m } \leq r$ we say that $\pi \in \mathcal { P } _ { 2 } ( m )$ respects $i$ if we have $i _ { p } = i _ { q }$ for all $( p , q ) \in \pi$ . We put 

$$
\mathcal {P} _ {2} ^ {[ i ]} (m) := \left\{\pi \in \mathcal {P} _ {2} (m) \mid \pi \text {r e s p e c t s} i \right\}
$$

and also 

$$
\mathcal {N C} _ {2} ^ {[ i ]} (m) := \left\{\pi \in \mathcal {N C} _ {2} (m) \mid \pi \text {r e s p e c t s} i \right\}.
$$

Theorem 12.3 (Genus expansion of independent gues). Let $A _ { 1 } , \ldots , A _ { r }$ be $r$ independent gue(n). Then we have for all $m \in \mathbb { N }$ and all $i _ { 1 } , \ldots , i _ { m } \in [ r ]$ that 

$$
\mathbb {E} \left[ \operatorname {t r} \left(A _ {i _ {1}} \dots A _ {i _ {m}}\right) \right] = \sum_ {\pi \in \mathcal {P} _ {2} ^ {[ i ]} (m)} N ^ {\# (\gamma \pi) - \frac {m}{2} - 1}
$$

and thus 

$$
\lim  _ {N \to \infty} \mathbb {E} \left[ \operatorname {t r} \left(A _ {i _ {1}} \dots A _ {i _ {m}}\right) \right] = \# \mathcal {N C} _ {2} ^ {[ i ]} (m).
$$

Proof. The genus expansion follows from our computation above. The limit for $N \to \infty$ follows as for Wigner’s semicircle law 2.21 from the fact that 

$$
\lim  _ {N \to \infty} N ^ {\# (\gamma \pi) - \frac {m}{2} - 1} = \left\{ \begin{array}{l l} 1, & \pi \in \mathcal {N C} _ {2} (m), \\ 0, & \pi \notin \mathcal {N C} _ {2} (m). \end{array} \right.
$$

The index tuple $\left( i _ { 1 } , \ldots , i _ { m } \right)$ has no say in this limit. 

# 12.3 The concept of free independence

Remark 12.4. We would like to find some structure in those limiting moments. We prefer to talk directly about the limit instead of making asymptotic statements. In the case of one gue, we had the semicircle $\mu _ { W }$ as a limiting analytic object. Now we do not have an analytic object in the limit, but we can organize our distribution as the limit of moments in a more algebraic way. 

Definition 12.5. (1) Let $\mathcal { A } = \mathbb { C } \langle s _ { 1 } , \ldots , s _ { r } \rangle$ be the algebra of polynomials in noncommuting variables $s _ { 1 } , \ldots , s _ { r }$ ; this means $\mathcal { A }$ is the free unital algebra generated by $s _ { 1 } , \ldots , s _ { r }$ (i.e., there are no non-trivial relations between $s _ { 1 } , \ldots , s _ { r }$ and $A$ is the linear span of the monomials $s _ { i _ { 1 } } \cdots s _ { i _ { m } }$ for $m \geq 0$ and $i _ { 1 } , \ldots , i _ { m } \in [ r ]$ ; multiplication for monomials is given by concatenation). 

(2) On this algebra $\mathcal { A }$ we define a unital linear functional $\varphi \colon A  \mathbb { C }$ by $\varphi ( 1 ) = 1$ and 

$$
\varphi (s _ {i _ {1}} \cdot \cdot \cdot s _ {i _ {m}}) = \lim _ {N \to \infty} \mathbb {E} \left[ \mathrm {t r} (A _ {i _ {1}} \cdot \cdot \cdot A _ {i _ {m}}) \right] = \# \mathcal {N C} _ {2} ^ {[ i ]} (m).
$$

(3) We also address $( { \mathcal { A } } , \varphi )$ as a non-commutative probability space and $s _ { 1 } , \ldots , s _ { r } \in$ $\boldsymbol { A }$ as (non-commutative) random variables. The moments of $s _ { 1 } , \ldots , s _ { r }$ are the $\varphi ( s _ { i _ { 1 } } \cdot \cdot \cdot s _ { i _ { m } } )$ and the collection of those moments is the (joint) distribution of $s _ { 1 } , \ldots , s _ { r }$ . 

Remark 12.6. (1) Note that if we consider only one of the $s _ { i }$ , then its distribution is just the collection of Catalan numbers, hence correspond to the semicircle, which we understand quite well. 

(2) If we consider all $s _ { 1 } , \ldots , s _ { r }$ , then their joint distribution is a large collection of numbers. We claim that the following theorem discovers some important structure in those. 

Theorem 12.7. Let $\mathcal { A } = \mathbb { C } \langle s _ { 1 } , \ldots , s _ { r } \rangle$ and let $\varphi \colon A  \mathbb { C }$ be defined by $\varphi ( s _ { i _ { 1 } } \cdot \cdot \cdot s _ { i _ { m } } ) =$ $\# \mathcal { N C } _ { 2 } ^ { [ i ] } ( m )$ as before. Then for all $m \geq 1$ , $i _ { 1 } , \ldots , i _ { m } \in [ r ]$ with $i _ { 1 } ~ \neq ~ i _ { 2 } , ~ i _ { 2 } ~ \neq$ $i _ { 3 }$ , . . . , $i _ { m - 1 } \neq i _ { m }$ and all polynomials $p _ { 1 } , \ldots , p _ { m }$ in one variable such that $\varphi \left( p _ { k } ( s _ { i _ { k } } ) \right) =$ 0 we have: 

$$
\varphi \left(p _ {1} (s _ {i _ {1}}) p _ {2} (s _ {i _ {2}}) \dots p _ {m} (s _ {i _ {m}})\right) = 0.
$$

In words: the alternating product of centered variables is centered. 

We say that $s _ { 1 } , \ldots , s _ { r }$ are free (or freely independent); in terms of the independent gue random matrices, we say that $A _ { 1 } ^ { ( N ) } , \dots , A _ { r } ^ { ( N ) }$ are asymtotially free. Those notions and the results above are all due to Dan Voiculescu. 

Proof. It suffices to prove the statement for polynomials of the form 

$$
p _ {k} (s _ {i _ {k}}) = s _ {i _ {k}} ^ {p _ {k}} - \varphi (s _ {i _ {k}} ^ {p _ {k}})
$$

for any power $p _ { k }$ , since general polynomials can be written as linear combinations of those. The general statement then follows by linearity. So we have to prove that 

$$
\varphi \left[ \left(s _ {i _ {1}} ^ {p _ {1}} - \varphi \left(s _ {i _ {1}} ^ {p _ {1}}\right)\right) \dots \left(s _ {i _ {m}} ^ {p _ {m}} - \varphi \left(s _ {i _ {m}} ^ {p _ {m}}\right)\right) \right] = 0.
$$

We have 

$$
\varphi \left[ \left(s _ {i _ {1}} ^ {p _ {1}} - \varphi \left(s _ {i _ {1}} ^ {p _ {1}}\right)\right) \dots \left(s _ {i _ {m}} ^ {p _ {m}} - \varphi \left(s _ {i _ {m}} ^ {p _ {m}}\right)\right) \right] = \sum_ {M \subset [ m ]} (- 1) ^ {| M |} \prod_ {j \in M} \varphi \left(s _ {i _ {j}} ^ {p _ {j}}\right) \varphi \left(\prod_ {j \not \in M} s _ {i _ {j}} ^ {p _ {j}}\right)
$$

with 

$$
\varphi \left(s _ {i _ {j}} ^ {p _ {j}}\right) = \varphi \left(s _ {i _ {j}} \dots s _ {i _ {j}}\right) = \# \mathcal {N C} _ {2} (p _ {j})
$$

and 

$$
\varphi \left(\prod_ {j \not \in M} s _ {i _ {j}} ^ {p _ {j}}\right) = \# \mathcal {N C} _ {2} ^ {\mathrm {[ r e s p e c t s i n d i c e s ]}} \left(\sum_ {j \not \in M} p _ {j}\right).
$$

Let us put 

$$
I _ {1} = \{1, \dots , p _ {1} \}
$$

$$
I _ {2} = \left\{p _ {1} + 1, \dots , p _ {1} + p _ {2} \right\}
$$

$$
I _ {m} = \left\{p _ {1} + p _ {2} + \dots + p _ {m - 1} + 1, \dots , p _ {1} + p _ {2} + \dots + p _ {m} \right\}
$$

and $I = I _ { 1 } \cup I _ { 2 } \cup \ldots \cup I _ { m }$ . Denote 

$$
[ \dots ] = [ i _ {1}, \dots , i _ {1}, i _ {2}, \dots , i _ {2}, \dots , i _ {m}, \dots , i _ {m} ].
$$

Then 

$$
\prod_ {j \in M} \varphi \left(s _ {i _ {j}} ^ {p _ {j}}\right) \varphi \left(\prod_ {j \notin M} s _ {i _ {j}} ^ {p _ {j}}\right) = \# \{\pi \in \mathcal {N C} _ {2} ^ {[ \dots ]} (I) | \text {f o r a l l} j \in M \text {a l l e l e m e n t s}
$$

$$
\left. \text {i n} I _ {j} \text {a r e o n l y p a i r e d a m o n g s t e a c h o t h e r} \right\}
$$

Let us denote 

$$
\mathcal {N C} _ {2} ^ {[ \dots ]} (I: j) := \left\{\pi \in \mathcal {N C} _ {2} ^ {[ \dots ]} (I) \mid \text {e l e m e n t s i n I _ {j} a r e o n l y p a i r e d a m o n g s t e a c h o t h e r} \right\}.
$$

Then, by the inclusion-exclusion formula, 

$$
\begin{array}{l} \varphi \left[ \left(s _ {i _ {1}} ^ {p _ {1}} - \varphi \left(s _ {i _ {1}} ^ {p _ {1}}\right)\right) \dots \left(s _ {i _ {m}} ^ {p _ {m}} - \varphi \left(s _ {i _ {m}} ^ {p _ {m}}\right)\right) \right] = \sum_ {M \subset [ m ]} (- 1) ^ {| M |} \cdot \# \left(\bigcap_ {j \in M} \mathcal {N C} _ {2} ^ {[ \dots ]} (I: j)\right) \\ = \# \left(\mathcal {N C} _ {2} ^ {[ \dots ]} (I) \backslash \bigcup_ {j} \mathcal {N C} _ {2} ^ {[ \dots ]} (I: j)\right). \\ \end{array}
$$

These are $\pi \in \mathcal { N C } _ { 2 } ^ { \lfloor \cdots \rfloor } ( I )$ such that at least one element of each interval $I _ { j }$ is paired with an element from another interval $I _ { k }$ . Since $i _ { 1 } \neq i _ { 2 } , i _ { 2 } \neq i _ { 3 }$ , . . . , $i _ { m - 1 } \neq i _ { m }$ we cannot connect neighboring intervals and each interval must be connected to another interval in a non-crossing way. But there is no such $\pi$ , hence 

$$
\varphi \left[ \left(s _ {i _ {1}} ^ {p _ {1}} - \varphi \left(s _ {i _ {1}} ^ {p _ {1}}\right)\right) \dots \left(s _ {i _ {m}} ^ {p _ {m}} - \varphi \left(s _ {i _ {m}} ^ {p _ {m}}\right)\right) \right] = \# \left(\mathcal {N C} _ {2} ^ {[ \dots ]} (I) \backslash \bigcup_ {j} \mathcal {N C} _ {2} ^ {[ \dots ]} (I: j)\right) = 0,
$$

as claimed. 

Remark 12.8. (1) Note that in Theorem 12.7 we have traded the explicit description of our moments for implicit relations between the moments. 

(2) For example, the simplest relations from Theorem 12.7 are 

$$
\varphi \left([ s _ {i} ^ {p} - \varphi (s _ {i} ^ {p}) 1 ] [ s _ {j} ^ {q} - \varphi (s _ {j} ^ {q}) 1 ]\right) = 0,
$$

for $i \neq j$ , which can be reformulated to 

$$
\varphi (s _ {i} ^ {p} s _ {j} ^ {q}) - \varphi (s _ {i} ^ {p} 1) \varphi (s _ {j} ^ {q}) - \varphi (s _ {i} ^ {p}) \varphi (s _ {j} ^ {q} 1) + \varphi (s _ {i} ^ {p}) \varphi (s _ {j} ^ {q}) \varphi (1) = 0,
$$

i.e., 

$$
\varphi (s _ {i} ^ {p} s _ {j} ^ {q}) = \varphi (s _ {i} ^ {p}) \varphi (s _ {j} ^ {q}).
$$

Those relations are quickly getting more complicated. For example, 

$$
\varphi \left[ \left(s _ {1} ^ {p _ {1}} - \varphi \left(s _ {1} ^ {p _ {1}}\right) 1\right) \left(s _ {2} ^ {q _ {1}} - \varphi \left(s _ {2} ^ {q _ {1}}\right) 1\right) \left(s _ {1} ^ {p _ {2}} - \varphi \left(s _ {1} ^ {p _ {2}}\right) 1\right) \left(s _ {2} ^ {q _ {2}} - \varphi \left(s _ {2} ^ {q _ {2}}\right) 1\right) \right] = 0
$$

leads to 

$$
\begin{array}{l} \varphi \left(s _ {1} ^ {p _ {1}} s _ {2} ^ {q _ {1}} s _ {1} ^ {p _ {2}} s _ {2} ^ {q _ {2}}\right) = \varphi \left(s _ {1} ^ {p _ {1} + p _ {2}}\right) \varphi \left(s _ {2} ^ {q _ {1}}\right) \varphi \left(s _ {2} ^ {q _ {2}}\right) \\ + \varphi \left(s _ {1} ^ {p _ {1}}\right) \varphi \left(s _ {1} ^ {p _ {2}}\right) \varphi \left(s _ {2} ^ {q _ {1} + q _ {2}}\right) \\ - \varphi \left(s _ {1} ^ {p _ {1}}\right) \varphi \left(s _ {2} ^ {q _ {1}}\right) \varphi \left(s _ {1} ^ {p _ {2}}\right) \varphi \left(s _ {2} ^ {q _ {2}}\right). \\ \end{array}
$$

These relations are to be considered as non-commutative versions for the factoriziation rules of expectations of independent random variables. 

(3) One might ask: What is it good for to find those relations between the moments, if we know the moments in a more explicit form anyhow? 

Answer: Those relations occur in many more situations. For example, independent Wishart matrices satisfy the same relations, even though the explicit form of their mixed moments is quite different from the gue case. 

Furthermore, we can control what happens with these relations much better than with the explicit moments if we deform our setting or construct new random matrices out of other ones. 

Not to mention that those relations also show up in very different corners of mathematics (like operator algebras). 

To make a long story short: Those relations from Theorem 12.7 are really worth being investigated further, not just in a random matrix context, but also for its own sake. This is the topic of a course on Free Probability Theory, which can, for example, be found here: 

rolandspeicher.files.wordpress.com/2019/08/free-probability.pdf 

# 13 Exercises

# 13.1 Assignment 1

Exercise 1. Make yourself familiar with MATLAB (or any other programming language which allows you to generate random matrices and calculate eigenvalues). In particular, you should try to generate random matrices and calculate and plot their eigenvalues. 

Exercise 2. In this exercise we want to derive the explicit formula for the Catalan numbers. We define numbers $c _ { k }$ by the recursion 

$$
c _ {k} = \sum_ {l = 0} ^ {k - 1} c _ {l} c _ {k - l - 1} \tag {13.1}
$$

for $k > 0$ , with the initial data $c _ { 0 } = 1$ . 

(1) Show that the numbers $c _ { k }$ are uniquely defined by the recursion (13.1) and its initial data. 

(2) Consider the (generating) function 

$$
f (z) = \sum_ {k = 0} ^ {\infty} c _ {k} z ^ {k}
$$

and show that the recursion (13.1) implies the relation 

$$
f (z) = 1 + z f (z) ^ {2}.
$$

(3) Show hat $f$ is a power series representation for 

$$
z \mapsto \frac {1 - \sqrt {1 - 4 z}}{2 z}.
$$

Note: You may use the fact that the formal power series $f$ , defined in (2), has a positive radius of convergence. 

(4) Conclude that 

$$
c _ {k} = C _ {k} = \frac {1}{k + 1} \binom {2 k} {k}.
$$

Exercise 3. Consider the semicircular distribution, given by the density function 

$$
\frac {1}{2 \pi} \sqrt {4 - x ^ {2}} \mathbb {1} _ {[ - 2, 2 ]}, \tag {13.2}
$$

where $\mathbb { 1 } _ { [ - 2 , 2 ] }$ denotes the indicator function of the interval $[ - 2 , 2 ]$ . Show that (13.2) indeed defines a probability measure, i.e. 

$$
\frac {1}{2 \pi} \int_ {- 2} ^ {2} \sqrt {4 - x ^ {2}} \mathrm {d} x = 1.
$$

Moreover show that the even moments of the measure are given by the Catalan numbers and the odd ones vanish, i.e. 

$$
\frac {1}{2 \pi} \int_ {- 2} ^ {2} x ^ {n} \sqrt {4 - x ^ {2}}   \mathrm {d} x = \left\{ \begin{array}{l l} 0 & n \text {i s o d d} \\ C _ {k} & n = 2 k \end{array} \right..
$$

# 13.2 Assignment 2

Exercise 4. Using your favorite programing language or computer algebra system, generate $N \times N$ random matrices for $N = 3 , 9 , 1 0 0$ . Produce a plot of the eigenvalue distribution for a single random matrix and as well as a plot for the average over a reasonable number of matrices of given size. The entries should be independent and identically distributed (i.i.d.) according to 

(1) the Bernoulli distribution $\frac { 1 } { 2 } ( \delta _ { - 1 } + \delta _ { 1 } )$ , where $\delta _ { x }$ denotes the Dirac measure with atom $x$ . 

(2) the normal distribution. 

Exercise 5. Prove Proposition 2.2, i.e. compute the moments of a standart Gaussian random variable: 

$$
\frac {1}{\sqrt {2 \pi}} \int_ {- \infty} ^ {\infty} t ^ {n} e ^ {- \frac {t ^ {2}}{2}} \mathrm {d} t = \left\{ \begin{array}{l l} 0 & n \mathrm {o d d}, \\ (n - 1)!! & n \mathrm {e v e n}. \end{array} \right.
$$

Exercise 6. Let $Z , Z _ { 1 } , Z _ { 2 } , \ldots , Z _ { n }$ be independent standard complex Gaussian random variables with mean 0 and $\mathbb { E } [ | Z _ { i } | ] = 1$ for $i = 1 , \ldots , n$ . 

(1) Show that 

$$
\mathbb {E} [ Z _ {i _ {1}}, \ldots , Z _ {i _ {r}} \bar {Z} _ {j _ {1}} \ldots \bar {Z} _ {j _ {r}} ] = \# \{\sigma \in S _ {r} \colon i _ {k} = j _ {\sigma (k)} \mathrm {f o r} k = 1, \ldots , r \}.
$$

(2) Show that 

$$
\mathbb {E} [ Z ^ {n} \bar {Z} ^ {m} ] = \left\{ \begin{array}{l l} 0 & m \neq n, \\ n! & m = n. \end{array} \right.
$$

Exercise 7. Let $A = ( a _ { i j } ) _ { i , j = 1 } ^ { N }$ be a Gaussian (gue(n)) random matrix with entries $a _ { i i } = x _ { i i }$ and $a _ { i j } = x _ { i j } + \surd - 1 y _ { i j }$ , i.e. the $x _ { i j } , y _ { i j }$ are real i.i.d. Gaussian random variables, normalized such that $\mathbb { E } [ | a _ { i j } ^ { 2 } | ] = 1 / N$ . Consider the $N ^ { 2 }$ random vector 

$$
\left(x _ {1 1}, \dots , x _ {N N}, x _ {1 2}, \dots , x _ {1 N}, \dots , x _ {N - 1 N}, y _ {1 2}, \dots , y _ {1 N}, \dots , y _ {N - 1 N}\right)
$$

and show that it has the density 

$$
C \exp (- N \frac {\mathrm {T r} (A ^ {2})}{2}) \mathrm {d} A,
$$

where $C$ is a constant and 

$$
\mathrm {d} A = \prod_ {i = 1} ^ {N} \mathrm {d} x _ {i i} \prod_ {i <   y} \mathrm {d} x _ {i j} \mathrm {d} y _ {i j}.
$$

# 13.3 Assignment 3

Exercise 8. Produce histograms for various random matrix ensembles. 

(1) Produce histograms for the averaged situation: average over 1000 realizations for the eigenvalue distribution of a an $N \times N$ Gaussian random matrix (or alternatively $\pm 1$ entries) and compare this with one random realization for $N = 5 , 5 0 , 5 0 0 , 1 0 0 0$ . 

(2) Check via histograms that Wigner’s semicircle law is insensitive to the common distribution of the entries as long as those are independent; compare typical realisations for $N = 1 0 0$ and $N = 3 0 0 0$ for different distributions of the entries: $\pm 1$ , Gaussian, uniform distribution on the interval $[ - 1 , + 1 ]$ . 

(3) Check what happens when we give up the constraint that the the entries are centered; take for example the uniform distribution on $[ 0 , 2 ]$ . 

(4) Check whether the semicircle law is sensitive to what happens on the diagonal of the matrix. Choose one distribution (e.g. Gaussian) for the off-diagonal elements and another distribution for the elements on the diagonal (extreme case: put the diagonal equal to zero). 

(5) Try to see what happens when we take a distribution for the entries which does not have finite second moment; for example, the Cauchy distribution. 

Exercise 9. In the proof of Theorem 3.9 we have seen that the $m$ -th moment of a Wigner matrix is asymptotically counted by the number of partitions $\sigma \in \mathcal { P } ( m )$ , for which the corresponding graph $\mathcal { G } _ { \sigma }$ is a tree; then the corresponding walk $i _ { 1 } $ $i _ { 2 } \to \cdots \to i _ { m } \to i _ { 1 }$ (where ker $i = \sigma$ ) uses each edge exactly twice, in opposite directions. Assign to such a $\sigma$ a pairing by opening/closing a pair when an edge is used for the first/second time in the corresponding walk. 

(1) Show that this map gives a bijection between the $\sigma \in \mathcal { P } ( m )$ for which $\mathcal { G } _ { \sigma }$ is a tree and non-crossing pairings $\pi \in N C _ { 2 } ( m )$ . 

(2) Is there a relation between $\sigma$ and $\gamma \pi$ , under this bijection? 

Exercise 10. For a probability measure $\mu$ on $\mathbb { R }$ we define its Stieltjes transform $S _ { \mu }$ by 

$$
S _ {\mu} (z) := \int_ {\mathbb {R}} \frac {1}{t - z} d \mu (t)
$$

for all $z \in \mathbb { C } ^ { + } : = \{ z \in \mathbb { C } \mid \operatorname { I m } ( z ) > 0 \}$ . Show the following for a Stieltjes transform $S = S _ { \mu }$ . 

(1) $S : \mathbb { C } ^ { + } \to C ^ { + }$ . 

(2) $S$ is analytic on $\mathbb { C } ^ { + }$ 

(3) We have 

$$
\lim  _ {y \rightarrow \infty} i y S (i y) = - 1 \qquad \text {a n d} \qquad \sup  _ {y > 0, x \in \mathbb {R}} y | S (x + i y) | = 1.
$$

# 13.4 Assignment 4

Exercise 11. (1) Let $\nu$ be the Cauchy distribution, i.e., 

$$
d \nu (t) = \frac {1}{\pi} \frac {1}{1 + t ^ {2}} d t.
$$

Show that the Stieltjes transform of $\nu$ is given by 

$$
S (z) = \frac {1}{- i - z} \qquad \mathrm {f o r} z \in \mathbb {C} ^ {+}.
$$

(Note that this formula is not valid in $\mathbb { C } ^ { - }$ .) 

Recover from this the Cauchy distribution via the Stieltjes inversion formula. 

(2) Let $A$ be a selfadjoint matrix in $M _ { N } ( \mathbb { C } )$ and consider its spectral distribution $\begin{array} { r } { \mu _ { A } = \frac { 1 } { N } \sum _ { i = 1 } ^ { N } \delta _ { \lambda _ { i } } } \end{array}$ , where $\lambda _ { 1 } , \ldots , \lambda _ { N }$ are the eigenvalues (counted with multiplicity) of $A$ . Prove that for any $z \in \mathbb { C } ^ { + }$ the Stieltjes transform $S _ { \mu _ { A } }$ of $\mu _ { A }$ is given by 

$$
S _ {\mu_ {A}} (z) = \operatorname {t r} \left[ (A - z I) ^ {- 1} \right].
$$

Exercise 12. Let $( \mu _ { N } ) _ { N \in \mathbb { N } }$ be a sequence of probability measures on $\mathbb { R }$ which converges vaguely to $\mu$ . Assume that $\mu$ is also a probablity measure. Show the following. 

(1) The sequence $( \mu _ { N } ) _ { N \in \mathbb { N } }$ is tight, i.e., for each $\varepsilon > 0$ there is a compact interval $I = [ - R , R ]$ such that $\mu _ { N } ( \mathbb { R } \backslash I ) \leq \varepsilon$ for all $N \in  { \mathbb { N } }$ . 

(2) $\mu _ { N }$ converges to $\mu$ also weakly. 

Exercise 13. The problems with being determined by moments and whether convergence in moments implies weak convergence are mainly coming from the behaviour of our probability measures around infinity. If we restrict everything to a compact interval, then the main statements follow quite easily by relying on the Weierstrass theorem for approximating continuous functions by polynomials. In the following you should not use Theorem 4.12. 

In the following let $I = [ - R , R ]$ be a fixed compact interval in $\mathbb { R }$ . 

(1) Assume that $\mu$ is a probability measure on $\mathbb { R }$ which has its support in $I$ (i.e., $\mu ( I ) = 1$ ). Show that all moments of $\mu$ are finite and that $\mu$ is determined by its moments (among all probability measures on $\mathbb { R }$ ). 

(2) Consider in addition a sequence of probability measures $\mu _ { N }$ , such that $\mu _ { N } ( I ) =$ 1 for all $N$ . Show that the following are equivalent: 

• $\mu _ { N }$ converges weakly to $\mu$ ; 

• the moments of $\mu _ { N }$ converge to the corresponding moments of $\mu$ 

# 13.5 Assignment 5

In this assignment we want to investigate the behaviour of the limiting eigenvalue distribution of matrices under certain perturbations. In order to do so, it is crucial to deal with different kinds of matrix norms. We recall the most important ones for the following exercises. Let $A \in M _ { N } ( \mathbb { C } )$ , then we define the following norms. 

• The spectral norm (or operator norm): 

$$
\left\| A \right\| = \max  \left\{\sqrt {\lambda}: \lambda \text {i s a n e i g e n v a l u e o f} A A ^ {*} \right\}.
$$

Some of its important properties are: 

(i) It is submultiplicative, i.e. for $A , B \in M _ { N } ( \mathbb { C } )$ one has 

$$
\left\| A B \right\| \leq \left\| A \right\| \cdot \left\| B \right\|.
$$

(ii) It is also given as the operator norm 

$$
\| A\| = \sup_{\substack{x\in \mathbb{C}^{N}\\ x\neq 0}}\frac{\|Ax\|_{2}}{\|x\|_{2}},
$$

where $\| x \| _ { 2 }$ is here the Euclidean 2-norm of the vector $\boldsymbol { x } \in \mathbb { C } ^ { N }$ . 

• The Frobenius (or Hilbert-Schmidt or $L ^ { 2 }$ ) norm: 

$$
\| A \| _ {2} = \left(\operatorname {T r} \left(A ^ {*} A\right)\right) ^ {1 / 2} = \sqrt {\sum_ {1 \leq i , j \leq N} \left| a _ {i j} \right| ^ {2}}
$$

Exercise 14. In this exercise we will prove some useful facts about these norms, which you will have to use in the next exercise when adressing the problem of perturbed random matrices. 

Prove the following properties of the matrix norms. 

(1) For $A , B \in M _ { N } ( \mathbb { C } )$ we have $| \operatorname { T r } ( A B ) | \leq \| A \| _ { 2 } \cdot \| B \| _ { 2 }$ . 

(2) Let $A \in M _ { N } ( \mathbb { C } )$ be positive and $B \in M _ { N } ( \mathbb { C } )$ arbitrary. Prove that 

$$
| \operatorname {T r} (A B) | \leq \| B \| \operatorname {T r} (A).
$$

( $A \in M _ { N } ( \mathbb { C } )$ is positive if there is a matrix $C \in M _ { N } ( \mathbb { C } )$ such that $A = C ^ { * } C$ ; this is equivalent to the fact that $A$ is selfadjoint and all the eigenvalues of $A$ are positive.) 

(3) Let $A \in M _ { N } ( \mathbb { C } )$ be normal, i.e. $A A ^ { * } = A ^ { * } A$ , and $B \in M _ { N } ( \mathbb { C } )$ arbitrary. Prove that 

$$
\max  \left\{\| A B \| _ {2}, \| B A \| _ {2} \right\} \leq \| B \| _ {2} \cdot \| A \|
$$

Hint: normal matrices are unitarily diagonalizable. 

Exercise 15. In this main exercise we want to investigate the behaviour of the eigenvalue distribution of selfadjoint matrices with respect to certain types of perturbations. 

(1) Let $A \in M _ { N } ( \mathbb { C } )$ be selfadjoint, $z \in \mathbb { C } ^ { + }$ and $R _ { A } ( z ) = ( A - z I ) ^ { - 1 }$ . Prove that 

$$
\| R _ {A} (z) \| \leq \frac {1}{\operatorname {I m} (z)}
$$

and that $R _ { A } ( z )$ is normal. 

(2) First we study a general perturbation by a selfadjoint matrix. 

Let, for any $N \in  { \mathbb { N } }$ , $X _ { N } = ( X _ { i j } ) _ { i , j = 1 } ^ { N }$ and $Y _ { N } = ( Y _ { i j } ) _ { i , j = 1 } ^ { N }$ be selfadjoint matrices in $M _ { N } ( \mathbb { C } )$ and define $\ddot { X } _ { N } = X _ { N } + Y _ { N }$ . Show that 

$$
\left| \operatorname {t r} \left(R _ {\frac {1}{\sqrt {N}} X _ {N}} (z)\right) - \operatorname {t r} \left(R _ {\frac {1}{\sqrt {N}} \tilde {X} _ {N}} (z)\right) \right| \leq \frac {1}{(\operatorname {I m} (z)) ^ {2}} \sqrt {\frac {\operatorname {t r} \left(Y _ {N} ^ {2}\right)}{N}}
$$

(3) In this part we want to show that the diagonal of a matrix does not contribute to the eigenvalue distribution in the large $N$ limit, if it is not too ill-behaved. As before, consider a selfadjoint matrix $X _ { N } = ( X _ { i j } ) _ { i , j = 1 } ^ { N } \in M _ { N } ( \mathbb { C } )$ ; let $X _ { N } ^ { D } =$ $\mathrm { d i a g } ( X _ { 1 1 } , \ldots , X _ { N N } )$ be the diagonal part of $X _ { N }$ and $X _ { N } ^ { ( 0 ) } = X _ { N } - X _ { N } ^ { D }$ the part of $X _ { N }$ with zero diagonal. Assume that $\| X _ { N } ^ { D } \| _ { 2 } \leq N$ for all $N \in  { \mathbb { N } }$ . Show that 

$$
\left| \operatorname {t r} \left(R _ {\frac {1}{\sqrt {N}} X _ {N}} (z)\right) - \operatorname {t r} \left(R _ {\frac {1}{\sqrt {N}} X _ {N} ^ {(0)}} (z)\right)\right|\rightarrow 0, \quad \text {a s} N \rightarrow \infty .
$$

# 13.6 Assignment 6

Exercise 16. We will address here concentration estimates for the law of large numbers, and see that control of higher moments allows stronger estimates. Let $X _ { i }$ be a sequence of independent and identically distributed random variables with common mean $\mu = E [ X _ { i } ]$ . We put 

$$
S _ {n} := \frac {1}{n} \sum_ {i = 1} ^ {n} X _ {i}.
$$

(1) Assume that the variance Var $[ X _ { i } ]$ is finite. Prove that we have then the weak law of large numbers, i.e., convergence in probability of $S _ { n }$ to the mean: for any $\epsilon > 0$ 

$$
\mathbb {P} (\omega \mid | S _ {n} (\omega) - \mu | \geq \epsilon) \rightarrow 0, \quad \text {f o r} n \rightarrow \infty .
$$

(2) Assume that the fourth moment of the $X _ { i }$ is finite, $\mathbb { E } \left[ X _ { i } ^ { 4 } \right] < \infty$ . Show that we have then the strong law of large numbers, i.e., 

$$
S _ {n} \rightarrow \mu , \quad \text {a l m o s t s u r e l y}.
$$

(Recall that by Borel–Cantelli it suffices for almost sure convergence to show that 

$$
\sum_ {n = 1} ^ {\infty} \mathbb {P} (\omega \mid | S _ {n} (\omega) - \mu | \geq \epsilon) <   \infty .)
$$

One should also note that our assumptions for the weak and strong law of large numbers are far from optimal. Even the existence of the variance is not needed for them, but for proofs of such general versions one needs other tools then our simple consequences of Cheyshev’s inequality. 

Exercise 17. Let $\begin{array} { r } { X _ { N } \ = \ \frac { 1 } { \sqrt { N } } ( x _ { i j } ) _ { i , j = 1 } ^ { N } } \end{array}$ , where the $x _ { i j }$ are all (without symmetry condition) independent and identically distributed with standard complex Gaussian distribution. We denote the adjoint (i.e., congugate transpose) of $X _ { N }$ by $X _ { N } ^ { * }$ . 

(1) By following the ideas from our proof of Wigner’s semicircle law for the gue in Chapter 3 show the following: the averaged trace of any $^ *$ -moment in $X _ { N }$ and $X _ { N } ^ { * }$ , i.e., 

$$
E [ \mathrm {t r} (X _ {N} ^ {p (1)} \dots X _ {N} ^ {p (m)}) ] \qquad \mathrm {w h e r e} p (1), \ldots , p (m) \in \{1, * \}
$$

is for $N  \infty$ given by the number of non-crossing pairings $\pi$ in $N C _ { 2 } ( m )$ which satisfy the additional requirement that each block of $\pi$ connects an $X$ with an $X ^ { \ast }$ . 

(2) Use the result from part (1) to show that the asymptotic averaged eigenvalue distribution of $W _ { N } : = \ X _ { N } X _ { N } ^ { * }$ is the same as the square of the semicircle distribution, i.e. the distribution of $Y ^ { 2 }$ if $Y$ has a semicircular distribution. 

(3) Calculate the explicit form of the asymptotic averaged eigenvalue distribution of $W _ { N }$ . 

(4) Again, the convergence is here also in probability and almost surely. Produce histograms of samples of the random matrix $W _ { N }$ for large $N$ and compare it with the analytic result from (3). 

Exercise 18. We consider now random matrices $W _ { N } = X _ { N } X _ { N } ^ { * }$ as in Exercise 17, but now we allow the $X _ { N }$ to be rectangular matrices, i.e., of the form 

$$
X_{N} = \frac{1}{\sqrt{p}} (x_{ij})_{\substack{1\leq i\leq N\\ 1\leq j\leq p}},
$$

where again all $x _ { i j }$ are independent and identically distributed. We allow now real or complex entries. (In case the entries are real, $X _ { N } ^ { * }$ is of course just the transpose $X _ { N } ^ { T }$ .) Such matrices are called Wishart matrices. Note that we can now not multiply $X _ { N }$ and $X _ { N } ^ { * }$ in arbitrary order, but alternating products as in $W _ { N }$ make sense. 

(1) What is the general relation between the eigenvalues of $X _ { N } X _ { N } ^ { * }$ and the eigenvalues of $X _ { N } ^ { * } X _ { N }$ . Note that the first is an $N \times N$ matrix, whereas the second is a $p \times p$ matrix. 

(2) Produce histograms for the eigenvalues of $W _ { N } : = X _ { N } X _ { N } ^ { * }$ for $N = 5 0$ , $p = 1 0 0$ as well as for $N = 5 0 0$ , $p = 1 0 0 0$ , for different distributions of the $x _ { i j }$ ; 

• standard real Gaussian random variables 

• standard complex Gaussian random variables 

• Bernoulli random variables, i.e., $x _ { i j }$ takes on values $+ 1$ and $- 1$ , each with probability $1 / 2$ . 

(3) Compare your histograms with the density, for $c = 0 . 5 = N / p$ , of the Marchenko– Pastur distribution which is given by 

$$
\frac {\sqrt {(\lambda^ {+} - x) (x - \lambda^ {-})}}{2 \pi c x} \mathbb {1} _ {[ \lambda^ {-}, \lambda^ {+} ]} (x), \quad \text {w h e r e} \quad \lambda^ {\pm} := \left(1 \pm \sqrt {c}\right) ^ {2}.
$$

# 13.7 Assignment 7

Exercise 19. Prove – by adapting the proof for the goe case and parametrizing a unitary matrix in the form $U = e ^ { - i H }$ , where $H$ is a selfajoint matrix – Theorem 7.6: The joint eigenvalue distribution of the eigenvalues of a gue(n) is given by a density 

$$
\hat {c} _ {N} e ^ {- \frac {N}{2} (\lambda_ {1} ^ {2} + \dots + \lambda_ {N} ^ {2})} \prod_ {k <   l} (\lambda_ {l} - \lambda_ {k}) ^ {2},
$$

restricted on $\lambda _ { 1 } < \lambda _ { 2 } < \cdots < \lambda _ { N }$ , 

Exercise 20. In order to get a feeling for the repulsion of the eigenvalues of goe and gue compare histograms for the following situations: 

• the eigenvalues of a gue(n) matrix for one realization 

• the eigenvalues of a goe(n) matrix for one realization 

• $N$ independently chosen realizations of a random variable with semicircular distribution 

for a few suitable values of $N$ (for example, take $N = 5 0$ or $N = 5 0 0$ ). 

Exercise 21. For small values of $N$ (like $N = 2 , 3 , 4 , 5 , 1 0$ ) plot the histogram of averaged versions of gue(n) and of goe(n) and notice the fine structure in the gue case. In the next assignment we will compare this with the analytic expression for the gue(n) density from class. 

# 13.8 Assignment 8

Exercise 22. In this exercise we define the Hermite polynomials $H _ { n }$ by 

$$
H _ {n} (x) = (- 1) ^ {n} e ^ {x ^ {2} / 2} \frac {d ^ {n}}{d x ^ {n}} e ^ {- x ^ {2} / 2}
$$

and want to show that they are the same polynomials we defined in Definition 7.10 and that they satisfy the recursion relation. So, starting from the above definition show the following. 

(1) For any $n \geq 1$ 

$$
x H _ {n} (x) = H _ {n + 1} (x) + n H _ {n - 1} (x).
$$

(2) $H _ { n }$ is a monic polynomial of degree $n$ . Furthermore, it is an even function if $n$ is even and an odd function if $n$ is odd. 

(3) The $H _ { n }$ are orthogonal with respect to the Gaussian measure 

$$
d \gamma (x) = (2 \pi) ^ {- 1 / 2} e ^ {- x ^ {2} / 2} d x.
$$

More precisely, show the following: 

$$
\int_ {\mathbb {R}} H _ {n} (x) H _ {m} (x) d \gamma (x) = \delta_ {n m} n!
$$

Exercise 23. Produce histograms for the averaged eigenvalue distribution of a gue(n) and compare this with the exact analytic density from Theorem 7.21. 

(1) Rewrite first the averaged eigenvalue density 

$$
p _ {N} (\mu) = \frac {1}{N} K _ {N} (\mu , \mu) = \frac {1}{\sqrt {2 \pi}} \frac {1}{N} \sum_ {k = 0} ^ {N - 1} \frac {1}{k !} H _ {k} (\mu) ^ {2} e ^ {- \mu^ {2} / 2}
$$

for the unnormalized gue(n) to the density $q _ { N } ( \lambda )$ for the normalized gue(n) (with second moment normalized to 1). 

(2) Then average over sufficiently many normalized gue(n), plot their histograms, and compare this to the analytic density $q _ { N } ( \lambda )$ . Do this at least for $N =$ $1 , 2 , 3 , 5 , 1 0 , 2 0 , 5 0$ . 

(3) Check also numerically that $q _ { N }$ converges, for $N \to \infty$ , to the semicircle. 

(4) For comparison, also average over goe(n) and over Wigner ensembles with non-Gaussian distribution for the entries, for some small $N$ . 

Exercise 24. In this exercise we will approximate the Dyson Brownian motions from Section 8.3 by their discretized random walk versions and plot the corresponding walks of the eigenvalues. 

(1) Approximate the Dyson Brownian motion by its discretized random walk version 

$$
A _ {N} (k) := \sum_ {i = 1} ^ {k} \Delta \cdot A _ {N} ^ {(i)}, \qquad \text {f o r} 1 \leq k \leq K
$$

where $A _ { N } ^ { ( 1 ) } , \ldots , A _ { N } ^ { ( K ) }$ , are $K$ independent normalized gue(n) random matrices. $\Delta$ is a time increment. Generate a random realization of such a Dyson random walk $A _ { N } ( k )$ and plot the $N$ eigenvalues $\lambda _ { 1 } ( k ) , \ldots , \lambda _ { N } ( k )$ of $A _ { N } ( k )$ versus $k$ in the same plot to see the time evolution of the $N$ eigenvalues. Produce at least plots for three different values of $N$ . 

Hint: Start with $N = 1 5$ , $\Delta = 0 . 0 1$ , $K = 1 5 0 0$ , but also play around with those parameters. 

(2) For the same parameters as in part (i) consider the situation where you replace gue by goe and produce corresponding plots. What is the effect of this on the behaviour of the eigenvalues? 

(3) For the three considered cases of $N$ in parts (1) and 2i), plot also $N$ independent random walks in one plot, i.e., 

$$
\tilde {\lambda} _ {N} (k) := \sum_ {i = 1} ^ {k} \Delta \cdot x ^ {(i)}, \qquad \text {f o r} 1 \leq k \leq K
$$

where $x ^ { ( 1 ) } , \ldots , x ^ { ( K ) }$ are $K$ independent real standard Gaussian random variables. 

You should get some plots like in Section 8.3. 

# 13.9 Assignment 9

Exercise 25. Produce histograms for the Tracy–Widom distribution by plotting (λmax − 2)N 2/3. $( \lambda _ { \operatorname* { m a x } } - 2 ) N ^ { 2 / 3 }$ 

(1) Produce histograms for the largest eigenvalue of gue(n), for $N = 5 0$ , $N = 1 0 0$ $N = 2 0 0$ , with at least 5000 trials in each case. 

(2) Produce histograms for the largest eigenvalue of goe(n), for $N = 5 0$ , $N = 1 0 0$ , $N = 2 0 0$ , with at least 5000 trials in each case. 

(3) Consider also real and complex Wigner matrices with non-Gaussian distribution for the entries. 

(4) Check numerically whether putting the diagonal equal to zero (in gue or Wigner) has an effect on the statistics of the largest eigenvalue. 

(5) Bonus: Take a situation where we do not have convergence to semicircle, e.g., Wigner matrices with Cauchy distribution for the entries. Is there a reasonable guess for the asymptotics of the distribution of the largest eigenvalue? 

(6) Superbonus: Compare the situation of repelling eigenvalues with “independent” eigenvalues. Produce $N$ independent copies $x _ { 1 } , \ldots , x _ { N }$ of variables distributed according to the semicircle distribution and take then the maximal 

value $x _ { \mathrm { m a x } }$ of these. Produce a histogram of the statistics of $x _ { \mathrm { m a x } }$ . Is there a limit of this for $N \to \infty$ ; how does one have to scale with $N$ ? 

Exercise 26. Prove the estimate for the Catalan numbers 

$$
C _ {k} \leq \frac {4 ^ {k}}{k ^ {3 / 2} \sqrt {\pi}} \quad \forall k \in \mathbb {N}.
$$

Show that this gives the right asymptotics, i.e., prove that 

$$
\lim _ {k \to \infty} \frac {4 ^ {k}}{k ^ {3 / 2} C _ {k}} = \sqrt {\pi}.
$$

Exercise 27. Let $H _ { n } ( x )$ be the Hermite polynomials. The Christoffel-Darboux identity says that 

$$
\sum_ {k = 0} ^ {n - 1} \frac {H _ {k} (x) H _ {k} (y)}{k !} = \frac {H _ {n} (x) H _ {n - 1} (y) - H _ {n - 1} (x) H _ {n} (y)}{(x - y) (n - 1) !}.
$$

(1) Check this identity for $n = 1$ and $n = 2$ . 

(2) Prove the identity for general $n$ 

# 13.10 Assignment 10

Exercise 28. Work out the details for the “almost sure” part of Corollary 9.6, i.e., prove that almost surely the largest eigenvalue of gue(n) converges, for $N  \infty$ , to 2. 

Exercise 29. Consider the rescaled Hermite functions 

$$
\tilde {\Psi} (x) := N ^ {1 / 1 2} \Psi_ {N} (2 \sqrt {N} + x N ^ {- 1 / 6}).
$$

(1) Check numerically that the rescaled Hermite functions have a limit for $N \to \infty$ by plotting them for different values of $N$ . 

(2) Familarize yourself with the Airy function. Compare the above plots of $\tilde { \Psi } _ { N }$ for large $N$ with a plot of the Airy function. 

Hint: MATLAB has an implementation of the Airy function, see 

https://de.mathworks.com/help/symbolic/airy.html 

Exercise 30. Prove that the Hermite functions satisfy the following differential equations: 

$$
\Psi_ {n} ^ {\prime} (x) = - \frac {x}{2} \Psi_ {n} (x) + \sqrt {n} \Psi_ {n - 1} (x)
$$

and 

$$
\Psi_ {n} ^ {\prime \prime} (x) + (n + \frac {1}{2} - \frac {x ^ {2}}{4}) \Psi_ {n} (x) = 0.
$$

# 13.11 Assignment 11

Exercise 31. Read the notes “Random Matrix Theory and its Innovative Applications” by A. Edelman and Y. Wang, 

# http:

//math.mit.edu/~edelman/publications/random_matrix_theory_innovative.pdf 

and implement its “Code 7” for calculating the Tracy–Widom distribution (via solving the Painlevé II equation) and compare the output with the histogram for the rescaled largest eigenvalue for the gue from Exercise 25. You should get a plot like after Theorem 9.10. 

Exercise 32. For N = 100, 1000, 5000 plot in the complex plane the eigenvalues of one $N \times N$ random matrix $\smash { \frac { 1 } { \sqrt { N } } \boldsymbol { A } _ { N } }$ , where all entries (without symmetry condition) are independent and identically distributed according to the 

(i) standard Gaussian distribution; 

(ii) symmetric Bernoulli distribution; 

(iii) Cauchy distribution. 

# 14 Literature

# Books



(1) Gernot Akemann, Jinho Baik, Philippe Di Francesco: The Oxford Handbook of Random Matrix Theory, Oxford Handbooks in Mathematics, 2011. 





(2) Greg Anderson, Alice Guionnet, Ofer Zeitouni: An Introduction to Random Matrices, Cambridge University Press, 2010. 





(3) Zhidong Bai, Jack Silverstein: Spectral Analysis of Large Dimensional Random Matrices, Springer-Verlag 2010. 





(4) Patrick Billingsley: Probability and Measure, John Wiley & Sons, 3rd edition, 1995. 





(5) Stéphane Boucheron, Gábor Lugosi, Pascal Massart: Concentration inequalities: A nonasymptotic theory of independence, Oxford University Press, Oxford, 2013. 





(6) Alice Guionnet: Large Random Matrices: Lectures on Macroscopic Asymptotics, Springer-Verlag 2009. 





(7) Madan Lal Mehta: Random Matices, Elsevier Academic Press, 3rd edition, 2004. 





(8) James Mingo, Roland Speicher: Free Probability and Random Matrices, Springer-Verlag, 2017. 





(9) Alexandru Nica, Roland Speicher: Lectures on the Combinatorics of Free Probability, Cambridge University Press 2006. 



# Lecture Notes and Surveys



(10) Nathanaël Berstycki: Notes on Tracy–Widom Fluctuation Theory, 2007. 





(11) Charles Bordenave, Djalil Chafaï: Around the circular law, Probability Surveys 9 (2012) 1-89. 





(12) Alan Edelman, Raj Rao: Random matrix theory, Acta Numer. 14 (2005), 233-297. 





(13) Alan Edelman, Raj Rao: The polynomial method for random matrices, Found. Comput. Math. 8 (2008), 649-702. 





(14) Todd Kemp: MATH 247A: Introduction to Random Matrix Theory, lecture notes, UC San Diego, fall 2013. 

