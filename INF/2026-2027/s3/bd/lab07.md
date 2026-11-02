## Projektowanie diagramów ERD

### Cele zajęć
* poznanie notacji ERD (encje, związki, kardynalność: 1:1, 1:N, N:M),
* zaprojektowanie własnego rozszerzenia bazy "sklep" w narzędziu dbdiagram.io.

### Wyjaśnienie pojęć
**ERD** (Entity-Relationship Diagram) to diagram pokazujący, jakie dane przechowuje system i jak są ze sobą powiązane. Rysuje się go przed pisaniem SQL, bo poprawka na diagramie jest znacznie tańsza niż zmiana działającej bazy z danymi.

Przykłady w tej sekcji pochodzą z uczelni.

#### Encje i atrybuty
**Encja** to rodzaj obiektu, o którym chcemy przechowywać dane, np. student lub kurs. Zwykle odpowiada jej jedna tabela. **Atrybuty** to cechy encji, np. nazwisko studenta, i odpowiadają im kolumny.

Na diagramie zaznacza się też klucze: główny (PK), który jednoznacznie identyfikuje wiersz, oraz obcy (FK), który wskazuje wiersz w innej tabeli.

#### Związki i kardynalność
**Związek** opisuje powiązanie między encjami. **Kardynalność** określa, ile obiektów jednej encji może być powiązanych z obiektem drugiej. Od niej zależy, gdzie trafi klucz obcy:

| Kardynalność | Znaczenie | Przykład | Realizacja w tabelach |
|---|---|---|---|
| 1:1 | jeden do jednego | student ↔ legitymacja | FK z `UNIQUE` w jednej z tabel |
| 1:N | jeden do wielu | wydział → studenci | FK po stronie "wielu" (`studenci.wydzial_id`) |
| N:M | wiele do wielu | studenci ↔ kursy | osobna tabela łącząca z dwoma FK |

Związek może być też opcjonalny, np. student może jeszcze nie mieć legitymacji. W tabeli oznacza to kolumnę FK dopuszczającą `NULL`, a związek obowiązkowy to FK z `NOT NULL`.

#### Jak ustalić kardynalność
Zadaj pytanie w **obu** kierunkach i porównaj odpowiedzi:

| Pytanie 1 | Pytanie 2 | Wynik |
|---|---|---|
| Ilu kursów może uczyć się jeden student? Wielu. | Ilu studentów może być na jednym kursie? Wielu. | N:M |
| Do ilu wydziałów należy jeden student? Do jednego. | Ilu studentów ma jeden wydział? Wielu. | 1:N |
| Ile legitymacji ma jeden student? Jedną. | Do ilu studentów należy jedna legitymacja? Do jednego. | 1:1 |

Częsty błąd to pytanie tylko w jednym kierunku. Wtedy N:M wygląda jak 1:N, a do tabeli `studenci` trafia kolumna `kurs_id`, która pozwala zapisać studenta tylko na jeden kurs.

Odpowiedź zależy też od reguł systemu. Jeśli student może studiować na dwóch wydziałach naraz, związek student-wydział staje się N:M.

#### Tabela łącząca
Związku N:M nie da się zapisać jednym kluczem obcym, bo komórka przechowuje jedną wartość (1NF). Rozwiązaniem jest **tabela łącząca** (pośrednicząca), która zamienia N:M na dwa związki 1:N:
```dbml
Table studenci {
  id integer [primary key]
  nazwisko varchar
}

Table kursy {
  id integer [primary key]
  nazwa varchar
}

Table zapisy {
  student_id integer
  kurs_id integer
  data_zapisu date
  ocena decimal

  indexes {
    (student_id, kurs_id) [pk]
  }
}

Ref: zapisy.student_id > studenci.id
Ref: zapisy.kurs_id > kursy.id
```

Tabela łącząca może przechowywać dane opisujące samo powiązanie. `ocena` nie jest cechą studenta ani kursu, tylko konkretnego zapisu studenta na kurs.

Złożony klucz główny `(student_id, kurs_id)` zapobiega podwójnemu zapisowi tej samej pary. Jeśli ta sama para ma prawo wystąpić wiele razy, np. przy powtarzaniu kursu, użyj osobnego `id` jako klucza.

#### Związki w DBML
W `Ref` znak wskazuje kierunek, a klucz obcy jest po stronie "wielu":

| Zapis | Znaczenie |
|---|---|
| `Ref: studenci.wydzial_id > wydzialy.id` | wiele studentów do jednego wydziału (N:1) |
| `Ref: wydzialy.id < studenci.wydzial_id` | ten sam związek zapisany odwrotnie (1:N) |
| `Ref: legitymacje.student_id - studenci.id` | jeden do jednego (1:1) |

DBML ma też zapis `<>` dla N:M, ale w tych zajęciach rozpisuj tabelę łączącą jawnie. Będzie ona potrzebna przy implementacji w SQL, a jej obecność na diagramie pokazuje, gdzie trafią dodatkowe kolumny.

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
Table produkty {
  id integer [primary key]
  nazwa varchar
  cena decimal
}

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

  indexes {
    (produkt_id, promocja_id) [pk]
  }
}

Ref: produkty_promocje.produkt_id > produkty.id
Ref: produkty_promocje.promocja_id > promocje.id
```
`produkty_promocje` to tabela łącząca (N:M) — produkt może mieć wiele promocji, promocja obejmuje wiele produktów. Złożony klucz główny pilnuje, żeby ten sam produkt nie został dodany do tej samej promocji dwa razy. Tabela `produkty` jest tu skrócona do kolumn potrzebnych w szkicu, bo już istnieje w bazie sklepu.

### Zadania do wykonania
1. Wybierz temat rozszerzenia (inny niż koledzy/koleżanki obok, jeśli to możliwe).
2. Zaprojektuj diagram w dbdiagram.io: min. 2 nowe tabele, min. 1 relacja N:M, min. 1 FK do istniejącego schematu sklepu.
3. Sprawdź kardynalności związków — czy na pewno N:M, a nie 1:N (częsty błąd projektowy).
4. Wyeksportuj diagram (PNG lub link publiczny do dbdiagram.io).

### Co oddajemy
* eksport ERD (obrazek lub link),
* krótki opis (2-3 zdania) — co reprezentuje rozszerzenie i dlaczego wybrane relacje są takie, a nie inne.

Implementacja tego projektu w SQL — na następnych zajęciach (lab08).
