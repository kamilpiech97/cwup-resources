## Selekcja i projekcja w SQL (WHERE, ORDER BY, LIMIT)

### Cele zajęć
* poznanie `WHERE` (operatory `=`, `<>`, `AND`, `OR`, `IN`, `BETWEEN`, `LIKE`),
* poznanie `ORDER BY`, `LIMIT`/`OFFSET`, aliasów (`AS`),
* przejście na wspólną bazę ćwiczeniową "sklep internetowy" (obowiązuje od dziś do laboratorium 8 włącznie).

### Dlaczego wspólna baza?
Własne bazy z lab02 mają za mało danych (10 rekordów), żeby sensownie ćwiczyć filtrowanie, sortowanie i (na kolejnych zajęciach) agregacje. Od teraz do laboratorium 8 (implementacja ERD) wszyscy pracują na tej samej, gotowej bazie "sklep" — każdy we własnym kontenerze Docker, więc nie ma ryzyka kolizji.

### Import wspólnej bazy
Pliki `01_schema_sklep.sql` i `02_seed_sklep.sql` (katalog `sql/` w repo kursu) wykonać w tej kolejności w Query Tool pgAdmin (lub `psql`):

```bash
docker exec -i bd_postgres psql -U student -d cwiczenia < sql/01_schema_sklep.sql
docker exec -i bd_postgres psql -U student -d cwiczenia < sql/02_seed_sklep.sql
```

Schemat bazy "sklep":
* `kategorie` (id, nazwa, opis) — 15 wierszy
* `produkty` (id, nazwa, kategoria_id → kategorie, cena, ilosc_magazyn, data_dodania) — 150 wierszy
* `klienci` (id, imie, nazwisko, email, data_rejestracji, miasto) — 200 wierszy
* `pracownicy` (id, imie, nazwisko, stanowisko, data_zatrudnienia) — 20 wierszy
* `zamowienia` (id, klient_id → klienci, pracownik_id → pracownicy, data_zamowienia, status) — 1000 wierszy
* `pozycje_zamowien` (id, zamowienie_id → zamowienia, produkt_id → produkty, ilosc, cena_jednostkowa) — ~3000 wierszy

Sprawdzenie poprawności importu:
```sql
SELECT COUNT(*) FROM produkty;   -- 150
SELECT COUNT(*) FROM zamowienia; -- 1000
```

### Wyjaśnienie pojęć
Wyniki w tej sekcji dotyczą tabeli `filmy` z sekcji "Przykłady demonstracyjne" (8 filmów).

#### Projekcja i selekcja
Zapytanie `SELECT` zawęża tabelę na dwa sposoby:
* **projekcja** wybiera kolumny, czyli to, co wpisujesz po `SELECT`,
* **selekcja** wybiera wiersze, czyli warunek po `WHERE`.

Zapis `SELECT *` zwraca wszystkie kolumny. Wygodnie się nim ogląda dane, ale w gotowych zapytaniach lepiej wymieniać kolumny, które są potrzebne.

#### Warunki w WHERE
`WHERE` sprawdza warunek dla każdego wiersza i zostawia te, dla których jest prawdziwy.

| Operator | Znaczenie | Przykład | Wynik |
|---|---|---|---|
| `=`, `<>` | równe, różne | `gatunek <> 'Dramat'` | 5 filmów |
| `>`, `<`, `>=`, `<=` | porównanie | `ocena > 8.0` | 5 filmów |
| `IN` | jedna z wartości na liście | `gatunek IN ('Dramat', 'Animacja')` | 5 filmów |
| `BETWEEN` | wartość w przedziale | `rok_produkcji BETWEEN 1995 AND 2005` | 5 filmów |
| `LIKE` | dopasowanie do wzorca tekstu | `tytul LIKE 'S%'` | 2 filmy |

Na co uważać:
* `BETWEEN` obejmuje oba końce przedziału, więc film z 1995 r. (Toy Story) spełnia warunek powyżej.
* `NOT` odwraca warunek: `NOT BETWEEN`, `NOT IN`, `NOT LIKE`.
* Tekst i daty zapisuje się w pojedynczych apostrofach. Podwójne cudzysłowy oznaczają nazwę kolumny, więc `gatunek = "Dramat"` kończy się błędem `column "Dramat" does not exist`.
* Porównanie tekstu jest dokładne, dlatego `'Wrocław'` i `'Wroclaw'` to dwie różne wartości. Jeśli zapytanie zwraca zaskakująco mało wierszy, sprawdź przez `SELECT DISTINCT`, jak dane są zapisane.

