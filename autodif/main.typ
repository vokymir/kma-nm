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

= Automatic differentiation method

TODO: že existují dvě varianty, začneme dopřednou a pak uvidíme jak se to vyvine

== Intuitive introduction to autodiff

TODO: jak a proč autodif funguje

== Formal explanation

TODO: proč to funguje, teorie za tím, výpočetní graf

== Computional complexity

TODO: časová a paměťová komplexita, porovnání s ostatními metodami

= Minimal implementation

TODO: jak dát do kódu, python - informatici ohrnou nos, ale pochopí většina
faváků

== Forward mode

TODO: + vysvětlení duálních čísel??

== Backward mode

TODO: + vysvětlení jak se používá computational graf k zpětnému chodu

= Using existing autodif libraries

TODO: předpokládám python + pytorch, tensorFlow

= Conclusion

TODO: jak cca funguje autodif, k čemu je dobrá (výhody oproti FD a symbolic),
důležitost pro reálné aplikace, limitace

= Further reading

TODO: list mých zdrojů s lepším popisem, pro ty, které by zajímalo víc

@enwiki:autodif
@huggingface:autodif
@dlsyscourse

