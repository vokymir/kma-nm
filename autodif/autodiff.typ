// template
#import "@preview/charged-ieee:0.1.4": ieee

// library to create graphs
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

// highlight all TODOs, which is WOW, easy yet not
#show regex("TODO(.*)"): it => text(fill: red, weight: "bold")[#it]

// #bibliography("refs.bib")
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

#let pp(f, ..sink) = {
  if f == [] { f = none }
  let (args, kwargs) = (sink.pos(), sink.named())

  let x = none
  if (args.len() >= 1) { x = args.at(0) }

  $(partial #f) / (partial #x)$
}

#show raw.where(block: true): set text(0.86em)

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

    [*Accuracy*], [approximation], [exact],

    [*Cost*], [$O(n)$], [high],

    [*Implementation*], [easy], [moderate],

    [*Disadvantages*], [$h arrow 0$:unstable, \ $epsilon$-sensitive], [expression swell],
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

    $y_1 = v_5$, $2 - 2 pi$,
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
    my-node((5, 1.5), $y_1$, "y1", stroke: none),

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
    my-edge(<v5>, <y1>),

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
  pp(y, x) = pp(y, v_2) pp(v_2, v_1) pp(v_1, x) \
  pp(y, x) = pp(f(v_2), v_2) pp(g(v_1), v_1) pp(h(v_0), v_0)
$ <eq:diff_decomposition>

TODO: "jediný" rozdíl mezi FM/BM je pořadí derivací v chain rule - dá se
vysvětlit i jako pořadí násobení jakobiánů

To summarize, autodiff makes use of function (de)composition, chain rule and
utilizes computational graph. Similarily to symbolic method it requires a set of
known derivatives, although it does not need rules as it implicitely works with
chain rule.

== Forward mode: The tangent linear mode

In forward mode the differential decomposition (chain rule) is computed from the
inside out (i.e. first is computed the rightmost element $pp(v_1, x)).$ This mode uses this chain rule recursive relation:
$
  pp(v_i, x) = pp(v_i, v_(i-1)) pp(v_(i-1), x), quad v_n = y
$

If this relation is further expanded it gives:
$
  pp(y, x) & = pp(y, v_(n-1)) pp(v_(n-1), x) \
           & = pp(y, v_(n-1)) ( pp(v_(n-1), v_(n-2)) pp(v_(n-2), x) ) \
           & = pp(y, v_(n-1)) ( pp(v_(n-1), v_(n-2)) ( pp(v_(n-2), v_(n-3)) pp(v_(n-3), x) ) ) \
           & = ...
$
Which is exactly the bottom-up (or inside-out) approach. Let us see on an
example how it works. We will use the evaluation trace augmented of the value of
partial derivative (often called tangent). We use the same function as in
@eq:evaluation_trace and we are computing the partial derivative $pp(y, x_1)$.
$
  y = f(x_1, x_2) = sin(x_1) - x_1 x_2 + x_2 \
  x_1 = pi, quad x_2 = 2 \
  dot(x)_1 = pp(x_1, x_1) = 1,
  quad dot(x)_2 = pp(x_2, x_1) = 0
$

#figure(
  caption: "Evaluation trace for simple example partial derivative.",
  table(
    columns: 4,

    table.header([*Variable*], [*Value*], [*Tangent*], [*Tangent Value*]),

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

    $y_1 = v_5$, $2 - 2 pi$, $dot(y)_1 = dot(v)_5$, $-3$,
  ),
) <tab:evaluation_trace_partial_derivative>

This is the essence of forward mode autodiff: At every step calculate the
elementary operation as well as the derivatives. Both operations use simple
arithmetics or known derivatives therefore the precision is only influenced by
computer precision.

In the example it is not evident because the function projects $RR^2 arrow RR$,
but we did calculate a column in Jacobian matrix. General Jacobian matrix is
reminded in @eq:jacobian.
$
  JJ = mat(
    delim: "[",
    pp(y_1, x_1), dots, pp(y_1, x_n);
    dots.v, dots.down, dots.v;
    pp(y_m, x_1), dots, pp(y_m, x_n);
  )
$ <eq:jacobian>

Jacobian matrix of our example function is the shape of $1 times 2$. If we fill
in the known value we get:
$
  JJ = mat(
    delim: "[",
    pp(y_1, x_1), pp(y_1, x_2);
  )
  = mat(
    delim: "[",
    -3, pp(y_1, x_2);
  )
$ <eq:jacobian_example_function>

