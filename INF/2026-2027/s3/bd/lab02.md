## Pierwsza baza danych — CREATE TABLE, typy danych, INSERT

### Cele zajęć
* utworzenie własnej, prostej bazy danych,
* poznanie podstawowych typów danych PostgreSQL,
* poznanie `CREATE TABLE`, kluczy głównych (`PRIMARY KEY`), `INSERT INTO`,
* wykonanie pierwszych zapytań `SELECT *`.

### Wybór tematu
Każdy student wybiera **samodzielnie, indywidualnie** jeden temat ze zbioru poniżej (praca solo, nie grupowo). Powtórzenia tematu między studentami są dopuszczalne.

Przykładowe tematy do wyboru:
* sklep spożywczy / zoologiczny,
* wypożyczalnia filmów / gier,
* biblioteka,
* kino,
* siłownia / klub fitness,
* szpital / przychodnia,
* warsztat samochodowy,
* restauracja,
* hotel,
* uczelnia (studenci, przedmioty, oceny).

### Wymagania wobec własnej bazy
* min. **2 tabele**, w tym przynajmniej jedna relacja między nimi (`FOREIGN KEY`) — przyda się już na następnych zajęciach,
* min. **5 kolumn** w głównej tabeli, z różnymi typami danych (tekstowy, liczbowy, data, logiczny),
* min. **10 rekordów** w każdej tabeli,
* każda tabela ma klucz główny.

### Wyjaśnienie pojęć
Przykłady w tej sekcji odnoszą się do tabel `autorzy` i `ksiazki` z sekcji "Przykład demonstracyjny".

#### Baza, tabela, kolumna, wiersz
**Baza danych** to uporządkowany zbiór danych, a **tabela** przechowuje dane o jednym rodzaju obiektów, np. o książkach. Każda **kolumna** opisuje jedną cechę i ma określony typ, np. `cena`. Każdy **wiersz** (rekord) to jeden obiekt, np. jedna książka.

Bazę obsługuje się językiem **SQL**. Polecenia kończą się średnikiem, a wielkość liter w słowach kluczowych nie ma znaczenia, choć zwykle zapisuje się je wielkimi literami.

#### CREATE TABLE
`CREATE TABLE` tworzy nową tabelę. Dla każdej kolumny podaje się nazwę, typ i opcjonalnie dodatkowe reguły:

| Element | Znaczenie | Przykład |
|---|---|---|
| nazwa i typ | co kolumna przechowuje | `rok_wydania INTEGER` |
| `NOT NULL` | wartość jest wymagana | `tytul VARCHAR(150) NOT NULL` |
| `DEFAULT` | wartość użyta, gdy `INSERT` jej nie poda | `dostepna BOOLEAN DEFAULT TRUE` |
| `PRIMARY KEY` | kolumna jest kluczem głównym | `id SERIAL PRIMARY KEY` |
| `REFERENCES` | kolumna jest kluczem obcym | `autor_id INTEGER REFERENCES autorzy(id)` |

Tabeli o tej samej nazwie nie można utworzyć ponownie. Polecenie kończy się wtedy błędem `relation "autorzy" already exists`.

#### Klucz główny (PRIMARY KEY)
Klucz główny jednoznacznie identyfikuje każdy wiersz. Jego wartość musi być unikalna i nie może być `NULL`, a baza odrzuci każdy `INSERT`, który to naruszy.

Do klucza zwykle używa się sztucznego numeru, a nie np. tytułu, bo dwie książki mogą mieć ten sam tytuł. `SERIAL` numeruje wiersze automatycznie: 1, 2, 3...

Dlatego kolumny `id` nie podaje się w `INSERT`. Ręczne wstawienie `id = 1` nie przesuwa licznika `SERIAL`, więc kolejny automatyczny numer może się z nim zderzyć i `INSERT` zakończy się błędem `duplicate key value`.

#### Klucz obcy (FOREIGN KEY) i relacja
Klucz obcy łączy dwie tabele: jego wartość wskazuje wiersz w innej tabeli. `ksiazki.autor_id = 3` oznacza, że autorem jest wiersz z `autorzy.id = 3`, czyli Lem. Dzięki temu dane autora są zapisane tylko raz, a nie przy każdej jego książce.

Baza pilnuje poprawności tego powiązania. Książka z nieistniejącym `autor_id = 99` zostanie odrzucona:
```
ERROR:  insert or update on table "ksiazki" violates foreign key constraint "ksiazki_autor_id_fkey"
```

Z tego powodu kolejność ma znaczenie: najpierw tworzysz i wypełniasz tabelę wskazywaną (`autorzy`), a dopiero potem tabelę z kluczem obcym (`ksiazki`).

Działanie kluczy omawiamy szerzej na kolejnych zajęciach.

#### NULL
`NULL` oznacza brak wartości, a nie zero ani pusty tekst. Kolumna bez `NOT NULL` i `DEFAULT` pominięta w `INSERT` przyjmuje `NULL`.

