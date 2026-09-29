## Projektowanie diagramów ERD

### Cele zajęć
* poznanie notacji ERD (encje, związki, kardynalność: 1:1, 1:N, N:M),
* zaprojektowanie własnego rozszerzenia bazy "sklep" w narzędziu dbdiagram.io.

### Narzędzie
[dbdiagram.io](https://dbdiagram.io) — darmowe, w przeglądarce, diagram opisuje się prostym DSL (DBML), można eksportować do SQL i obrazka. Nie wymaga instalacji.

Przykład zapisu DBML (fragment istniejącego schematu sklepu, dla orientacji w składni):
```dbml
Table produkty {
  id integer [primary key]
  nazwa varchar
  kategoria_id integer
  cena decimal
}

Table kategorie {
  id integer [primary key]
  nazwa varchar
}

Ref: produkty.kategoria_id > kategorie.id
```

### Zadanie: rozszerzenie sklepu
Każdy student projektuje **własne, inne rozszerzenie** istniejącej bazy sklepu (personalizacja mimo wspólnej bazy bazowej). Rozszerzenie musi:
* logicznie łączyć się z istniejącym schematem (min. 1 `FOREIGN KEY` do istniejącej tabeli: `produkty`, `klienci`, `zamowienia`...),
* zawierać **min. 2 nowe tabele**,
* zawierać **obowiązkowo relację N:M** (czyli tabelę łączącą / pośredniczącą),
* być zgodne z zasadami normalizacji (3NF).

Przykładowe pomysły rozszerzeń (wybierz inny niż osoby obok, lub wymyśl własny):
* **opinie/recenzje** — klient ocenia produkt (N:M klienci↔produkty przez `recenzje`),
* **promocje/rabaty** — produkt może być objęty wieloma promocjami, promocja dotyczy wielu produktów,
* **dostawcy** — produkt może mieć wielu dostawców, dostawca dostarcza wiele produktów,
* **program lojalnościowy** — klienci zbierają punkty, punkty przypisane do konkretnych zamówień/nagród,
* **zwroty** — zwrot dotyczy jednej lub wielu pozycji zamówienia, z powodem i statusem,
* **listy życzeń** — klient może mieć wiele produktów na liście, produkt może być na wielu listach (N:M).

### Przykład szkicu ERD (rozszerzenie: promocje)
```dbml
Table promocje {
  id integer [primary key]
  nazwa varchar
  rabat_procent decimal
  data_od date
  data_do date
}

Table produkty_promocje {
  produkt_id integer
  promocja_id integer
}

Ref: produkty_promocje.produkt_id > produkty.id
Ref: produkty_promocje.promocja_id > promocje.id
```
`produkty_promocje` to tabela łącząca (N:M) — produkt może mieć wiele promocji, promocja obejmuje wiele produktów.

### Zadania do wykonania
1. Wybierz temat rozszerzenia (inny niż koledzy/koleżanki obok, jeśli to możliwe).
2. Zaprojektuj diagram w dbdiagram.io: min. 2 nowe tabele, min. 1 relacja N:M, min. 1 FK do istniejącego schematu sklepu.
3. Sprawdź kardynalności związków — czy na pewno N:M, a nie 1:N (częsty błąd projektowy).
4. Wyeksportuj diagram (PNG lub link publiczny do dbdiagram.io).

### Co oddajemy
* eksport ERD (obrazek lub link),
* krótki opis (2-3 zdania) — co reprezentuje rozszerzenie i dlaczego wybrane relacje są takie, a nie inne.

Implementacja tego projektu w SQL — na następnych zajęciach (lab08).
