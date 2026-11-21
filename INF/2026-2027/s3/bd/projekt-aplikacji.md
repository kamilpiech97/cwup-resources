## Projekt aplikacji z bazą danych (zajęcia 9-15)

Projekt realizowany przez wszystkie osoby na **standardowej ścieżce** zaliczenia laboratorium. Zajęcia 9-14 odbywają się zdalnie i są poświęcone budowie projektu, na zajęciach 15 odbywa się jego obrona.

Nie jest to projekt z [`zaliczenie-projektowe.md`](zaliczenie-projektowe.md) — tamten zastępuje całe laboratorium i ma dużo szerszy zakres. Ten projekt jest mniejszy: zakłada, że SQL, normalizację i ERD masz już przećwiczone na zajęciach 1-8, i skupia się na podłączeniu bazy do aplikacji.

### Temat
* temat wybierasz samodzielnie (np. biblioteka, warsztat samochodowy, siłownia, schronisko, rezerwacja sal...),
* temat **nie może** być sklepem internetowym — tę domenę znasz już z zajęć 2-8,
* możesz wrócić do tematu własnej bazy z zajęć 2 i go rozbudować,
* praca jest indywidualna,
* temat zapisujesz w `README.md` repozytorium do końca zajęć 9.

### Zakres projektu (wymagania minimalne)

**1. Baza danych**
* min. **4 tabele**, w tym co najmniej jedna relacja **1:N** i jedna relacja **N:M** (z tabelą łączącą),
* schemat w 3NF,
* klucze główne i obce, `NOT NULL` tam, gdzie ma to sens, min. jedno ograniczenie `CHECK` i jedno `UNIQUE`,
* baza uruchamiana w Dockerze (Postgres), zgodnie ze standardem z zajęć 1,
* skrypty `schema.sql` (struktura) i `seed.sql` (dane testowe) w repozytorium — min. 20 wierszy w każdej z głównych tabel, tak żeby listy i zestawienia w aplikacji miały co pokazać,
* diagram ERD (dbdiagram.io lub inne narzędzie) odzwierciedlający finalny schemat.

**2. Aplikacja**
* dowolny stos technologiczny (aplikacja webowa, desktopowa lub konsolowa z menu),
* dane połączenia z bazą w konfiguracji (np. plik `.env`), nie wpisane na sztywno w kodzie,
* pełny CRUD (dodawanie, lista, edycja, usuwanie) dla **min. 2 tabel**, w tym jednej z kluczem obcym — wartość klucza obcego wybierana z listy (np. lista rozwijana), a nie wpisywana jako numer,
* lista z danymi z kilku tabel (`JOIN`) — wyświetla nazwy, nie identyfikatory,
* obsługa relacji N:M — możliwość przypisania i usunięcia powiązania (np. dopisanie czytelnika do wypożyczenia, zapisanie klienta na zajęcia),
* min. jeden widok z zestawieniem (`GROUP BY`, np. liczba wypożyczeń na książkę, przychód w miesiącu),
* wyszukiwanie lub filtrowanie na min. jednej liście,
* walidacja danych wejściowych po stronie aplikacji (puste pola, niepoprawne liczby/daty),
* zapytania parametryzowane — bez sklejania stringów do SQL,
* naruszenie ograniczenia w bazie (`CHECK`/`UNIQUE`/`FK`) kończy się czytelnym komunikatem dla użytkownika, a nie surowym błędem SQL lub zamknięciem aplikacji.

**3. Dokumentacja** — `README.md` zawierający:
* opis tematu,
* instrukcję uruchomienia od zera (baza + aplikacja),
* diagram ERD (obrazek lub link).

**Nie jest wymagane:** logowanie użytkowników, wdrożenie na serwer, dopracowany wygląd, testy automatyczne. Można je dodać, ale nie podnoszą oceny kosztem brakujących wymagań minimalnych.

### Obrona (zajęcia 15)
Około 10 minut na osobę:
* krótka prezentacja działającej aplikacji (uruchomionej na Twoim komputerze),
* pytania prowadzącego o wybrane fragmenty kodu, zapytań i schematu,
* niewielka modyfikacja na żywo (np. dodanie kolumny do tabeli i pola w formularzu, zmiana warunku w zapytaniu).

Możesz korzystać z dowolnych narzędzi, w tym z AI — ale na obronie musisz rozumieć i umieć zmienić każdy fragment swojego projektu.

### Kryteria oceny
* baza danych (schemat, ograniczenia, dane testowe, ERD) — 25%
* aplikacja (realizacja wymagań z punktu 2) — 35%
* obrona (rozumienie własnego kodu, modyfikacja na żywo) — 40%

Obrona musi być zaliczona (min. 50%), żeby zaliczyć projekt — działająca aplikacja bez umiejętności jej objaśnienia nie wystarczy.
