## Modyfikacja schematu bazy danych (DDL) i normalizacja

### Cele zajęć
* `ALTER TABLE` — dodawanie/zmiana/usuwanie kolumn,
* ograniczenia: `CHECK`, `UNIQUE`, `NOT NULL`, `FOREIGN KEY`,
* normalizacja schematu (1NF, 2NF, 3NF) na praktycznym przykładzie.

### Część 1: DDL — demo (inna baza — tylko do pokazania składni)
Poniższy przykład działa na osobnej, niezależnej tabeli `zwierzeta` (schronisko) — **nie na bazie sklepu**. Cel: pokazać technikę `ALTER TABLE`/ograniczeń, nie gotowe rozwiązanie zadania.

```sql
CREATE TABLE zwierzeta (
    id          SERIAL PRIMARY KEY,
    imie        VARCHAR(50),
    gatunek     VARCHAR(50),
    wiek        INTEGER
);
```

Modyfikacje schematu:
```sql
-- dodanie kolumny z datą
ALTER TABLE zwierzeta ADD COLUMN data_przyjecia DATE DEFAULT CURRENT_DATE;

-- dodanie ograniczenia CHECK (wiek w rozsądnym zakresie)
ALTER TABLE zwierzeta ADD CONSTRAINT wiek_zakres CHECK (wiek BETWEEN 0 AND 30);

-- dodanie UNIQUE (brak dwóch identycznych par imię+gatunek)
ALTER TABLE zwierzeta ADD CONSTRAINT unikalne_imie_gatunek UNIQUE (imie, gatunek);

-- zmiana typu kolumny
ALTER TABLE zwierzeta ALTER COLUMN gatunek TYPE VARCHAR(100);

-- usunięcie kolumny
ALTER TABLE zwierzeta DROP COLUMN IF EXISTS kolumna_testowa;

-- zmiana nazwy kolumny
ALTER TABLE zwierzeta RENAME COLUMN wiek TO wiek_lat;
```

Test ograniczeń (powinny zwrócić błąd):
```sql
INSERT INTO zwierzeta (imie, gatunek, wiek_lat) VALUES ('Reksio', 'Pies', 45);  -- błąd: CHECK
INSERT INTO zwierzeta (imie, gatunek, wiek_lat) VALUES ('Reksio', 'Pies', 5);
INSERT INTO zwierzeta (imie, gatunek, wiek_lat) VALUES ('Reksio', 'Pies', 3);   -- błąd: UNIQUE
```

### Zadanie DDL (na bazie sklep)
Zastosuj dokładnie te same techniki co w demo powyżej (`ADD COLUMN`, `ADD CONSTRAINT CHECK`, `ADD CONSTRAINT UNIQUE`, zmiana typu, zmiana nazwy) do **nowej tabeli w bazie sklep**:

* utwórz tabelę `recenzje` (produkt_id → `produkty`, klient_id → `klienci`, ocena, treść recenzji),
* dodaj ograniczenie `CHECK`, żeby ocena mieściła się w zakresie 1-5,
* dodaj ograniczenie `UNIQUE`, żeby jeden klient mógł dodać tylko jedną recenzję na produkt,
* wykonaj min. 3 modyfikacje schematu przez `ALTER TABLE` (np. dodanie kolumny z datą, zmiana typu treści, zmiana nazwy kolumny),
* przetestuj oba ograniczenia (wstaw dane, które je naruszają, zapisz komunikat błędu).

### Część 2: Normalizacja — demo
Poniższy przykład normalizuje osobną, zdenormalizowaną tabelę `wypozyczenia_flat` (biblioteka) — **nie `sprzedaz_flat`**. 

```sql
CREATE TABLE wypozyczenia_flat (
    id                      SERIAL PRIMARY KEY,
    czytelnik_imie          VARCHAR(50),
    czytelnik_nazwisko      VARCHAR(50),
    czytelnik_email         VARCHAR(150),
    ksiazka_tytul           VARCHAR(150),
    ksiazka_autor           VARCHAR(100),
    data_wypozyczenia       DATE
);

INSERT INTO wypozyczenia_flat
    (czytelnik_imie, czytelnik_nazwisko, czytelnik_email, ksiazka_tytul, ksiazka_autor, data_wypozyczenia)
VALUES
    ('Jan', 'Kowalski', 'jan.kowalski@example.com', 'Wiedźmin', 'Andrzej Sapkowski', '2026-01-10'),
    ('Jan', 'Kowalski', 'jan.kowalski@example.com', 'Solaris', 'Stanisław Lem', '2026-02-15'),
    ('Anna', 'Nowak', 'anna.nowak@example.com', 'Wiedźmin', 'Andrzej Sapkowski', '2026-01-20'),
    ('Anna', 'Nowak', 'anna.nowak@example.com', 'Lalka', 'Bolesław Prus', '2026-03-01'),
    ('Piotr', 'Wisniewski', 'piotr.wisniewski@example.com', 'Solaris', 'Stanisław Lem', '2026-02-25');
```

