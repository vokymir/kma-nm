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

=== Metoda bisekce (půlení intervalů)
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

=== Regula-Falsi
- výhody:
 - rychlejší, než bisekce (zmenší interval o víc, než polovinu)

- algoritmus:
 - stejný jako bisekce, akorát $s$ se vybírá jako průsečík úsečky ab a osy x

== Zpřesňující metody

=== Metoda prosté iterace
- hlavní princip: původní funkci $f(x) = 0$ přepíšeme do tvaru $x = phi(x)$
 - může být více možností, jedna horší, než druhá

- grafické řešení: když nakreslíme $y = x quad y = phi(x)$ řešení bude tam, kde
  se grafy protnou
 - Moon: jasně, když to spojíme, máme zase $x = phi(x)$

- algoritmus:
 + zadáme $x_0 in chevron.l a,b chevron.r, epsilon gt 0$
 + $x_(k+1) = phi(x_k)$
 + je-li $abs(x_(k+1) - x_k) lt epsilon$ pak $tilde(x) = x_(k+1)$, KONEC
   jinak jdi na krok 2
 pro zastavovací podmínku: rozdíl dvou po sobě jdoucích řešení

- největší problém metody je nalezení předpisu $phi = phi(x)$ tak, aby metoda
  konvergovala (chceme, aby $phi(x)$ bylo ideálně konstantní, derivace nulová)

==== Postačující podmínky konvergence metody prosté iterace:
- předpoklad: $phi$ je spojitá na $I = chevron.l a,b chevron.r$

 #set enum(numbering: "a)") // specifically needed
 + $forall x in I: phi(x) in I$ #h(1cm) (funkce $phi$ zobrazuje $I$ do sebe)
 + $exists q in chevron.l 0,1): quad abs(phi(x) - phi(y)) lt.eq q abs(x - y) quad forall
   x,y in I$ #h(1cm) (funkce není moc strmá, je mezi $y = plus.minus x$, pokud
   je derivovatelná, pak derivace je neostře menší než $q$)
 #set enum(numbering: "1.") // back to default

- pokud jsou podmínky splněny, pak:
 + v intervalu $I$ $exists!$ kořen $x$ rovnice $x = phi(x)$


















