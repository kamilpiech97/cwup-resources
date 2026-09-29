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
