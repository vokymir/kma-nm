// template
#import "@preview/charged-ieee:0.1.4": ieee

// library to create graphs
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

// highlight all TODOs, which is WOW, easy yet not
#show regex("TODO(.*)"): it => text(fill: red, weight: "bold")[#it]

#show: ieee.with(
  title: [Automatic Differentiation],
  abstract: [
    This paper provides an explanation of Automatic Differentiation (autodiff)
    concept for university students at near-bachelor level. Includes comparison
    with other differentiation methods, very simple autodiff implementation
    example and more realistic usage in python library.
  ],
  authors: (
    (
      name: "Jakub Vokoun",
    ),
  ),
  paper-size: "a4",
  index-terms: ("autodiff", "python", "computational mathematics"),
  bibliography: bibliography("refs.bib"),
  figure-supplement: [Fig.],
)

#set math.equation(numbering: "(1)")

#show ref: it => {
  let el = it.element

  if el == none {
    return it
  }

  let loc = it.element.location()
  // let page = loc.page()

  // if el.func() == heading {
  //   return link(
  //     loc,
  //     [_#el.body (page #page)_],
  //   )
  // }

  // if el.func() == math.equation {
  //   return link(
  //     loc,
  //     [_Equation #el.numbering at page #(page)_],
  //   )
  // }
  if el.func() == math.equation {
    let num = counter(math.equation).at(loc)

    return link(
      loc,
      [Eq. #context { numbering(math.equation.numbering, ..num) }],
    )
  }

  it
}


= Introduction

Derivative is an indispensable tool in almost any field of mathematics. Its
useful property lies in revealing the rate of change of any function. The
process of differentiation is very simple, therefore presumably easily encoded
into computer program. Since the birth of machine computing various methods were
discovered, all with their respective drawbacks. We will explore these methods
later. It is necessary to understand the foundational challenges and
inner workings of differentiation first.

Derivative may be defined as a limit, such as
$
  L = lim_(h arrow 0)( f(a + h) - f(a) ) / h
$ <eq:derivative>
where $f(x)$ is differentiable on an open interval containing point $a$, and if
the limit $L$ exists. In principle, the derivative of any function (if exists)
may be computed using this definition. However, since was discovered different
approach. When a few simple functions have known derivatives, using them with a
set of rules for obtaining derivatives of more complicated functions results in
a different, simpler method. The process of finding a derivative is called
differentiation.

For example, if we know the derivative of a polynomial
$
  (x^a)' = a x^(a-1)
$
where $a$ is an arbitrary integer, and a sum rule
$
  (alpha f + beta g)' = alpha f' + beta g'
$
for any function $f$, $g$, and all real numbers $alpha$, $beta$, we may obtain
derivative for this function:
$
  f(x) = 3x^2 + 5x
$
Using both the rules its apparent the result will be:
$
  f(x)' = 6x + 5
$
This simple example demonstrated, that with as little as one known derivative
and one rule, we are able to differentiate a whole class of functions,
polynomials.

If we add to our set of known derivatives and rules, we are quickly able to
differentiate any known function. With large enough set it is only matter of
mechanicaly applying rules and known derivatives in the correct order. Something
a computer is supposedly very good at, or at least less error-prone than most
humans.

The most powerful property of computer is the `if-else` branching logic. Another
important part is the ability to perform sequential instructions. This trait
might be easily exploitable in order to create a computer program which would
take any function as an input and produce its derivative as output.

Most often the function we need to differentiate is in the form
$
  f: RR^n arrow RR^m
$
where $n$ and $m$ are any positive integers. It might be useful to calculate its
partial derivatives or the Jacobian matrix. For some tasks it might be
sufficient to only calculate only one partial derivative, a row or column of
derivatives.

= Alternative differentiation methods

Automatic differentiation (autodiff) was not the first method for finding
derivatives utilizing computer. In fact it is conceptually more complex than the
previous methods.

That is not to say the _older_ methods are inherently worse because they were
discovered sooner or that are less complex. Every method is useful in particular
scenario, however it is important to know about all of them and their advantages
and weaknesses.

== Finite difference method