#### Jak dobrać typ danych
Listę typów znajdziesz w tabeli "Najważniejsze typy danych" poniżej. Typ określa, jakie wartości baza przyjmie, więc źle dobrany potrafi zmienić dane albo je odrzucić:

| Dane | Typ | Dlaczego |
|---|---|---|
| ceny, kwoty | `NUMERIC(p,s)` | zapisuje dokładne wartości dziesiętne |
| telefon, PESEL, kod pocztowy | `VARCHAR(n)` | to identyfikatory, a nie liczby: `INTEGER` zamieni `0601` na `601` |
| data | `DATE` | pozwala liczyć dni i odrzuca nieistniejące daty |
| tak/nie | `BOOLEAN` | ma tylko wartości `TRUE` i `FALSE` |

Limity typów są sprawdzane przy zapisie:
* `NUMERIC(6,2)` to 6 cyfr, w tym 2 po przecinku, czyli najwięcej 9999.99. Większa wartość daje błąd `numeric field overflow`. Nadmiarowe miejsca po przecinku są zaokrąglane: 39.999 zapisze się jako 40.00.
* `VARCHAR(50)` nie przyjmie dłuższego tekstu: `value too long for type character varying(50)`.

#### INSERT INTO
`INSERT INTO` dodaje wiersze. Podajesz listę kolumn, a w `VALUES` wartości w tej samej kolejności. Liczba wartości i kolumn musi się zgadzać. Jednym poleceniem można wstawić wiele wierszy, rozdzielając je przecinkami.

Zapis wartości:

| Typ wartości | Zapis | Przykład |
|---|---|---|
| tekst | w pojedynczych apostrofach | `'Solaris'` |
| apostrof w tekście | podwojony | `'O''Brien'` |
| liczba | bez apostrofów, z kropką dziesiętną | `39.99` |
| data | tekst w formacie `RRRR-MM-DD` | `'2026-12-31'` |
| wartość logiczna | słowo kluczowe | `TRUE`, `FALSE` |
| brak wartości | słowo kluczowe, bez apostrofów | `NULL` |

#### SELECT *
`SELECT * FROM ksiazki;` wyświetla wszystkie kolumny i wszystkie wiersze tabeli. To najprostszy sposób, żeby sprawdzić, czy dane zapisały się poprawnie. Filtrowaniem i sortowaniem zajmiemy się na kolejnych zajęciach.

### Przykład demonstracyjny (temat: biblioteka)

```sql
CREATE TABLE autorzy (
    id          SERIAL PRIMARY KEY,
    imie        VARCHAR(50) NOT NULL,
    nazwisko    VARCHAR(50) NOT NULL,
    kraj        VARCHAR(50)
);

CREATE TABLE ksiazki (
    id              SERIAL PRIMARY KEY,
    tytul           VARCHAR(150) NOT NULL,
    autor_id        INTEGER REFERENCES autorzy(id),
    rok_wydania     INTEGER,
    cena            NUMERIC(6,2),
    dostepna        BOOLEAN DEFAULT TRUE
);

INSERT INTO autorzy (imie, nazwisko, kraj) VALUES
    ('Andrzej', 'Sapkowski', 'Polska'),
    ('J.R.R.', 'Tolkien', 'Wielka Brytania'),
    ('Stanisław', 'Lem', 'Polska');

INSERT INTO ksiazki (tytul, autor_id, rok_wydania, cena, dostepna) VALUES
    ('Wiedźmin', 1, 1990, 39.99, TRUE),
    ('Władca Pierścieni', 2, 1954, 59.90, TRUE),
    ('Solaris', 3, 1961, 29.90, FALSE);

SELECT * FROM ksiazki;
```

### Najważniejsze typy danych (przypomnienie)
| Typ | Opis | Przykład |
|---|---|---|
| `SERIAL` | autoinkrementowany integer, wygodny pod PK | `id SERIAL PRIMARY KEY` |
| `VARCHAR(n)` | tekst o zmiennej długości, limit n znaków | `nazwa VARCHAR(100)` |
| `TEXT` | tekst bez limitu | `opis TEXT` |
| `INTEGER` | liczba całkowita | `rok_wydania INTEGER` |
| `NUMERIC(p,s)` | liczba dziesiętna, p cyfr, s po przecinku | `cena NUMERIC(6,2)` |
| `DATE` | data | `data_urodzenia DATE` |
| `BOOLEAN` | prawda/fałsz | `dostepna BOOLEAN` |

### Zadania do wykonania
1. Zaprojektuj i utwórz min. 2 powiązane tabele wg wybranego tematu (`CREATE TABLE` + `FOREIGN KEY`).
2. Wstaw min. 10 rekordów do każdej tabeli (`INSERT INTO`).
3. Wykonaj `SELECT * FROM <tabela>;` dla obu tabel i zapisz wynik.

### Co oddajemy
* plik `.sql` ze wszystkimi poleceniami `CREATE TABLE` i `INSERT`,
* zrzut ekranu wyniku `SELECT *` z obu tabel.
