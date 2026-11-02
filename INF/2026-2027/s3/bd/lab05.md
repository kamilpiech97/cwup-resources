## Modyfikacja schematu bazy danych (DDL) i normalizacja

### Cele zajęć
* `ALTER TABLE` — dodawanie/zmiana/usuwanie kolumn,
* ograniczenia: `CHECK`, `UNIQUE`, `NOT NULL`, `FOREIGN KEY`,
* normalizacja schematu (1NF, 2NF, 3NF) na praktycznym przykładzie.

### Część 1: DDL — wyjaśnienie pojęć
**DDL** (Data Definition Language) to polecenia zmieniające strukturę bazy: `CREATE`, `ALTER`, `DROP`. Operują na tabelach i kolumnach, a nie na samych danych. Polecenia działające na wierszach (`INSERT`, `UPDATE`, `DELETE`) należą do DML i są tematem kolejnych zajęć.

#### ALTER TABLE
`ALTER TABLE` zmienia istniejącą tabelę bez jej usuwania, więc zapisane dane zostają. Jest to potrzebne, bo wymagania zmieniają się również wtedy, gdy baza działa i zawiera już dane.

| Operacja | Składnia | Na co uważać |
|---|---|---|
| dodanie kolumny | `ADD COLUMN nazwa typ` | istniejące wiersze dostają `NULL` albo wartość z `DEFAULT` |
| usunięcie kolumny | `DROP COLUMN nazwa` | dane z kolumny przepadają bezpowrotnie |
| zmiana typu | `ALTER COLUMN nazwa TYPE typ` | istniejące wartości muszą dać się przekonwertować |
| zmiana nazwy | `RENAME COLUMN stara TO nowa` | zapytania używające starej nazwy przestaną działać |
| dodanie ograniczenia | `ADD CONSTRAINT nazwa ...` | istniejące wiersze muszą spełniać ograniczenie |

Baza odrzuca zmianę, której nie mogą spełnić istniejące dane. Przykładowo konwersji tekstu na liczbę nie wykona automatycznie:
```
ERROR:  column "gatunek" cannot be cast automatically to type integer
```

#### Ograniczenia (constraints)
Ograniczenia to reguły, których przestrzeganiem zajmuje się sama baza. Odrzuci ona każdą niepoprawną operację, niezależnie od tego, czy pochodzi z aplikacji, czy z ręcznie wpisanego zapytania.

| Ograniczenie | Co gwarantuje | Przykład |
|---|---|---|
| `NOT NULL` | kolumna musi mieć wartość | zwierzę musi mieć imię |
| `CHECK` | wartość spełnia podany warunek | wiek od 0 do 30 |
| `UNIQUE` | wartość lub kombinacja wartości nie powtarza się | para imię + gatunek występuje raz |
| `FOREIGN KEY` | wartość istnieje w kolumnie wskazanej tabeli | opiekun zwierzęcia jest w tabeli opiekunów |

`CHECK` i `UNIQUE` pokazuje demo poniżej. Pozostałe dwa ograniczenia dodaje się tak (te polecenia uruchom dopiero po wykonaniu demo, bo to ono tworzy tabelę `zwierzeta`):
```sql
ALTER TABLE zwierzeta ALTER COLUMN imie SET NOT NULL;

CREATE TABLE opiekunowie (
    id          SERIAL PRIMARY KEY,
    nazwisko    VARCHAR(50)
);

ALTER TABLE zwierzeta ADD COLUMN opiekun_id INTEGER;
ALTER TABLE zwierzeta ADD CONSTRAINT fk_opiekun FOREIGN KEY (opiekun_id) REFERENCES opiekunowie(id);
```

`FOREIGN KEY` działa w obie strony. Nie można przypisać nieistniejącego opiekuna ani usunąć opiekuna, do którego odwołuje się jakieś zwierzę:
```
ERROR:  insert or update on table "zwierzeta" violates foreign key constraint "fk_opiekun"
ERROR:  update or delete on table "opiekunowie" violates foreign key constraint "fk_opiekun" on table "zwierzeta"
```
Zmianę tego zachowania (`ON DELETE CASCADE`, `ON DELETE SET NULL`) omawiamy na kolejnych zajęciach.

`NULL` oznacza brak wartości, więc ograniczenia traktują go w szczególny sposób:
* `CHECK` przepuszcza `NULL`, bo warunek nie jest ani prawdziwy, ani fałszywy. Jeśli wartość jest wymagana, dodaj też `NOT NULL`.
* `UNIQUE` domyślnie dopuszcza wiele wierszy z `NULL`, bo dwa `NULL` nie są traktowane jako równe.

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