This method is based on the @eq:derivative. The assumption is, that with a
small-enough $h$, the error will be negligible. It is not an analytical, a
precise method, rather a numerical tool for obtaining _good-enough_ derivative.
This method doesn't take advantage of computers properties. It only uses the
machine as a mere calculator.

Humans represent numbers most often using arabic numerals. Computers represent
and store numbers in different formats. When working with non-integers a
floating point arithmetic was introduced, and later standardized @IEEE754. This
format has limited precision and for very large or very small (near to zero)
numbers is prone to errors.

The great issue arises as the requirement on precision increases. For simplicity
we will define our own data type, which has the same drawbacks as `float` but is
easier to understand for humans. We will call it `FD2` as _floating decimal 2_,
because it is normal arithmetic with precision up to two numbers.

If we tried to calculate derivative for $f(x) = x$, $a = 100$ and $h = 0.01$
$
  f(x)' = ( f(100 + 0.01) - f(100) ) / 0.01 \
$
we would encounter first error when summing $100 + 0.01 = 100.01$. Due to `FD2`
precision, it is trimmed to $100$. Next, the function $f$ is identity:
$
  f(x)' & = (100 - 100) / 0.01 \
  f(x)' & = 0
$
So, numerically we get the result of derivative to be $0$, but we know that
derivative of linear function is $1$.

TODO: FD use 2x larger interval for better precision? maybe dont write


== Symbolic method

A symbolic method was developed to tackle the problem with FD. It is precise.
The method requires a set of known derivatives as well as set of rules (chain
rule, product rule, ...). For a given expression it uses the rules to expand it
until only known derivatives are in the expression, then simplify the obtained
expression and only then calculate the derivative.
$
         f(x) & = sin(x)/x \
      "using" & "quotient rule:" \
    g(x)/h(x) & = (g'(x)h(x) - g(x)h'(x))/(h(x)^2) \
        f'(x) & = (sin(x)'x - sin(x)x') / (x^2) \
      "using" & "known derivatives:" \
      sin(x)' & = cos(x) \
           x' & = 1 \
        f'(x) & = (cos(x)x - sin(x)1)/(x^2) \
  "simplify:" & \
        f'(x) & = (x cos(x) - sin(x))/(x^2)
$<eq:symbolic>

In @eq:symbolic is demonstrated how symbolic method works. This method is
used in programs such as Matlab, because it is precise. Note that this method
has its drawbacks. The most important one is _expression swell_. The expression
might become overly complex during differentiation because operations were not
applied in advantageous order. While the result might be simple, the process
might be not.

We will demonstrate expression swell on the function $f(x) = (x + 1)^3$.
Depending on how the symbolic solver program was written it might first expand
the term as seen in @eq:expression_swell_no. This approach in this particular
case is better and leads to faster calculation and less computer memory usage.
$
  f(x) = (x + 1)^3 & = x^3 + 3x^2 + 3x + 1 \
             f'(x) & = 3x^2 + 6x + 3
$ <eq:expression_swell_no>

If the solver begins by applying the product rule repeatedly as seen in
@eq:expression_swell_yes, expression swell appears rather quickly.
Depending on the solver it might simplify during the process so it might be
little different than the example. Nevertheless, for more complex expressions it
might not even be possible and the problem holds. The example should have
demonstrated that even for very simple function, if differentiation done
suboptimally, the computational cost is very high.
#text(size: 9pt)[ // must have smaller font-size because it's huuuge
  $
    f(x) = (x + 1)^3 = (x+1) (x+1) (x+1) \
    f′(x) = 1(x+1)(x+1) + (x+1)1(x+1) + (x+1)(x+1)1 \
    f'(x) = (x+1)(x+1) + (x+1)(x+1) + (x+1)(x+1) \
    "using:" (x+1)(x+1) = (x^2+x+x+1) \
    f′(x) = (x^2+x+x+1) + (x^2+x+x+1) + (x^2+x+x+1) \
    f′(x) = x^2+x+x+1 + x^2+x+x+1 + x^2+x+x+1 \
    f'(x) = 3x^2 + 6x + 3
  $ <eq:expression_swell_yes>
]

== Comparison