This beautifully demonstrates the important attribute of the autodiff forward
method: It is extremely useful for differentiating functions with few inputs and
many outputs. As you know, for function $f: RR^n arrow RR^m$ its Jacobian matrix
shape is $m times n$. For $n << m$ this mode of autodiff method is the more
effective as it requires only $n$ passes.


== Backward mode: The adjoint mode

With the backward mode, two passes are needed. The first serves to create the
evaluation trace and computational graph and is performed as in forward mode.
The second pass traverses the graph backwards. This mode uses this chain rule
recursive relation:

$
  pp(y, v_i) = pp(y, v_(i+1)) pp(v_(i+1), v_i), quad v_0 = x
$ <eq:reverse_mode_recursive_formula>

Which expanded looks like this:

$
  pp(y, x) & = pp(y, v_1) pp(v_1, x) \
           & = ( pp(y, v_2) pp(v_2, v_1) ) pp(v_1, x) \
           & = (( pp(y, v_3) pp(v_3, v_2) ) pp(v_2, v_1) ) pp(v_1, x) \
           & = ...
$

And if we define an adjoint for a function $f: RR^n arrow RR^m$ where $i =
1,...,n$ and $j = 1,...,m$ as:

$
  dash(v)_i = pp(y_j, v_i)
$

We can rewrite the expanded relation as:

$
  pp(y, x) & = dash(v)_1 pp(v_1, x) \
           & = ( dash(v)_2 pp(v_2, v_1) ) pp(v_1, x) \
           & = (( dash(v)_3 pp(v_3, v_2) ) pp(v_2, v_1) ) pp(v_1, x) \
           & = ...
$

We will differentiate the same example function. Similarily to forward mode, we
must select a variable to derivate by. In forward mode, it is one of income
variables, in reverse mode it is one of output variables. In our case, we only
have one output variable so it simplifies.

$
  y = f(x_1, x_2) = sin(x_1) - x_1 x_2 + x_2 \
  x_1 = pi, quad x_2 = 2 \
  dot(y)_1 = 1
$


#figure(
  caption: "Evaluation trace for reverse mode.",
  table(
    columns: 4,

    table.header([*#sym.arrow.b Variable*], [*Value*], [*#sym.arrow.t Adjoint*], [*Adjoint Value*]),

    $v_(-1) = x_1$,
    $pi$,
    $dash(v)_(-1) = dash(x)_1 = \ dash(v)_1 dot
    cos(v_(-1)) + dash(v)_2 dot v_0$,
    $1 dot cos(pi) + (-1) dot 2\ = -1 -2 = -3$,

    $v_0 = x_2$,
    $2$,
    $dash(v)_0 = dash(x)_2 = \ dash(v)_3 + dash(v)_2 dot
    v_(-1)$,
    $1 + (-1) dot pi \ = 1 - pi$,

    $v_1 = sin(v_(-1))$, $0$, $dash(v)_1 = dash(v)_4 dot 1$, $1 dot 1 = 1$,

    $v_2 = v_(-1) v_0$, $2 pi$, $dash(v)_2 = dash(v)_4 dot -1$, $1 dot -1 = -1$,

    $v_3 = v_0$, $2$, $dash(v)_3 = dash(v)_5 dot 1$, $1 dot 1 = 1$,

    $v_4 = v_1 - v_2$, $-2 pi$, $dash(v)_4 = dash(v)_5 dot 1$, $1 dot 1 = 1$,

    $v_5 = v_4 + v_3$, $2 - 2 pi$, $dash(v)_5 = dash(y)_1$, $1$,

    $y_1 = v_5$, $2 - 2 pi$, $dash(y)_1$, $1$,
  ),
) <tab:evaluation_trace_partial_derivative_reverse_mode>

The explanation of this example is necessary. After constructing the forward
evaluation trace and computational graph (the two left columns, already
calculated in previous examples), we start with the adjoint $dash(y)_1 = 1$.

We must propagate the adjoint $dash(y)_1$ to all variables which caused it. In
this case, only to $v_5$. This can be found in the table as $y_1 = v_5$ or in
computational graph as all vertices pointing to $y_1$.

The steps for $v_5$ are similar, except now the dependencies of it are $v_4,
v_3$. This means we will add to both how much they contribute. For $dash(v)_4 =
dash(v)_5 dot pp(v_4, v_4)$ using the recursive formula
@eq:reverse_mode_recursive_formula. The $dash(v)_5$ is there, because $v_4$
contributed to $v_5$. In the partial we are derivating $v_4$ with respect to
$v_4$. The former comes from the equation $v_5 = v_4 + v_3$ where no additional
functions are applied to it. The latter signifies that we are calculating the
$dash(v)_5$ adjoint.

We are essentially deducing how much every variable contributed to the one
output variable we set to one. If one variable contributed more than once (in
the computational graph have two or more arrows pointing outwards/right) we need
to add all its contributions up. That applies to $v_0$ and $v_(-1)$. We will
skip all the intermediate steps because they are very similar to that already
seen.

When calculating $dash(v)_0$, we must add its contribution from $dash(v)_3$ and
$dash(v)_2$. While $dash(v)_3$ is trivial, the other variable displays new
behaviour. When expanded: $dash(v)_2 dot pp(( v_(-1) v_0), v_0)$ we can see that
it is only the result of product rule.

If we were to write this down in jacobian matrix, we would get:

$
  JJ = mat(
    delim: "[",
    pp(y_1, x_1), pp(y_1, x_2);
  )
  = mat(
    delim: "[",
    -3",", 1-pi;
  )
$

Where we can see, that in backward mode while we must do one forward pass on the
beginning, we than get one row of jacobian matrix on every backward pass.

== Computational complexity

Now we can compare both modes of autodiff with previously known methods. We will
base it on @tab:comparison_fd_sym.

#figure(
  caption: "Comparison between methods.",
  table(
    columns: 5,

    table.header([*Property*], [*FD*], [*Sym*], [*AD (FM)*], [*AD (BM)*]),

    [*Accuracy*], [approximation], [exact], [exact], [exact],

    [*Cost*], [$O(n)$], [high], [moderate], [moderate],

    [*Implementation*], [easy], [moderate], [moderate], [moderate],

    [*Disadvantages*], [unstable], [expression swell], [memory overload], [control-flow complexity],
  ),
) <tab:comparison_with_ad>

