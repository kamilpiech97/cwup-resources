## Zapytania złożone — JOIN, GROUP BY, HAVING, podzapytania

### Cele zajęć
* łączenie danych z wielu tabel (`INNER JOIN`, `LEFT JOIN`),
* agregacje: `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `GROUP BY`, `HAVING`,
* podzapytania (subqueries).

Praca dalej na wspólnej bazie "sklep" (z lab03).

### Wyjaśnienie pojęć
Wyjaśnienia opierają się na danych z tabel `dzialy` i `pracownicy`, które utworzysz w sekcji "Przykłady demonstracyjne":

| `pracownicy.imie` | `pracownicy.dzial_id` | `pracownicy.pensja` |
|---|---|---|
| Anna | 1 (IT) | 8500 |
| Piotr | 1 (IT) | 9200 |
| Marta | 2 (Sprzedaz) | 6500 |
| Tomasz | 2 (Sprzedaz) | 7100 |
| Ewa | 3 (Marketing) | 6000 |
| Krzysztof | `NULL` | 5500 |

W tabeli `dzialy` jest jeszcze czwarty dział, HR (`id = 4`), w którym nikt nie pracuje.

#### Łączenie tabel (JOIN)
Dane są rozbite na osobne tabele, żeby się nie powtarzały: `pracownicy` przechowuje tylko numer działu (`dzial_id`), a jego nazwa jest w `dzialy`. `JOIN` skleja wiersze obu tabel w jeden wynik, a warunek po `ON` określa, które wiersze do siebie pasują. Zwykle jest to porównanie klucza obcego z kluczem głównym: `p.dzial_id = d.id`.

**`INNER JOIN`** (samo `JOIN` znaczy to samo) zwraca tylko wiersze, które mają dopasowanie po obu stronach. Krzysztof odpada, bo nie ma działu, a HR odpada, bo nie ma pracowników. Wynik ma 5 wierszy.

**`LEFT JOIN`** zwraca wszystkie wiersze z tabeli po lewej stronie (tej z `FROM`), nawet bez dopasowania. Brakujące kolumny z prawej tabeli przyjmują wartość `NULL`. Kolejność tabel ma tu znaczenie:

| Zapytanie | Kto zostaje mimo braku dopasowania | Liczba wierszy |
|---|---|---|
| `FROM pracownicy p LEFT JOIN dzialy d` | Krzysztof (dział = `NULL`) | 6 |
| `FROM dzialy d LEFT JOIN pracownicy p` | HR (pracownik = `NULL`) | 6 |

Skoro brak dopasowania daje `NULL`, `LEFT JOIN` z warunkiem `IS NULL` znajduje wiersze, które nie mają odpowiednika w drugiej tabeli, np. działy bez pracowników:
```sql
SELECT d.nazwa
FROM dzialy d
LEFT JOIN pracownicy p ON p.dzial_id = d.id
WHERE p.id IS NULL;
```

#### Funkcje agregujące
Funkcja agregująca zamienia wiele wierszy w jedną wartość:

| Funkcja | Co liczy | Wynik dla wszystkich pracowników |
|---|---|---|
| `COUNT(*)` | liczbę wierszy | 6 |
| `COUNT(dzial_id)` | liczbę wartości innych niż `NULL` w kolumnie | 5 |
| `SUM(pensja)` | sumę | 42800 |
| `AVG(pensja)` | średnią | 7133.33 |
| `MAX(pensja)` | największą wartość | 9200 |
| `MIN(pensja)` | najmniejszą wartość | 5500 |

Funkcje agregujące pomijają `NULL`. Wyjątkiem jest `COUNT(*)`, które liczy całe wiersze. Ma to znaczenie przy `LEFT JOIN`: dział HR ma jeden wiersz wyniku (z `NULL` w kolumnach pracownika), więc `COUNT(*)` zwróci dla niego 1, a `COUNT(p.id)` poprawne 0.

#### Grupowanie (GROUP BY)
Bez `GROUP BY` funkcja agregująca liczy jedną wartość dla całej tabeli. `GROUP BY` dzieli wiersze na grupy o tej samej wartości wskazanej kolumny i liczy wartość osobno dla każdej grupy:
```sql
SELECT dzial_id, COUNT(*) AS liczba, SUM(pensja) AS suma, AVG(pensja) AS srednia
FROM pracownicy
GROUP BY dzial_id;
```

| `dzial_id` | `liczba` | `suma` | `srednia` |
|---|---|---|---|
| 1 | 2 | 17700 | 8850 |
| 2 | 2 | 13600 | 6800 |
| 3 | 1 | 6000 | 6000 |
| `NULL` | 1 | 5500 | 5500 |

Każda kolumna w `SELECT` musi być wymieniona w `GROUP BY` albo znajdować się w funkcji agregującej. Grupa IT ma dwóch pracowników, więc baza nie wie, które imię miałaby pokazać dla `SELECT dzial_id, imie, COUNT(*)` i zgłasza błąd:
```
ERROR:  column "pracownicy.imie" must appear in the GROUP BY clause or be used in an aggregate function
```

#### Filtrowanie grup (HAVING)
`WHERE` filtruje pojedyncze wiersze **przed** grupowaniem, a `HAVING` filtruje całe grupy **po** grupowaniu. Dlatego warunek na wyniku funkcji agregującej może się znaleźć tylko w `HAVING`. Użycie go w `WHERE` kończy się błędem:
```
ERROR:  aggregate functions are not allowed in WHERE
```

Oba filtry można łączyć. Poniższe zapytanie zwraca działy, w których co najmniej dwie osoby zarabiają ponad 7000:
```sql
SELECT dzial_id, COUNT(*) AS liczba
FROM pracownicy
WHERE pensja > 7000
GROUP BY dzial_id
HAVING COUNT(*) > 1;
```

Krok po kroku:
1. `WHERE` zostawia Annę, Piotra i Tomasza.
2. `GROUP BY` tworzy dwie grupy: dział 1 (2 osoby) i dział 2 (1 osoba).
3. `HAVING` zostawia tylko dział 1.

#### Kolejność wykonywania zapytania
Baza przetwarza zapytanie w innej kolejności, niż je zapisujemy:

`FROM` i `JOIN` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY` → `LIMIT`

