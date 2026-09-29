## Zapytania złożone — JOIN, GROUP BY, HAVING, podzapytania

### Cele zajęć
* łączenie danych z wielu tabel (`INNER JOIN`, `LEFT JOIN`),
* agregacje: `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `GROUP BY`, `HAVING`,
* podzapytania (subqueries).

Praca dalej na wspólnej bazie "sklep" (z lab03).

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