Both discussed methods have been used and still might be useful to this day.
While FD is really simple, can differentiate _"black box_" functions but can
lead to wrong results due to computer floating point precision, symbolic method
is harder to implement, requires database of known derivatives and rules and is
prone to expression swell thus high memory usage but is precise which is highly
valuable. The differences are summarized in @tab:comparison_fd_sym.

#figure(
  caption: "Comparison between finite differences and symbolic method.",
  table(
    columns: 3,

    table.header([*Property*], [*FD*], [*Symbolic*]),

    [Accuracy], [approximation], [precise],

    [Cost], [$O(1)$], [higher],

    [Implementation], [easy], [harder],

    [Disadvantages], [$h arrow 0$:unstable, \ $epsilon$-sensitive], [expression swell],
  ),
) <tab:comparison_fd_sym>

= Automatic differentiation

Because both finite differences and symbolic method have their respective
drawbacks a need for another method arised. The precise year of automatic
differentiation discovery is not known, some claims it was as soon as the second
half of 1970. Nevertheless, now is it a well-known numerical differentiation
method with wide-spread use.

This method have two distinct modes called forward and backward (reverse) mode.
Both modes use fundamentally the same idea but in different direction, it will
be explained later. However, before exploring the differences between modes let
us first understand the core idea.

== Core principles

Autodiff exploits the fact that every function, no matter how complicated, can
be expressed as function composition. This fundamental property is shown in
@eq:function_composition. The other important property is that every composite
function may be expressed as its variables and elementary
operations#footnote[Elementary operations are atomic mathematical operations
  such as addition and multiplication. In the context of autodiff we enlarge
  this set of functions with well-known derivatives such as $cos$ or $log$.]
that formed them.
$
              f(x) & = x^2 - 4 \
              g(x) & = sin(x) + x \
                   \
  (f compose g)(x) & = f(g(x)) = \
     f(sin(x) + x) & = (sin(x) + x)^2 - 4 \
                   \
  (g compose f)(x) & = g(f(x)) = \
        g(x^2 - 4) & = sin(x^2 - 4) + x^2 - 4
$ <eq:function_composition>

With the function divided into its compositions, let us use an _evaluation
trace_. A special table in which the whole function is recorded. Each row
corresponds to an intermediate variable and the elementary operation which
created them. These intermediats are typically denoted $v_i$ for functions
$f(x): RR^n arrow RR^m$. If we label he variables in $RR^n$ as $x_i$ and
the variables in $RR^m$ as $y_i$, than the intermediate variables indexing follows these rules:
$
  "Input variables" \
  v_(i-n) = x_i, quad i = 1,...,n \
  "Intermediate variables" \
  v_i, quad i = 1,...,l \
  "Output variables" \
  y_(m-i) = v_(l-i), quad i = m - 1,..., 0
$ <eq:indexing_rules>

Let us demonstrate the evaluation trace on a simple example. We will calculate
the function value using evaluation trace for a simple function and their
inputs:
$
  y = f(x_1, x_2) = sin(x_1) - x_1 x_2 + x_2 \
  x_1 = pi, quad x_2 = 2 \
  "(note" y: RR^2 arrow RR ")"
$ <eq:evaluation_trace>

#figure(
  caption: "Evaluation trace for simple example function.",
  table(
    columns: 2,

    table.header([*Variable*], [*Value*]),

    $v_(-1) = x_1$, $pi$,

    $v_0 = x_2$, $2$,

    $v_1 = sin(v_(-1))$, $0$,

    $v_2 = v_(-1) v_0$, $2 pi$,

    $v_3 = v_0$, $2$,

    $v_4 = v_1 - v_2$, $-2 pi$,

    $v_5 = v_4 + v_3$, $2 - 2 pi$,

    $y_0 = v_5$, $2 - 2 pi$,
  ),
) <tab:evaluation_trace>

We can extend the evaluation trace with _computational graph_. That is a
directed acyclic graph (DAG) in which vertices represent variables and edges
functions. The graph must be directed and acyclic to ensure the correct flow of
computation.

Computational graph is fundamental for our understanding and as a data structure
in which can the evaluation trace be algorithmically represented.

Let us build a computational graph for the very same example function from
@eq:evaluation_trace. Note that is strongly corresponds with
@tab:evaluation_trace.