The main drawback for autodiff (especially backward mode) is the high memory
usage. It needs to hold the computational graph which could be rather large.

= Minimal implementation

Following sections demonstrate how could autodiff be naively implemented inside
`python`. In implementation of both modes, the same example function is used as
previously.

#colbreak()
== Forward mode
#figure(
  caption: "Forward mode autodiff naive implementation in python.",
  ```py
  import math

  class Variable:

      def __init__(self, value, tangent):
          self.value = value
          self.tangent = tangent

      def __add__(self, other):
          value = self.value + other.value
          tangent = self.tangent + other.tangent
          return Variable(value, tangent)

      def __sub__(self, other):
          value = self.value - other.value
          tangent = self.tangent - other.tangent
          return Variable(value, tangent)

      def __mul__(self, other):
          value = self.value * other.value
          tangent = self.tangent * other.value + \
                    other.tangent * self.value
          return Variable(value, tangent)

      def __repr__(self):
          return f"(value: {self.value}," \
                 f" tangent: {self.tangent})"

  # only works if x is of type Variable
  def sin(x):
      return Variable(
              math.sin(x.value),
              math.cos(x.value))

  x1 = Variable(math.pi, 1.0)
  x2 = Variable(2.0, 0.0)
  y = sin(x1) - x1 * x2 + x2

  print(f"{x1 = },\n{x2 = }")
  print(f"{y = }")
  ```,
)

In the code above can be seen the principle of forward mode: The function is
evaluated and the partial is computed along at the same time.

The program creates a new data type (`Variable`) and via functions determine how
it responds to standard operators $(+,-,dot)$. The function for sinus is created
in the same way. The function `__init__` explains python how to initialize the
variable, `__repr__` tells it how to represent it in text.

The output of this program is:
#figure(
  caption: "The output of FM autodiff example.",
  ```
  x1 = (value: 3.141592653589793, tangent: 1.0),
  x2 = (value: 2.0, tangent: 0.0)
  y = (value: -4.283185307179586, tangent: -3.0)
  ```,
)

Which gives to show that these results are the same as ours previously ($2 - 2pi
approx -4.28$). Note that we decided that the partial would be calculated with
respect to $x_1$ simply by setting its tangent to $1$.

#colbreak()
== Backward mode

