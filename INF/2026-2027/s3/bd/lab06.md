## Modyfikacja danych (DML), transakcje, integralność referencyjna

### Cele zajęć
* `UPDATE`, `DELETE` z warunkami,
* transakcje: `BEGIN`, `COMMIT`, `ROLLBACK`,
* integralność referencyjna: błędy `FOREIGN KEY`, `ON DELETE CASCADE`/`SET NULL`.

### Przygotowanie: robocza kopia bazy
Ćwiczenia w tym bloku modyfikują dane (w tym usuwanie), dlatego przed zajęciami zresetuj bazę do czystego stanu:
```bash
docker exec -i bd_postgres psql -U student -d cwiczenia < sql/00_reset.sql
docker exec -i bd_postgres psql -U student -d cwiczenia < sql/01_schema_sklep.sql
docker exec -i bd_postgres psql -U student -d cwiczenia < sql/02_seed_sklep.sql
```
Ten sam reset warto zrobić na początku kolejnych zajęć (lab07/lab08), jeśli dane zostaną mocno namieszane.

### Część 1: UPDATE / DELETE — wyjaśnienie pojęć
**DML** (Data Manipulation Language) to polecenia działające na wierszach: `INSERT`, `UPDATE`, `DELETE`. Zmieniają dane, ale nie strukturę tabeli, czym różnią się od poleceń DDL z poprzednich zajęć. Przykładowo `DELETE` usuwa wiersze, a sama tabela zostaje, natomiast `DROP TABLE` usuwa całą tabelę.

**`UPDATE`** zmienia istniejące wiersze. `SET` określa nowe wartości, a `WHERE` wskazuje, których wierszy dotyczy zmiana. Nowa wartość może zależeć od starej, jak w `SET cena = round(cena * 1.05, 2)`, gdzie po prawej stronie używana jest cena sprzed zmiany. Kolumny do zmiany rozdziela się przecinkami: `SET a = 1, b = 2`.

**`DELETE`** usuwa całe wiersze spełniające warunek `WHERE`. Do wyzerowania jednej wartości służy `UPDATE`, a nie `DELETE`.

Po wykonaniu baza zwraca liczbę zmienionych wierszy, np. `UPDATE 3` albo `DELETE 0`. Warto ją sprawdzać, bo `DELETE 0` nie jest błędem. Oznacza tylko, że żaden wiersz nie spełnił warunku.

Bezpieczny sposób pracy to sprawdzenie warunku przed modyfikacją. Ten sam `WHERE` najpierw uruchom w `SELECT`, a przy `UPDATE` możesz od razu podejrzeć nową wartość:
```sql
SELECT id, nazwa, cena, round(cena * 1.05, 2) AS nowa_cena
FROM produkty
WHERE kategoria_id = 3;
```

### Część 1: UPDATE / DELETE (na bazie sklep)
```sql
-- podwyżka cen o 5% w wybranej kategorii
UPDATE produkty
SET cena = round(cena * 1.05, 2)
WHERE kategoria_id = 3;

-- usunięcie starych, anulowanych zamówień
DELETE FROM zamowienia
WHERE status = 'anulowane' AND data_zamowienia < CURRENT_DATE - INTERVAL '180 days';
```

**Uwaga:** `UPDATE`/`DELETE` bez `WHERE` modyfikuje/wykasuje wszystkie wiersze — zawsze najpierw sprawdź warunek jako `SELECT`, dopiero potem zamień na `UPDATE`/`DELETE`.

### Część 2: Transakcje — wyjaśnienie pojęć
**Transakcja** to grupa poleceń traktowana jako jedna całość: zapisują się wszystkie albo żadne. Klasyczny przykład to przelew. Odjęcie pieniędzy z jednego konta bez dodania ich na drugie oznaczałoby utratę pieniędzy.

| Polecenie | Działanie |
|---|---|
| `BEGIN` | rozpoczyna transakcję |
| `COMMIT` | zatwierdza zmiany na stałe |
| `ROLLBACK` | cofa wszystkie zmiany od `BEGIN` |

Bez `BEGIN` każde polecenie jest osobną transakcją i zapisuje się od razu (autocommit). Jeśli wtedy pierwsze polecenie się uda, a drugie zgłosi błąd, zmiana z pierwszego zostanie w bazie.

`ROLLBACK` nie wymaga błędu. Można nim też cofnąć poprawne zmiany, np. gdy `UPDATE` zwrócił inną liczbę wierszy, niż oczekiwano.