#figure(
  caption: "Computational graph for simple example function.",

  diagram(
    node-shape: circle,
    node-fill: none,
    node-stroke: 1pt + black.transparentize(60%),
    spacing: (25pt, 15pt),
    let text-size = 8pt,

    let my-node(pos, name, id, ..args) = {
      node(
        pos,
        text(text-size, name),
        name: id,
        width: 10pt,
        height: 10pt,
        inset: 5pt,
        ..args,
      )
    },

    let my-edge = edge.with(marks: "->"),

    let my-label(origin-pos, name, id, ..args) = {
      let up = (0, -0.58)
      let pos = (origin-pos.at(0) + up.at(0), origin-pos.at(1) + up.at(1))

      node(
        pos,
        text(text-size, name),
        name: id,
        stroke: none,
        inset: 0pt,
        outset: 0pt,
      )
      // my-node(pos, name, id, stroke: blue, width: 55pt, inset: 0pt)
    },

    // input variables
    my-node((0, 0), $x_1$, "x1", stroke: none),
    my-node((0, 3), $x_2$, "x2", stroke: none),

    // intermediate vars (grouped by column)
    my-node((1, 0), $v_(-1)$, "v-1"),
    my-node((1, 3), $v_0$, "v0"),

    let pos_v1 = (2, 0.25),
    my-node(pos_v1, $v_1$, "v1"),
    let pos_v2 = (2, 1.5),
    my-node(pos_v2, $v_2$, "v2"),

    let pos_v3 = (3, 2.5),
    my-node(pos_v3, $v_3$, "v3"),
    let pos_v4 = (3, 1),
    my-node(pos_v4, $v_4$, "v4"),

    let pos_v5 = (4, 1.4),
    my-node(pos_v5, $v_5$, "v5"),

    // output vars
    my-node((5, 1.5), $y_0$, "y0", stroke: none),

    // EDGES

    // input vars
    my-edge(<x1>, <v-1>),
    my-edge(<x2>, <v0>),

    // intermediate vars (grouped by source)
    my-edge(<v-1>, <v1>),
    my-edge(<v-1>, <v2>),

    my-edge(<v0>, <v2>),
    my-edge(<v0>, <v3>),

    my-edge(<v1>, <v4>),

    my-edge(<v2>, <v4>),

    my-edge(<v3>, <v5>),

    my-edge(<v4>, <v5>),

    // output vars
    my-edge(<v5>, <y0>),

    // LABELS

    my-label(pos_v1, $sin(v_(-1))$, none),

    my-label(pos_v2, $v_(-1) v_0$, none),

    my-label(pos_v3, $v_0$, none),

    my-label(pos_v4, $v_1 - v_2$, none),

    my-label(pos_v5, $v_4 + v_3$, none),
  ),
) <diag:computational_graph>

Decomposition of differentials provided by the chain rule of partial derivatives
of composite functions connects the previous concepts and is fundamental for
autodiff. One example for function $y(x) = (f compose g compose h)$. The
variables $v_i$ corresponds with the naming in evaluation trace.
$
  y = f(g(h(x))) = f(g(h(v_0))) = f(g(v_1)) = f(v_2) = v_3 \
  (partial y) / (partial x) = (partial y) / (partial v_2) (partial v_2) /
  (partial v_1) (partial v_1) / (partial x) \
  (partial y) / (partial x) = (partial f(v_2)) / (partial v_2) (partial g(v_1))
  / (partial v_1) (partial h(v_0)) / (partial v_0)
$ <eq:diff_decomposition>

TODO: "jediný" rozdíl mezi FM/BM je pořadí derivací v chain rule - dá se
vysvětlit i jako pořadí násobení jakobiánů

To summarize, autodiff makes use of function (de)composition, chain rule and
utilizes computational graph. Similarily to symbolic method it requires a set of
known derivatives, although it does not need rules as it implicitely works with
chain rule.

== Forward mode: The tangent linear mode

In forward mode the differential decomposition (chain rule) is computed from the
inside out (i.e. first is computed the rightmost element $(partial v_1) /
(partial x)).$ This mode uses this chain rule recursive relation:
$
  (partial v_i) / (partial x) = (partial v_i) / (partial v_(i-1)) (partial
  v_(i-1)) / (partial x), quad v_n = y
$