Ta kolejność tłumaczy, dlaczego `WHERE` nie widzi wyników agregacji: w tym momencie grupy jeszcze nie istnieją. Z tego samego powodu alias z `SELECT` można wykorzystać w `ORDER BY`, ale nie w `WHERE` ani w `HAVING`.

### Przykłady demonstracyjne
Poniższe przykłady działają na osobnych, małych tabelach `dzialy`/`pracownicy`.

```sql
CREATE TABLE dzialy (
    id      SERIAL PRIMARY KEY,
    nazwa   VARCHAR(100)
);

CREATE TABLE pracownicy (
    id          SERIAL PRIMARY KEY,
    imie        VARCHAR(50),
    nazwisko    VARCHAR(50),
    dzial_id    INTEGER REFERENCES dzialy(id),
    pensja      NUMERIC(10,2)
);

INSERT INTO dzialy (nazwa) VALUES ('IT'), ('Sprzedaz'), ('Marketing'), ('HR');

INSERT INTO pracownicy (imie, nazwisko, dzial_id, pensja) VALUES
    ('Anna', 'Kowalska', 1, 8500),
    ('Piotr', 'Nowak', 1, 9200),
    ('Marta', 'Wisniewska', 2, 6500),
    ('Tomasz', 'Zielinski', 2, 7100),
    ('Ewa', 'Lewandowska', 3, 6000),
    ('Krzysztof', 'Wojcik', NULL, 5500);  -- bez przypisanego działu, do demo LEFT JOIN
```

`INNER JOIN` — pracownicy z nazwą działu (uwaga: Krzysztof zniknie, bo `dzial_id IS NULL`):
```sql
SELECT p.imie, p.nazwisko, d.nazwa AS dzial
FROM pracownicy p
INNER JOIN dzialy d ON p.dzial_id = d.id;
```