Zauważ anomalie: dane czytelnika (`czytelnik_imie`, `czytelnik_email`...) i książki (`ksiazka_tytul`, `ksiazka_autor`) powtarzają się w wielu wierszach. Co się stanie, jeśli czytelnik zmieni e-mail? Trzeba by zaktualizować wiele wierszy naraz (anomalia aktualizacji).

Rozbicie do 3NF — osobne tabele dla czytelników, książek i faktu wypożyczenia:
```sql
CREATE TABLE czytelnicy_norm (
    id          SERIAL PRIMARY KEY,
    imie        VARCHAR(50),
    nazwisko    VARCHAR(50),
    email       VARCHAR(150) UNIQUE
);

CREATE TABLE ksiazki_norm (
    id      SERIAL PRIMARY KEY,
    tytul   VARCHAR(150),
    autor   VARCHAR(100)
);

CREATE TABLE wypozyczenia_norm (
    id                  SERIAL PRIMARY KEY,
    czytelnik_id        INTEGER REFERENCES czytelnicy_norm(id),
    ksiazka_id          INTEGER REFERENCES ksiazki_norm(id),
    data_wypozyczenia   DATE
);
```

Migracja danych (`INSERT...SELECT`, usunięcie duplikatów przez `DISTINCT`):
```sql
INSERT INTO czytelnicy_norm (imie, nazwisko, email)
SELECT DISTINCT czytelnik_imie, czytelnik_nazwisko, czytelnik_email
FROM wypozyczenia_flat;

INSERT INTO ksiazki_norm (tytul, autor)
SELECT DISTINCT ksiazka_tytul, ksiazka_autor
FROM wypozyczenia_flat;

INSERT INTO wypozyczenia_norm (czytelnik_id, ksiazka_id, data_wypozyczenia)
SELECT cn.id, kn.id, wf.data_wypozyczenia
FROM wypozyczenia_flat wf
JOIN czytelnicy_norm cn ON cn.email = wf.czytelnik_email
JOIN ksiazki_norm kn ON kn.tytul = wf.ksiazka_tytul AND kn.autor = wf.ksiazka_autor;
```

Weryfikacja — liczba wierszy faktu powinna się zgadzać z tabelą źródłową:
```sql
SELECT COUNT(*) FROM wypozyczenia_flat; -- 5
SELECT COUNT(*) FROM wypozyczenia_norm; -- 5
SELECT COUNT(*) FROM czytelnicy_norm;   -- 3 (unikalni)
SELECT COUNT(*) FROM ksiazki_norm;      -- 3 (unikalne)
```

### Zadanie: normalizacja (na bazie sklep)
Import zdenormalizowanej tabeli `sprzedaz_flat`:
```bash
docker exec -i bd_postgres psql -U student -d cwiczenia < sql/03_denormalized_sprzedaz.sql
```

Podejrzyj dane i policz duplikaty (analogicznie do demo powyżej):
```sql
SELECT * FROM sprzedaz_flat LIMIT 20;
SELECT COUNT(*), COUNT(DISTINCT klient_email) FROM sprzedaz_flat;
```

**Zadanie:** rozbij `sprzedaz_flat` do 3NF, tą samą techniką co w demo (`CREATE TABLE` dla każdego "tematu" + `INSERT...SELECT DISTINCT` + migracja faktu przez `JOIN`). Tym razem **sam zaprojektuj** nazwy i strukturę tabel docelowych — wymagania:
* osobna tabela dla danych klienta, osobna dla danych produktu, osobna dla faktu sprzedaży,
* każda z tabel klienta/produktu ma unikalne wiersze (bez powtórzeń),
* tabela faktu sprzedaży łączy się z pozostałymi przez `FOREIGN KEY`,
* liczba wierszy w tabeli faktu = liczba wierszy w `sprzedaz_flat` (500), żadne dane nie giną w migracji.

Na koniec: krótkie uzasadnienie pisemne (3-4 zdania) — jakie anomalie eliminuje ten podział.

### Co oddajemy
* plik `.sql` ze wszystkimi poleceniami DDL (zadanie z `recenzje`) i migracją normalizacyjną (`sprzedaz_flat` → własne tabele),
* krótkie uzasadnienie normalizacji (tekst w komentarzu SQL lub osobny plik `.md`).
