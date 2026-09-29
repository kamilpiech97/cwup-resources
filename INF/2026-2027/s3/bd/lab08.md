## Implementacja ERD w bazie danych

### Cele zajęć
* przełożenie własnego diagramu ERD (z lab07) na `CREATE TABLE`,
* wdrożenie rozszerzenia w bazie sklepu, wstawienie danych testowych,
* walidacja poprawności kluczy obcych.

To ostatnie zajęcia na wspólnej bazie "sklep" — od następnego laboratorium (lab09) zaczyna się indywidualny projekt aplikacji.

### Przykład implementacji (rozszerzenie: promocje, z lab07)
```sql
CREATE TABLE promocje (
    id              SERIAL PRIMARY KEY,
    nazwa           VARCHAR(100) NOT NULL,
    rabat_procent   NUMERIC(5,2) NOT NULL CHECK (rabat_procent > 0 AND rabat_procent <= 100),
    data_od         DATE NOT NULL,
    data_do         DATE NOT NULL,
    CHECK (data_do >= data_od)
);

CREATE TABLE produkty_promocje (
    produkt_id      INTEGER NOT NULL REFERENCES produkty(id),
    promocja_id     INTEGER NOT NULL REFERENCES promocje(id),
    PRIMARY KEY (produkt_id, promocja_id)
);
```

Dane testowe:
```sql
INSERT INTO promocje (nazwa, rabat_procent, data_od, data_do) VALUES
    ('Black Friday', 20.00, '2026-11-27', '2026-11-30'),
    ('Wyprzedaż letnia', 15.00, '2026-06-01', '2026-06-30');

INSERT INTO produkty_promocje (produkt_id, promocja_id) VALUES
    (1, 1), (2, 1), (3, 1), (1, 2);
```

Walidacja — FK musi działać poprawnie:
```sql
-- powinno zwrócić błąd (nieistniejący produkt_id)
INSERT INTO produkty_promocje (produkt_id, promocja_id) VALUES (99999, 1);

-- zapytanie sprawdzające: produkty objęte promocją "Black Friday"
SELECT p.nazwa, p.cena, pr.nazwa AS promocja, pr.rabat_procent
FROM produkty_promocje pp
JOIN produkty p ON p.id = pp.produkt_id
JOIN promocje pr ON pr.id = pp.promocja_id
WHERE pr.nazwa = 'Black Friday';
```

### Zadania do wykonania
1. Przepisz własny diagram ERD (z lab07) na polecenia `CREATE TABLE` — min. 2 nowe tabele, relacja N:M z kluczem złożonym lub osobnym PK, FK do istniejącego schematu sklepu.
2. Wstaw min. 5-10 rekordów testowych do każdej nowej tabeli.
3. Zweryfikuj FK — spróbuj wstawić rekord z nieistniejącym kluczem obcym, zapisz komunikat błędu.
4. Napisz min. 1 zapytanie `JOIN` pokazujące sens rozszerzenia (jak w przykładzie powyżej).

### Co oddajemy
* plik `.sql` z `CREATE TABLE`, `INSERT`, zapytaniem `JOIN` i wynikiem,
* diagram ERD (z lab07, ew. poprawiony po implementacji).