#### Błąd w trakcie transakcji
Po błędzie PostgreSQL oznacza transakcję jako przerwaną i odrzuca kolejne polecenia, aż do jej zakończenia:
```
ERROR:  current transaction is aborted, commands ignored until end of transaction block
```
Przerwanej transakcji nie da się już zatwierdzić. Nawet po wpisaniu `COMMIT` baza wykona wycofanie i odpowie `ROLLBACK`.

#### ACID
Skrót ACID opisuje cztery gwarancje transakcji:

| Właściwość | Znaczenie | Przykład z demo |
|---|---|---|
| Atomicity (niepodzielność) | zapisuje się wszystko albo nic | jest wpis wypożyczenia i zmniejszony stan albo nie ma żadnej z tych zmian |
| Consistency (spójność) | transakcja nie może naruszyć ograniczeń | `CHECK` nie pozwala na ujemny stan magazynowy |
| Isolation (izolacja) | niezatwierdzone zmiany nie są widoczne dla innych sesji | druga sesja widzi stary stan aż do `COMMIT` |
| Durability (trwałość) | zatwierdzone zmiany przetrwają awarię | po `COMMIT` wypożyczenie zostaje nawet po restarcie serwera |

### Część 2: Transakcje (demo prowadzącego na żywo — inna baza)
Poniższy scenariusz działa na osobnych, małych tabelach `sprzet`/`wypozyczenia_sprzetu` — **nie na bazie sklepu**. Cel: pokazać mechanizm transakcji, nie gotowe rozwiązanie zadania.

```sql
CREATE TABLE sprzet (
    id                  SERIAL PRIMARY KEY,
    nazwa               VARCHAR(100),
    stan_magazynowy     INTEGER CHECK (stan_magazynowy >= 0)
);

CREATE TABLE wypozyczenia_sprzetu (
    id                  SERIAL PRIMARY KEY,
    sprzet_id           INTEGER REFERENCES sprzet(id),
    klient_nazwa        VARCHAR(100),
    data_wypozyczenia   DATE DEFAULT CURRENT_DATE
);

INSERT INTO sprzet (nazwa, stan_magazynowy) VALUES
    ('Wiertarka', 10), ('Kosiarka', 5), ('Drabina', 8);
```

Scenariusz: wypożyczenie sprzętu = wpis do `wypozyczenia_sprzetu` + zmniejszenie stanu magazynowego. Oba kroki powinny zapisać się razem albo wcale.

Udana transakcja:
```sql
BEGIN;

INSERT INTO wypozyczenia_sprzetu (sprzet_id, klient_nazwa)
VALUES (1, 'Jan Kowalski');

UPDATE sprzet
SET stan_magazynowy = stan_magazynowy - 1
WHERE id = 1;

COMMIT;
```

Symulacja błędu w środku transakcji → `ROLLBACK` (próba zdjęcia więcej sztuk niż jest na stanie, narusza `CHECK`):
```sql
BEGIN;

INSERT INTO wypozyczenia_sprzetu (sprzet_id, klient_nazwa)
VALUES (2, 'Anna Nowak');

UPDATE sprzet
SET stan_magazynowy = stan_magazynowy - 999
WHERE id = 2;
-- błąd: narusza CHECK (stan_magazynowy >= 0)

ROLLBACK;

-- sprawdzenie: wypożyczenia dla Anny Nowak nie ma, bo cała transakcja się cofnęła
SELECT * FROM wypozyczenia_sprzetu WHERE klient_nazwa = 'Anna Nowak';
```

### Część 3: Integralność referencyjna — wyjaśnienie pojęć
**Integralność referencyjna** oznacza, że każda wartość klucza obcego wskazuje istniejący wiersz. Dzięki temu w bazie nie ma "osieroconych" rekordów, np. wypożyczenia nieistniejącego sprzętu. Pilnuje tego ograniczenie `FOREIGN KEY`.

W relacji są dwie strony:
* tabela **nadrzędna** (rodzic) jest wskazywana przez klucz obcy, np. `sprzet`,
* tabela **podrzędna** (dziecko) zawiera klucz obcy, np. `wypozyczenia_sprzetu`.

Klucz obcy może mieć wartość `NULL`, chyba że kolumna ma `NOT NULL`. Oznacza to wtedy brak powiązania.

#### Usuwanie wiersza nadrzędnego
Klauzula `ON DELETE` określa, co się stanie z dziećmi po usunięciu rodzica:

