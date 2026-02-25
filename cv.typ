= Nelineární rovnice

Pro funkci $f: RR arrow RR$ hledáme na intervalu $I = chevron.l a, b chevron.r$ řešení, kterým
je kořen rovnice:
$
f(x)=0, quad x in chevron.l a,b chevron.r
$

- využíváme neanalytické metody, protože nedokážeme získat přesné (analytické)
- používáme iterační metody, důležitá je zastavovací podmínka, konvergence a rychlost konvergence (abychom nečekali věčně)

== Metody řešení se dělí na:
+ startovací metody (vždy konvergují, avšak většinou pomalu)
+ zpřesňující metody (pokud konvergují, tak zpravidla rychleji)
+ speciální (například pro polynomy, v NM neřešíme)

== Předpoklady
+ $f(x)$ je spojitá pro $x in chevron.l a,b chevron.r$
+ $f(a)$ má opačné znaménko k $f(b)$: $f(a) dot f(b) < 0$

Důsledkem těchto předpokladů je existence alespoň jednoho řešení $x$ rovnice
$f(x)=0$ na intervalu $I = chevron.l a,b chevron.r$.

== Poznámky
- pokud je $x$ přesný výsledek, pak je $tilde(x)$ numericky získané řešení

== Startovací metody

+ Metoda bisekce (půlení intervalů)
 - výhody:
  - jednoduchý odhad chyby, přímo z $epsilon$
  - jednoduchý odhad kroků iterace, víceméně logaritmus přesnosti
 - algoritmus:
  + zadáme $epsilon > 0, a, b$
  + $s = (a+b)/2$
  + je-li $f(s) = 0$ pak $tilde(x) = s$, KONEC
  + je-li $f(a) dot f(s) < 0$ pak $b = s$
    jinak $a = s$
  + je-li $b - a gt.eq epsilon$ pak jdi na krok 2
    jinak $tilde(x) = (a + b)/2$, KONEC
 - Moon: vždycky napůlíme interval a pokračujeme s tou půlkou, ve které se mění
   znaménko (= protíná osu x) - a to tak dlouho, dokud se omylem netrefíme do x (bod 3), nebo mu nejsme dostatečně blízko

+ Regula-Falsi
 - výhody:
  - rychlejší, než bisekce (zmenší interval o víc, než polovinu)
 - algoritmus:
  - stejný jako bisekce, akorát $s$ se vybírá jako průsečík úsečky ab a osy x