`LEFT JOIN` — wszyscy pracownicy, nawet bez przypisanego działu:
```sql
SELECT p.imie, p.nazwisko, d.nazwa AS dzial
FROM pracownicy p
LEFT JOIN dzialy d ON p.dzial_id = d.id;
```

Agregacje — suma i liczba pracowników per dział:
```sql
SELECT d.nazwa AS dzial, SUM(p.pensja) AS suma_pensji, COUNT(p.id) AS liczba_pracownikow
FROM dzialy d
LEFT JOIN pracownicy p ON p.dzial_id = d.id
GROUP BY d.nazwa
ORDER BY suma_pensji DESC NULLS LAST;
```

`HAVING` — działy z więcej niż jednym pracownikiem:
```sql
SELECT d.nazwa, COUNT(p.id) AS liczba
FROM dzialy d
JOIN pracownicy p ON p.dzial_id = d.id
GROUP BY d.nazwa
HAVING COUNT(p.id) > 1;
```

Podzapytanie — pracownicy zarabiający więcej niż średnia:
```sql
SELECT imie, nazwisko, pensja
FROM pracownicy
WHERE pensja > (SELECT AVG(pensja) FROM pracownicy)
ORDER BY pensja DESC;
```

Podzapytanie z `IN` — pracownicy z działów liczących więcej niż 1 osobę:
```sql
SELECT imie, nazwisko
FROM pracownicy
WHERE dzial_id IN (
    SELECT dzial_id FROM pracownicy
    WHERE dzial_id IS NOT NULL
    GROUP BY dzial_id HAVING COUNT(*) > 1
);
```

### Zadania do wykonania
Napisz zapytania SQL — **na bazie "sklep"**, tabele: `zamowienia`, `klienci`, `produkty`, `kategorie`, `pozycje_zamowien`, `pracownicy`. Zastosuj wzorce pokazane wyżej na `dzialy`/`pracownicy` do właściwego schematu sklepu:
1. Wyświetl listę zamówień (id, data, status) razem z imieniem i nazwiskiem klienta.
2. Dla każdej kategorii wyświetl średnią cenę produktów w tej kategorii (`GROUP BY`, `AVG`).
3. Wyświetl 5 klientów, którzy wydali najwięcej łącznie (suma `ilosc * cena_jednostkowa` po wszystkich ich zamówieniach).
4. Wyświetl kategorie, w których jest więcej niż 5 produktów (`HAVING`).
5. Wyświetl produkty, które nigdy nie zostały zamówione (podpowiedź: `LEFT JOIN` + `WHERE ... IS NULL`, albo `NOT IN`).
6. Wyświetl liczbę zamówień per status (`GROUP BY status`).
7. Znajdź pracownika, który obsłużył najwięcej zamówień.
8. Wyświetl liczbę zamówień złożonych przez każdego klienta, **łącznie z klientami, którzy nie mają żadnego zamówienia** (`LEFT JOIN` + `COUNT`, pomyśl czy liczyć `z.id` czy `kl.id`).
9. Wyświetl 5 kategorii z najwyższą łączną wartością sprzedaży (suma `ilosc * cena_jednostkowa` po produktach z danej kategorii, przez `pozycje_zamowien` → `produkty` → `kategorie`).
10. Wyświetl produkty droższe niż średnia cena **w obrębie własnej kategorii** (nie globalna średnia — dla każdej kategorii osobno).
11. Wyświetl klientów, którzy nigdy nie złożyli zamówienia.
12. Wyświetl łączną liczbę sprzedanych sztuk per kategoria (przez trzy złączone tabele: `pozycje_zamowien`, `produkty`, `kategorie`).
13. Wyświetl pracowników, którzy obsłużyli mniej zamówień niż wynosi średnia liczba zamówień na pracownika — uwzględnij też tych, którzy nie obsłużyli żadnego (`LEFT JOIN` + `HAVING` + podzapytanie z `AVG`).
14. Wyświetl 3 produkty najczęściej kupowane, licząc **liczbę wystąpień** w `pozycje_zamowien` (nie sumę wartości sprzedaży).

### Co oddajemy
* plik `.sql` z 14 zapytaniami i wynikami.
