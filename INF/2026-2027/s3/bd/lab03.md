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
2. Wyświetl imię, nazwisko i miasto klientów z Wrocławia lub Poznania.
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
