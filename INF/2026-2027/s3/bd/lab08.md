## Implementacja ERD w bazie danych

### Cele zajęć
* przełożenie własnego diagramu ERD (z lab07) na `CREATE TABLE`,
* wdrożenie rozszerzenia w bazie sklepu, wstawienie danych testowych,
* walidacja poprawności kluczy obcych.

To ostatnie zajęcia na wspólnej bazie "sklep" — od następnego laboratorium (lab09) zaczyna się indywidualny projekt aplikacji.

### Wyjaśnienie pojęć
Diagram ERD opisuje, jakie dane i związki mają istnieć, a SQL zapisuje to w działającej bazie. Na tym etapie projekt nabiera szczegółów, których diagram nie pokazuje: dokładnych typów, ograniczeń i kolejności tworzenia tabel.

Przykłady w tej sekcji kontynuują uczelnię z lab07.

#### Z diagramu do SQL
| Element ERD | Odpowiednik w SQL |
|---|---|
| encja | `CREATE TABLE` |
| atrybut | kolumna z typem, np. `VARCHAR(50)`, `NUMERIC(5,2)`, `DATE` |
| klucz główny | `SERIAL PRIMARY KEY` |
| związek 1:N | kolumna FK po stronie "wielu": `INTEGER REFERENCES tabela(id)` |
| związek 1:1 | kolumna FK z dodatkowym `UNIQUE` |
| związek N:M | tabela łącząca z dwiema kolumnami FK |
| związek obowiązkowy | kolumna FK z `NOT NULL` |

Kolumna FK ma typ `INTEGER`, a nie `SERIAL`. `SERIAL` sam generuje kolejne numery, a klucz obcy ma wskazywać istniejący wiersz.

Reguły, których diagram zwykle nie pokazuje, zapisz jako ograniczenia z lab05: `NOT NULL`, `CHECK`, `UNIQUE`. Warunek dotyczący jednej kolumny można zapisać przy niej, a warunek obejmujący kilka kolumn zapisuje się osobno, na końcu `CREATE TABLE`. Tak zapisany jest `CHECK (data_do >= data_od)` w przykładzie poniżej.

#### Kolejność ma znaczenie
Klucz obcy może wskazywać tylko to, co już istnieje, dlatego zaczynaj od tabel nadrzędnych, a kończ na tabeli łączącej:

| Operacja | Kolejność | Błąd przy złej kolejności |
|---|---|---|
| `CREATE TABLE` | najpierw rodzic | `relation "kursy" does not exist` |
| `INSERT` | najpierw rodzic | `violates foreign key constraint "zapisy_student_id_fkey"` |
| `DROP TABLE` | najpierw dziecko | `cannot drop table studenci because other objects depend on it` |

#### Klucz tabeli łączącej
Tabela łącząca może mieć jeden z dwóch rodzajów klucza głównego:

| Wariant | Składnia | Kiedy stosować |
|---|---|---|
| klucz złożony | `PRIMARY KEY (student_id, kurs_id)` | para może wystąpić tylko raz, np. przypisanie produktu do promocji |
| osobny klucz | `id SERIAL PRIMARY KEY` | para może się powtarzać albo inne tabele mają wskazywać ten wiersz |

Osobny klucz sam nie blokuje duplikatów. Jeśli powtórzenia mają być ograniczone, dodaj `UNIQUE`. Poniżej ten sam student może powtórzyć kurs, ale tylko w innym semestrze:
```sql
CREATE TABLE zapisy (
    id          SERIAL PRIMARY KEY,
    student_id  INTEGER NOT NULL REFERENCES studenci(id),
    kurs_id     INTEGER NOT NULL REFERENCES kursy(id),
    semestr     VARCHAR(10) NOT NULL,
    UNIQUE (student_id, kurs_id, semestr)
);
```

#### Dane testowe
Dane testowe powinny sprawdzać związki, a nie tylko wypełniać tabele. Uwzględnij w nich:
* obiekt powiązany z wieloma obiektami, po obu stronach związku N:M (student na dwóch kursach i kurs z dwoma studentami),
* obiekt bez żadnego powiązania, żeby zobaczyć różnicę między `INNER JOIN` i `LEFT JOIN`,
* wartości graniczne, np. `NULL` w kolumnie opcjonalnej.

Przed wstawieniem wierszy z FK sprawdź identyfikatory rodziców przez `SELECT`. Numery z `SERIAL` mogą mieć luki, bo nieudany `INSERT` też zużywa numer. Po błędzie przy czwartym wierszu kolejny wiersz może dostać `id = 5`.

#### Walidacja schematu
Sam fakt, że `CREATE TABLE` się wykonał, nie dowodzi, że ograniczenia działają. Trzeba je sprawdzić, celowo wstawiając niepoprawne dane. Każda próba powinna skończyć się błędem:

| Co testujesz | Próba | Oczekiwany błąd |
|---|---|---|
| `FOREIGN KEY` | nieistniejący `student_id` | `violates foreign key constraint` |
| `PRIMARY KEY` lub `UNIQUE` | druga taka sama para | `duplicate key value violates unique constraint` |
| `NOT NULL` | `NULL` w wymaganej kolumnie | `violates not-null constraint` |
| `CHECK` | wartość spoza zakresu | `violates check constraint` |

Jeśli niepoprawny `INSERT` przejdzie, schemat ma lukę do poprawienia.

Na koniec napisz zapytanie, które przechodzi przez tabelę łączącą. Dwa `JOIN` łączą ją z obiema tabelami nadrzędnymi:
```sql
SELECT s.nazwisko, k.nazwa AS kurs, z.semestr
FROM zapisy z
JOIN studenci s ON s.id = z.student_id
JOIN kursy k ON k.id = z.kurs_id;
```

Jeśli zapytanie trudno napisać albo nie odpowiada na żadne sensowne pytanie, to sygnał, że projekt wymaga poprawy. Zaktualizuj wtedy również diagram, żeby zgadzał się z bazą.

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