### Część 2: Normalizacja — wyjaśnienie pojęć
**Normalizacja** to takie dzielenie danych na tabele, żeby każdy fakt był zapisany tylko w jednym miejscu. Celem jest usunięcie powtórzeń i błędów, które z nich wynikają.

#### Anomalie
Anomalie to problemy pojawiające się przy zmienianiu danych w źle zaprojektowanej tabeli. Na przykładzie tabeli `wypozyczenia_flat` z demo poniżej:

| Anomalia | Na czym polega | Przykład |
|---|---|---|
| aktualizacji | ten sam fakt trzeba zmienić w wielu wierszach | zmiana e-maila Jana wymaga poprawy 2 wierszy; pominięcie jednego daje sprzeczne dane |
| wstawiania | nie da się zapisać jednego faktu bez drugiego | nowej książki nie można dodać, dopóki ktoś jej nie wypożyczy |
| usuwania | usunięcie wiersza kasuje też inne informacje | usunięcie jedynego wypożyczenia Piotra kasuje jego dane kontaktowe |

#### Zależność funkcyjna
Kolumna B zależy funkcyjnie od kolumny A (A → B), jeśli wartość A jednoznacznie wyznacza wartość B. Na przykład `email → imie`: znając e-mail czytelnika, znamy jego imię. Postacie normalne opisują, od czego powinny zależeć kolumny tabeli.

Każda kolejna postać normalna obejmuje wymagania poprzedniej. Poniższe przykłady pochodzą z innej domeny, czyli z uczelni.

#### 1NF: wartości atomowe
Każda komórka zawiera jedną wartość, a tabela nie ma powtarzających się grup kolumn (`telefon1`, `telefon2`...).

Naruszenie, czyli kilka numerów w jednej komórce:

| `student_id` | `nazwisko` | `telefony` |
|---|---|---|
| 1 | Kowalski | 600100200, 600100300 |

Takiej kolumny nie da się wygodnie przeszukiwać ani ograniczać. Rozwiązaniem jest osobna tabela `telefony_studentow (student_id, telefon)` z jednym numerem w wierszu.

#### 2NF: zależność od całego klucza
Kolumny niebędące częścią klucza zależą od **całego** klucza głównego, a nie od jego fragmentu. Ta postać ma znaczenie tylko przy kluczu złożonym z kilku kolumn.

Naruszenie w tabeli z kluczem `(student_id, przedmiot_id)`:

| `student_id` | `przedmiot_id` | `ocena` | `nazwa_przedmiotu` |
|---|---|---|---|
| 1 | 10 | 4.5 | Algebra |
| 2 | 10 | 3.0 | Algebra |

`ocena` zależy od całego klucza, ale `nazwa_przedmiotu` tylko od `przedmiot_id`. Rozwiązanie to tabele `oceny (student_id, przedmiot_id, ocena)` i `przedmioty (id, nazwa)`.

#### 3NF: brak zależności przechodnich
Kolumny niebędące kluczem zależą bezpośrednio od klucza, a nie od innej kolumny niebędącej kluczem. Skrót myślowy: każda kolumna opisuje klucz, cały klucz i nic poza kluczem.

Naruszenie w tabeli z kluczem `id`:

| `id` | `nazwisko` | `wydzial_id` | `wydzial_nazwa` |
|---|---|---|---|
| 1 | Kowalski | 3 | Informatyka |
| 2 | Nowak | 3 | Informatyka |

Tutaj `id → wydzial_id → wydzial_nazwa`, czyli nazwa wydziału opisuje wydział, a nie studenta. Rozwiązanie to tabele `studenci (id, nazwisko, wydzial_id)` i `wydzialy (id, nazwa)`.

Tabela `wypozyczenia_flat` ma ten sam problem. Jej klucz `id` jest jednokolumnowy, więc 2NF jest spełniona, ale 3NF już nie: `czytelnik_email → czytelnik_imie` oraz `ksiazka_tytul → ksiazka_autor` (w tych danych każdy tytuł ma jednego autora).

#### Migracja danych
Po zaprojektowaniu nowych tabel dane przenosi się bez przepisywania ich ręcznie:
* `INSERT ... SELECT` wstawia do tabeli wynik zapytania,
* `DISTINCT` usuwa powtórzenia, więc każdy czytelnik i każda książka trafia do swojej tabeli raz,
* `JOIN` tabeli płaskiej z nowymi tabelami pozwala odnaleźć wygenerowane identyfikatory, potrzebne w tabeli faktów.

Tabela faktów opisuje zdarzenia, tutaj pojedyncze wypożyczenia. Musi mieć tyle wierszy, ile tabela źródłowa. Inna liczba oznacza, że przy migracji część danych zginęła albo się powieliła.

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
