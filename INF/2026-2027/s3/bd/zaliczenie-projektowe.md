## Alternatywne zaliczenie laboratorium — projekt indywidualny

Zaliczenie laboratorium z przedmiotu Bazy danych **w całości jednym projektem**, zamiast udziału w 15 blokach zajęć.

### Dla kogo
Dla osób, które z jakiegoś powodu nie mogą regularnie uczestniczyć w zajęciach (praca, kolizja w planie, inne). Ścieżka projektowa **nie jest łatwiejsza** — realizuje dokładnie te same efekty uczenia się (W01, U01, U02, U03 z karty modułu), tylko bez cotygodniowego prowadzenia za rękę. Wymaga więcej samodzielnej organizacji pracy niż uczęszczanie na laby.

### Zgłoszenie
Decyzję zgłasza się prowadzącemu **do końca 2-3 zajęć**. Wybór jest wiążący na cały semestr. Osoba na ścieżce projektowej nie musi przychodzić na laby 2-14 (chyba że chce skonsultować coś na miejscu).

### Zakres projektu
Projekt musi pokrywać wszystkie kompetencje, które dają laby 1-15 — w praktyce oznacza to własną, kompletną aplikację z bazą danych, obejmującą:

**1. Projekt i implementacja schematu bazy danych** (odpowiednik lab02-05, 07-08)
* min. **6 tabel**, w tym co najmniej jedna relacja **1:N** i jedna relacja **N:M** (z tabelą łączącą),
* schemat w **3NF** — zero powtarzalnych grup, zero redundancji dającej się usunąć normalizacją,
* klucze główne, klucze obce, ograniczenia `CHECK`/`UNIQUE`/`NOT NULL` tam, gdzie mają sens biznesowy,
* diagram ERD (dbdiagram.io lub inne narzędzie) — odzwierciedlający finalny schemat,
* baza uruchomiona w Dockerze (Postgres), zgodnie ze standardem z lab01.

**2. Zestaw zapytań SQL** (odpowiednik lab03, 04, 06) — min. **20 zapytań** pokrywających:
* selekcję i projekcję z różnymi operatorami `WHERE` (min. 3 różne),
* sortowanie i ograniczanie wyników (`ORDER BY`, `LIMIT`),
* min. 3 zapytania z `JOIN` (w tym przynajmniej jedno łączące 3+ tabele),
* min. 2 zapytania z `GROUP BY`/`HAVING`,
* min. 2 podzapytania,
* min. 2 operacje `UPDATE`/`DELETE` z warunkiem,
* min. 1 transakcję (`BEGIN`/`COMMIT`/`ROLLBACK`) na scenariuszu wielokrokowym.

**3. Dane testowe** — realistyczna ilość danych (rząd wielkości: dziesiątki-setki wierszy na tabelę), nie 3 przykładowe rekordy — inaczej zapytania z punktu 2 nie mają na czym sensownie działać.

**4. Aplikacja z interfejsem użytkownika**
* dowolny stos technologiczny,
* pełny CRUD z poziomu UI (formularze, widoki listy, edycja, usuwanie),
* obsługa relacji w UI (np. lista rozwijana dla kluczy obcych), walidacja danych wejściowych po stronie serwera,
* zapytania parametryzowane (bez konkatenacji stringów do SQL),
* czytelna obsługa błędów (naruszenie `CHECK`/`UNIQUE`/`FK` nie wywala aplikacji surowym błędem SQL).

**5. Dokumentacja**
* `README.md`: opis tematu, instrukcja uruchomienia (Docker + aplikacja), opis schematu bazy,
* diagram ERD,
* krótkie uzasadnienie (pół strony): jakie decyzje projektowe podjęto przy normalizacji i dlaczego.

### Repozytorium i historia pracy
Praca musi być widoczna w repozytorium git **rozłożona w czasie**, nie jednym commitem na końcu semestru. 
Przyrost wartości aplikacji etapami (schemat → dane → zapytania → aplikacja → dopracowanie) — historia commitów jest jednym z elementów oceny i zastępuje weryfikację obecności, jaką dają cotygodniowe zajęcia.

### Obrona końcowa
Na ostatnich zajęciach — prezentacja projektu, pytania prowadzącego o konkretne fragmenty kodu/zapytań, modyfikacja czegoś na żywo. 
To główne zabezpieczenie przed oddaniem projektu napisanego przez kogoś innego lub w całości przez AI bez zrozumienia.

### Kryteria oceny
* poprawność i jakość schematu bazy (normalizacja, klucze, ograniczenia) — 25%
* zestaw zapytań SQL (poprawność, różnorodność, czy pokrywają wymagany zakres) — 25%
* aplikacja z UI (kompletność CRUD, obsługa relacji/błędów, walidacja) — 25%
* obrona ustna (rozumienie własnego kodu i decyzji projektowych) — 25%

Każdy z czterech elementów musi być zaliczony na min. 50%, żeby zaliczyć laboratorium — nie da się skompensować słabej obrony bardzo dobrym kodem (i odwrotnie).