If this relation is further expanded it gives:
$
  (partial y) / (partial x) & = (partial y) / (partial v_(n-1)) (partial
                              v_(n-1)) / (partial x) \
                            & = (partial y) / (partial v_(n-1)) ( (partial
                                v_(n-1)) / (partial v_(n-2)) (partial v_(n-2)) /
                                (partial x) ) \
                            & = (partial y) / (partial v_(n-1)) ( (partial
                                v_(n-1)) / (partial v_(n-2)) ( (partial v_(n-2))
                                  / (partial v_(n-3)) (partial v_(n-3)) /
                                  (partial x) ) ) \
                            & = ...
$
Which is exactly the bottom-up (or inside-out) approach. Let us see on an
example how it works. We will use the evaluation trace augmented of the value of
partial derivative (often called tangent). We use the same function as in
@eq:evaluation_trace and we are computing the partial derivative $(partial y) /
(partial x_1)$.
$
  y = f(x_1, x_2) = sin(x_1) - x_1 x_2 + x_2 \
  x_1 = pi, quad x_2 = 2 \
  dot(x)_1 = (partial x_1) / (partial x_1) = 1,
  quad dot(x)_2 = (partial x_2) / (partial x_1) = 0
$

#figure(
  caption: "Evaluation trace for simple example partial derivative.",
  table(
    columns: 4,

    table.header([*Variable*], [*Value*], [*Tangent*], [*Value*]),

    $v_(-1) = x_1$, $pi$, $dot(v)_(-1) = dot(x)_1$, $1$,

    $v_0 = x_2$, $2$, $dot(v)_0 = dot(x)_2$, $0$,

    $v_1 = sin(v_(-1))$, $0$, $dot(v)_1 = cos(v_(-1))$, $cos(pi) = -1$,

    $v_2 = v_(-1) v_0$,
    $2 pi$,
    $dot(v)_2 = dot(v)_(-1) v_0 +
    v_(-1) dot(v)_0$,
    $1 dot 2 + pi dot 0 = 2$,

    $v_3 = v_0$, $2$, $dot(v)_3 = dot(v)_0$, $0$,

    $v_4 = v_1 - v_2$, $-2 pi$, $dot(v)_4 = dot(v)_1 - dot(v)_2$, $-1 - 2 = -3$,

    $v_5 = v_4 + v_3$,
    $2 - 2 pi$,
    $dot(v)_5 = dot(v)_4 + dot(v)_3$,
    $-3 + 0 =
    -3$,

    $y_0 = v_5$, $2 - 2 pi$, $dot(y)_0 = dot(v)_5$, $-3$,
  ),
) <tab:evaluation_trace_partial_derivative>

TODO: důležitý je "přenášení" derivací spolu s hodnotou ve výpočtu

TODO: duální čísla #sym.epsilon^2 = 0 jako další matematický pohled na věc

TODO: vhodné pro málo vstupů, hodně výstupů - pro každý vstup třeba další
průchod

== Backward mode: The adjoint mode

TODO: potřeba dva průchody - první k vytvoření výpočetního grafu a zpětný k
tomu, abychom viděli jak který vstup kontributuje k výsledné hodnotě (kterou si
zvolíme) -> víc paměti. taky VJP (vector jacobian product) - a na tom ukázat,
že je vhodné pro mnoho vstupů a málo výstupů (vs forward mode)


== Computational complexity

TODO: časová a paměťová komplexita, porovnání s ostatními metodami

= Minimal implementation

TODO: jak dát do kódu, python - fundamentální rozdíl mezi FMode a BM

== Forward mode

TODO: + vysvětlení pomocí duálních čísel, přetížení standardních algebraických
operací tak, aby se přenášela i derivace

== Backward mode

TODO: + vysvětlení jak se používá computational graf k zpětnému chodu

= Using existing autodif libraries in python

TODO: předpokládám python + pytorch, tensorFlow

= Conclusion

TODO: jak cca funguje autodif, k čemu je dobrá (výhody oproti FD a symbolic),
důležitost pro reálné aplikace, limitace

= Further reading

TODO: list mých zdrojů s lepším popisem, pro ty, které by zajímalo víc

@enwiki:autodif
@huggingface:autodif
@dlsyscourse

