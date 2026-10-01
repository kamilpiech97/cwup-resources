## Wprowadzenie do przedmiotu Bazy danych. Środowisko pracy (Docker + pgAdmin)

### Agenda
Przewidywany plan zajęć kształtuje się następująco:
* przedstawienie zasad zaliczenia przedmiotu,
* przedstawienie planu tematów i zajęć na cały semestr,
* uruchomienie środowiska pracy (Docker: PostgreSQL + pgAdmin),
* pierwsze połączenie z bazą danych.

### Zasady zaliczenia przedmiotu
Zajęcia i obecność:
* w trakcie semestru zostanie zrealizowanych 15 zajęć laboratoryjnych (bloki 90-minutowe),
* obecność jest obowiązkowa, dopuszczalne są dwie nieusprawiedliwione nieobecności,
* zajęcia 9-14 (bloki dot. projektu aplikacji) odbywają się zdalnie — obecność weryfikowana commitami w repozytorium git w oknie czasowym zajęć.

Forma zaliczenia laboratorium: **zaliczenie z oceną** (zgodnie z kartą modułu).

Elementy oceny:
* sprawozdania z zajęć 1-8 (skrypty `.sql`, eksporty ERD) — oddawane po każdym bloku,
* ocena indywidualnego projektu aplikacji z bazą danych wraz z obroną ustną na ostatnich zajęciach (zajęcia 9-15).

### Oddawanie zadań — repozytorium git
* zadania z każdego bloku laboratoryjnego oddawane są w repozytorium git studenta — nie mailem, nie na pendrive,
* każdy student zakłada własne repozytorium (np. na GitHub/GitLab) i udostępnia je prowadzącemu na początku semestru,
* commity powinny być robione na bieżąco, po każdym bloku — commit z całym semestrem na koniec nie będzie uznany,
* strukturę katalogów i nazewnictwo repo ustala prowadzący na pierwszych zajęciach,
* przykładowy workflow (założenie repo, struktura, commity, ściąga z komend): [`resources/git-workflow.md`](resources/git-workflow.md).

### Alternatywna ścieżka zaliczenia — projekt zamiast laboratorium
Zamiast udziału w 15 blokach laboratoryjnych, laboratorium można zaliczyć w całości jednym, samodzielnie realizowanym projektem.

* decyzję o wyborze tej ścieżki należy zgłosić prowadzącemu **do końca 2-3 zajęć**,
* pełne wymagania, harmonogram checkpointów i kryteria oceny: [`zaliczenie-projektowe.md`](zaliczenie-projektowe.md),
* wybór jest wiążący na cały semestr — nie ma przełączania się między ścieżkami w trakcie.

### Przegląd tematów w semestrze
1. Wprowadzenie do przedmiotu. Środowisko pracy (Docker + pgAdmin)
2. Pierwsza baza danych — CREATE TABLE, typy danych, INSERT
3. Selekcja i projekcja w SQL (WHERE, ORDER BY, LIMIT)
4. Zapytania złożone — JOIN, GROUP BY, HAVING, podzapytania
5. Modyfikacja schematu bazy danych (DDL) i normalizacja
6. Modyfikacja danych (DML), transakcje, integralność referencyjna
7. Projektowanie diagramów ERD
8. Implementacja ERD w bazie danych
9. Start projektu aplikacji z bazą danych (środowisko, połączenie z DB)
10. Operacje CRUD z poziomu aplikacji
11. Projekt — interfejs użytkownika, część 1 (formularze)
12. Projekt — interfejs użytkownika, część 2 (widoki danych)
13. Projekt — interfejs użytkownika, część 3 (relacje, walidacja)
14. Projekt — interfejs użytkownika, część 4 (dopracowanie)
15. Testowanie, weryfikacja i obrona projektu

### Oryginalna lista z karty modułu
1. Przedstawienie treści karty modułu. Zapoznanie z programem umożliwiającym interakcyjną pracę z bazą danych — 4h
2. Edycja i wykonywanie zapytań selekcji i projekcji w języku SQL — 4h
3. Modyfikacja schematów bazy danych, modyfikacja danych w SQL — 4h
4. Projektowanie diagramów ERD w dedykowanych narzędziach — 4h
5. Zapoznanie z możliwościami tworzenia aplikacji z bazą danych w określonym środowisku — 4h
6. Zaprojektowanie i wykonanie interfejsu użytkownika systemu z bazą danych — 8h
7. Testowanie i weryfikacja aplikacji z bazą danych — 2h

### Literatura
* Hector Garcia-Molina, Jeffrey D. Ullman, Jennifer Widom, *Systemy baz danych. Kompletny podręcznik*, Wydanie II, Helion 2011
* P. Beynon-Davies, *Systemy baz danych*, WNT, Warszawa 2003
* Connolly T., Begg C., *Systemy baz danych*, T1, T2, Warszawa 2004

### Literatura uzupełniająca
* Hernandez M.J., *Projektowanie baz danych dla każdego. Przewodnik krok po kroku*, Wydanie IV, Helion 2022

---

### Środowisko pracy: Docker + pgAdmin
Pełna instrukcja konfiguracji środowiska (Docker, `docker-compose.yml`, połączenie pgAdmin, pierwsze zapytanie): [`resources/srodowisko-docker.md`](resources/srodowisko-docker.md).

### Zadanie do wykonania
* uruchomić środowisko (`docker compose up -d`),
* połączyć pgAdmin z bazą `cwiczenia`,
* wykonać `SELECT version();` i zapisać zrzut ekranu z wynikiem,
* oddać: zrzut ekranu połączonego pgAdmin + wynik zapytania.
