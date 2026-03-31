#import "@preview/charged-ieee:0.1.4": ieee

#show: ieee.with(
  title: [Automatic Differentiation],
  abstract: [
  This paper provides an explanation of Automatic Differentiation (AD) concept
  for univerity students at near-bachelor level. Includes comparision with other
  differentiation methods, very simple AD implementation example and more
  realistic usage in python library.
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

= Introduction

TODO: co je to za problém ta derivace, diferenciace, motivačně kde všude se hodí
a proč, jak se počítá ručně

= Background

TODO: proč se na to hodí použít počítač, fundamentální problém (zdrojový kód
přesně nekopíruje matematické funkce), možná zase motivace

= Alternative differentiation methods

TODO: že existují nějaký další metody, na něco se hodí možná

== Finite difference method

TODO: co je FD (finite difference) metoda, jak funguje, plusy a minusy

== Symbolic method

TODO: co je symbolická metoda, jak funguje, plusy a minusy

== Comparison

TODO: tabulka s porovnáním + vysvětlení proč

= Automatic differentiation

TODO: že existují dvě varianty, začneme tím, co mají společného

== Core principles

TODO: proč to funguje, teorie za tím

TODO: chain rule, výpočetní graf, potřeba mít známé funkce a jejich derivace

TODO: "jediný" rozdíl mezi FM/BM je pořadí derivací v chain rule - dá se
vysvětlit i jako pořadí násobení jakobiánů

== Forward mode: The tangent linear mode

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