```py
import math

class Variable:

    def __init__(self, value, adjoint=0.0):
        self.value = value
        self.adjoint = adjoint

    def backward(self, adjoint):
        self.adjoint += adjoint

    def __add__(self, other):
        variable = \
          Variable(self.value + other.value)

        def backward(adjoint):
            variable.adjoint += adjoint
            self_adjoint = adjoint * 1.0
            other_adjoint = adjoint * 1.0
            #
            self.backward(self_adjoint)
            other.backward(other_adjoint)

        variable.backward = backward
        return variable

    def __sub__(self, other):
        variable = \
          Variable(self.value - other.value)

        def backward(adjoint):
            variable.adjoint += adjoint
            self_adjoint = adjoint * 1.0
            other_adjoint = adjoint * -1.0
            #
            self.backward(self_adjoint)
            other.backward(other_adjoint)

        variable.backward = backward
        return variable

    def __mul__(self, other):
        variable = \
          Variable(self.value * other.value)

        def backward(adjoint):
            variable.adjoint += adjoint
            self_adjoint = adjoint * other.value
            other_adjoint = adjoint * self.value
            #
            self.backward(self_adjoint)
            other.backward(other_adjoint)

        variable.backward = backward
        return variable


    def __repr__(self) -> str:
        return f"(value: {self.value}," \
               f" adjoint: {self.adjoint})"


def sin(x):
    variable = Variable(math.sin(x.value))

    def backward(adjoint):
        variable.adjoint += adjoint
        x.backward(adjoint * math.cos(x.value))

    variable.backward = backward
    return variable


x1 = Variable(math.pi)
x2 = Variable(2.0)

y = sin(x1) - x1 * x2 + x2
y.backward(1.0)

print(f"{x1 = },\n{x2 = }")
print(f"{y = }")
```

The backward mode requires more complex implementation. We created a data type
of `Variable` again, but this time it has function `backward()`, which is used
to accumulate all contributions. However, this function is overwritten when
mathematical operation is applied to the variable.

For example, when the multiplication takes place, it creates new variable to
hold the value (forward pass) as well to hold the backward function. And the
backward function is nothing special, it just specifies how adjoint is
calculated. It uses the same principle as shown in
@tab:evaluation_trace_partial_derivative_reverse_mode.

#figure(
  caption: "The output of BM autodiff example.",
  ```
  x1 = (value: 3.141592653589793, adjoint: -3.0),
  x2 = (value: 2.0, adjoint: -2.141592653589793)
  y = (value: -4.283185307179586, adjoint: 1.0)
  ```,
)

Please note, that it calculated the jacobian row $mat(delim: "[", -3",", 1-pi;)$
as adjoints of $x_1, x_2$. The other interesting thing is that in order to
compute that, we needed to call `backawrd()` method on the `y` variable. That
call started a recursive process which filled adjoints of all variables.

#colbreak()
= Using existing autodif libraries in python

More realistic use of autodiff is via library. In this example we are using
PyTorch for both forward and backward mode.

#figure(
  caption: "Autodiff using pytorch.",
  ```py
  import torch
  from torch.func import jacfwd

  # function: y = sin(x1) - x1*x2 + x2
  def f(x):
      x1, x2 = x
      return torch.sin(x1) - x1 * x2 + x2

  # input
  x = torch.tensor([torch.pi, 2.0], requires_grad=True)

  # FM
  jac_fwd = jacfwd(f)(x)

  # BM
  y = f(x)
  y.backward()
  grad_rev = x.grad

  print("FM:")
  print(jac_fwd)

  print("\nBM:")
  print(grad_rev)py
  ```,
)

We defined a function `f(x)` because pytorch requires function with only one
variable input. That is why we _unpack_ it into `x1, x2` and use in the same
function as previously. Then we prepare these under `# input`.

For forward mode pytorch provides a function `jacfwd` (Jacobian using forward
mode) which needs the function and the input variables. Similar to our
implementation, but it does two passes to calculate both columns in the
jacobian.

For the backward mode we define the output variable `y`, call backward on it and
we are interested in adjoints in `x`, which is stored as `x.grad`. When we print
these, we get:

#figure(
  caption: "The output of PyTorch autodiff.",
  ```
  FM:
  tensor([-3.0000, -2.1416], grad_fn=<ViewBackward0>)

  BM:
  tensor([-3.0000, -2.1416])
  ```,
)


= Conclusion

TODO: jak cca funguje autodif, k čemu je dobrá (výhody oproti FD a symbolic),
důležitost pro reálné aplikace, limitace

= Further reading

TODO: list mých zdrojů s lepším popisem, pro ty, které by zajímalo víc

@enwiki:autodif
@huggingface:autodif
@dlsyscourse