| Opcja | Efekt | Kiedy stosować |
|---|---|---|
| brak (domyślnie `NO ACTION`) | błąd, rodzic nie zostaje usunięty | gdy dzieci są ważną historią, np. wypożyczenia |
| `ON DELETE CASCADE` | dzieci są usuwane razem z rodzicem | gdy dziecko nie ma sensu bez rodzica, np. pozycja zamówienia bez zamówienia |
| `ON DELETE SET NULL` | klucz obcy dzieci przyjmuje `NULL`, wiersze zostają | gdy powiązanie jest opcjonalne, np. zadanie bez przypisanego pracownika |

Na co uważać:
* `CASCADE` usuwa dane bez ostrzeżenia i może objąć kolejne tabele. Jedno polecenie `DELETE` może więc skasować znacznie więcej wierszy, niż zwróci w komunikacie, bo liczy tylko wiersze rodzica.
* `SET NULL` nie zadziała, jeśli kolumna klucza obcego ma `NOT NULL`. Usunięcie rodzica zakończy się wtedy błędem.

W bazie "sklep" `pozycje_zamowien.zamowienie_id` ma `ON DELETE CASCADE`, więc usunięcie zamówienia usuwa też jego pozycje.

### Część 3: Integralność referencyjna
Próba usunięcia sprzętu, który ma powiązane wypożyczenia — powinna zwrócić błąd FK:
```sql
DELETE FROM sprzet WHERE id = 1;
-- ERROR: update or delete on table "sprzet" violates foreign key constraint...
```

Test `ON DELETE CASCADE` — na nowej, testowej relacji:
```sql
CREATE TABLE wlasciciele_test (id SERIAL PRIMARY KEY, nazwa VARCHAR(100));
CREATE TABLE przedmioty_test (
    id SERIAL PRIMARY KEY,
    wlasciciel_id INTEGER REFERENCES wlasciciele_test(id) ON DELETE CASCADE
);

INSERT INTO wlasciciele_test (nazwa) VALUES ('Testowy Właściciel');
INSERT INTO przedmioty_test (wlasciciel_id) VALUES (1);

DELETE FROM wlasciciele_test WHERE id = 1;
-- właściciel usunięty, powiązany przedmiot_test też (CASCADE)

SELECT * FROM przedmioty_test; -- puste
```

Wariant `ON DELETE SET NULL`:
```sql
CREATE TABLE przedmioty_test2 (
    id SERIAL PRIMARY KEY,
    wlasciciel_id INTEGER REFERENCES wlasciciele_test(id) ON DELETE SET NULL
);
```

### Zadania do wykonania
Zadania 1-4 wykonaj **na bazie sklep**:
1. Napisz i wykonaj `UPDATE` zmieniający `ilosc_magazyn` dla produktów z wybranej kategorii (np. +50 sztuk).
2. Napisz `DELETE` usuwający pozycje zamówień o `ilosc = 1` dla zamówień starszych niż 180 dni.
3. Odtwórz scenariusz udanej transakcji (`BEGIN`...`COMMIT`) na bazie sklep — nowe zamówienie (`zamowienia`) + min. 2 pozycje (`pozycje_zamowien`).
4. Znajdź przez `SELECT` klienta, który ma co najmniej jedno zamówienie, a potem spróbuj go usunąć przez `DELETE FROM klienci` — zapisz komunikat błędu i wyjaśnij jednym zdaniem, dlaczego baza odrzuciła to polecenie.
5. Zbuduj własny mini-przykład `ON DELETE CASCADE` i `ON DELETE SET NULL` na własnych, testowych tabelach (inna nazwa niż w demo) — pokaż różnicę w działaniu.
6. Napisz `UPDATE`, który zmienia status na `'w realizacji'` dla wszystkich zamówień ze statusem `'nowe'`, złożonych wcześniej niż 7 dni temu.
7. Napisz `DELETE` usuwający pozycje zamówień dotyczące produktów o niskim stanie magazynowym (`ilosc_magazyn < 5`). Zanim wykonasz — zastanów się i zapisz jednym zdaniem: czy to bezpieczne działanie (usuwanie historii sprzedaży na podstawie bieżącego stanu magazynu)?
8. Odtwórz scenariusz transakcji w dwóch wariantach na bazie sklep: (a) nowe zamówienie + pozycje kończące się `COMMIT`, (b) analogiczna transakcja, w której jedna z pozycji celowo narusza `FOREIGN KEY` (nieistniejący `produkt_id`), kończąca się `ROLLBACK`. Porównaj stan tabeli `zamowienia` po obu operacjach.

### Co oddajemy
* plik `.sql` z zadaniami 1-2, 5-8 (z wynikami/komunikatami błędów jako komentarze),
* krótki opis (2-3 zdania) obserwacji z transakcji i integralności referencyjnej.