#### Wzorce LIKE
| Znak | Znaczenie | Przykład | Pasuje |
|---|---|---|---|
| `%` | dowolna liczba dowolnych znaków, także zero | `'%x'` | Matrix |
| `%` po obu stronach | tekst w dowolnym miejscu | `'%an%'` | Titanic, Skazani na Shawshank |
| `_` | dokładnie jeden dowolny znak | `'S_rek'` | Shrek |

W PostgreSQL `LIKE` rozróżnia wielkość liter: `LIKE 's%'` nie znajdzie żadnego filmu. Bez rozróżniania wielkości liter działa `ILIKE`.

#### Łączenie warunków
`AND` wymaga spełnienia obu warunków, a `OR` co najmniej jednego. `AND` ma wyższy priorytet, tak jak mnożenie względem dodawania, więc przy mieszaniu ich używaj nawiasów:

| Warunek | Jak czyta go baza | Wynik |
|---|---|---|
| `gatunek = 'Animacja' OR gatunek = 'Dramat' AND ocena > 9` | wszystkie animacje oraz dramaty z oceną powyżej 9 | Shrek, Skazani na Shawshank, Toy Story |
| `(gatunek = 'Animacja' OR gatunek = 'Dramat') AND ocena > 9` | animacje i dramaty, ale tylko z oceną powyżej 9 | Skazani na Shawshank |

#### NULL
`NULL` oznacza brak wartości, a nie zero ani pusty tekst. Porównanie z `NULL` nigdy nie jest prawdziwe, nawet `ocena = NULL`, dlatego taki warunek nie zwróci żadnego wiersza. Do sprawdzania służą `IS NULL` i `IS NOT NULL`.

Wiersz z `NULL` w kolumnie `ocena` nie przejdzie ani przez `ocena > 8`, ani przez `NOT ocena > 8`.

#### Sortowanie i ograniczanie wyników
`ORDER BY` ustala kolejność wierszy: `ASC` rosnąco (domyślnie) lub `DESC` malejąco. Bez `ORDER BY` baza nie gwarantuje żadnej kolejności.

Można sortować po kilku kolumnach. Kolejna kolumna rozstrzyga remisy w poprzedniej: Shrek i Titanic mają tę samą ocenę 7.9, więc `ORDER BY ocena DESC, tytul ASC` ustawia ich alfabetycznie.

W PostgreSQL `NULL` przy sortowaniu `DESC` trafia domyślnie na początek. Film bez oceny znalazłby się więc nad najlepszym filmem, o ile nie dodasz `NULLS LAST`.

`LIMIT` określa, ile wierszy zwrócić, a `OFFSET`, ile pominąć na początku. Razem służą m.in. do stronicowania: strona 3 po 10 wierszy to `LIMIT 10 OFFSET 20`. Używaj ich z `ORDER BY`, bo inaczej nie wiadomo, które wiersze zostaną wybrane.

#### Aliasy
`AS` nadaje kolumnie lub wyrażeniu inną nazwę w wyniku, np. `tytul AS film`. Nazwa ze spacją lub polskimi znakami wymaga podwójnych cudzysłowów: `tytul AS "Tytuł filmu"`.

#### Kolejność wykonywania
Baza przetwarza zapytanie w innej kolejności, niż je zapisujemy:

`FROM` → `WHERE` → `SELECT` → `ORDER BY` → `LIMIT`

Dlatego alias z `SELECT` działa w `ORDER BY`, ale nie w `WHERE`. Zapytanie `SELECT tytul AS film FROM filmy WHERE film = 'Matrix'` kończy się błędem `column "film" does not exist`.

#### Inne konstrukcje z zadań
| Konstrukcja | Działanie | Przykład | Wynik |
|---|---|---|---|
| `SELECT DISTINCT` | usuwa powtórzone wiersze z wyniku | `SELECT DISTINCT gatunek FROM filmy` | Animacja, Dramat, Sci-Fi |
| `UPPER(tekst)` | zamienia litery na wielkie | `UPPER('Matrix')` | MATRIX |
| `ROUND(liczba)` | zaokrągla do całości lub podanej liczby miejsc | `ROUND(8.85)`, `ROUND(8.85, 1)` | 9, 8.9 |
| `CURRENT_DATE` | dzisiejsza data | `CURRENT_DATE - INTERVAL '30 days'` | data sprzed 30 dni |
| odejmowanie dat | liczba dni między datami | `CURRENT_DATE - DATE '2026-10-01'` | liczba dni od tej daty |

### Przykłady demonstracyjne
Poniższe przykłady działają na osobnej, malutkiej tabeli `filmy`.

```sql
CREATE TABLE filmy (
    id              SERIAL PRIMARY KEY,
    tytul           VARCHAR(150),
    gatunek         VARCHAR(50),
    rok_produkcji   INTEGER,
    ocena           NUMERIC(3,1)
);

INSERT INTO filmy (tytul, gatunek, rok_produkcji, ocena) VALUES
    ('Incepcja', 'Sci-Fi', 2010, 8.8),
    ('Matrix', 'Sci-Fi', 1999, 8.7),
    ('Titanic', 'Dramat', 1997, 7.9),
    ('Gladiator', 'Dramat', 2000, 8.5),
    ('Shrek', 'Animacja', 2001, 7.9),
    ('Skazani na Shawshank', 'Dramat', 1994, 9.3),
    ('Avatar', 'Sci-Fi', 2009, 7.8),
    ('Toy Story', 'Animacja', 1995, 8.3);
```

Projekcja (wybór kolumn) + alias:
```sql
SELECT tytul AS film, ocena
FROM filmy;
```

Selekcja z `WHERE`:
```sql
SELECT tytul, ocena
FROM filmy
WHERE ocena > 8.0;

SELECT tytul, gatunek
FROM filmy
WHERE gatunek = 'Sci-Fi';

SELECT *
FROM filmy
WHERE gatunek IN ('Dramat', 'Animacja');

SELECT *
FROM filmy
WHERE rok_produkcji BETWEEN 1995 AND 2005;

SELECT *
FROM filmy
WHERE tytul LIKE 'S%';
```

Sortowanie i limit:
```sql
SELECT tytul, ocena
FROM filmy
ORDER BY ocena DESC
LIMIT 3;

SELECT tytul, rok_produkcji
FROM filmy
ORDER BY rok_produkcji ASC
LIMIT 3 OFFSET 2;   -- kolejne 3 po pierwszych 2
```

Łączenie warunków:
```sql
SELECT tytul, gatunek, ocena
FROM filmy
WHERE gatunek = 'Sci-Fi' AND ocena > 8.0
ORDER BY ocena DESC;
```

### Zadania do wykonania
Napisz zapytania SQL realizujące poniższe polecenia — **na bazie "sklep"**, tabele: `produkty`, `klienci`, `zamowienia`. Skorzystaj z konstrukcji pokazanych wyżej na `filmy`, ale zastosuj je do właściwych kolumn/tabel sklepu:
1. Wyświetl nazwy i ceny wszystkich produktów drożej niż 200 zł, posortowane malejąco po cenie.
2. Wyświetl imię, nazwisko i miasto klientów z Wrocławia lub Poznania (w bazie zapisane bez polskich znaków: `'Wroclaw'`, `'Poznan'`).
3. Wyświetl 10 najtańszych produktów (nazwa, cena).
4. Wyświetl zamówienia o statusie `'anulowane'`, posortowane po dacie zamówienia (najnowsze pierwsze).
5. Wyświetl produkty, których nazwa zaczyna się na literę „P”.
6. Wyświetl produkty o niskim stanie magazynowym (`ilosc_magazyn < 5`).
7. Wyświetl klientów zarejestrowanych w ciągu ostatnich 500 dni (użyj `data_rejestracji > CURRENT_DATE - INTERVAL '500 days'`).
8. Wyświetl 5 najdroższych i 5 najtańszych produktów w jednym zestawieniu (dwa osobne zapytania są ok).
9. Wyświetl produkty dodane w ciągu ostatnich 30 dni (`data_dodania >= CURRENT_DATE - INTERVAL '30 days'`).
10. Wyświetl listę unikalnych miast, w których mieszkają klienci (`SELECT DISTINCT`).
11. Wyświetl nazwiska klientów zapisane wielkimi literami obok oryginalnej wersji (`UPPER()`).
12. Wyświetl produkty, których cena po zaokrągleniu do pełnych złotych mieści się w przedziale 90-110 zł (`ROUND(cena) BETWEEN 90 AND 110`).
13. Wyświetl klientów, których nazwisko kończy się na „ski” LUB imię zaczyna się na „A”.
14. Wyświetl 5 zamówień złożonych najwcześniej (najstarsze daty).
15. Wyświetl produkty, których cena NIE mieści się w przedziale 100-300 zł (`NOT BETWEEN`).
16. Wyświetl nazwę i liczbę dni od dodania każdego produktu do dziś (`CURRENT_DATE - data_dodania`), posortuj malejąco po tej wartości.

### Live-check
Pod koniec zajęć 2-3 losowo wybrane osoby zostaną poproszone o modyfikację jednego ze swoich zapytań na żywo (np. zmiana warunku, dodanie sortowania). Brak "kary" — to informacja dla prowadzącego, czy materiał jest rozumiany, nie tylko przepisany.

### Co oddajemy
* plik `.sql` z 16 zapytaniami i wynikami (eksport z pgAdmin).
