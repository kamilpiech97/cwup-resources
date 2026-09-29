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
* ocena indywidualnego projektu aplikacji z bazą danych (zajęcia 9-15),
* obrona ustna projektu na ostatnich zajęciach (zajęcia 14-15),

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

### Literatura
* Hector Garcia-Molina, Jeffrey D. Ullman, Jennifer Widom, *Systemy baz danych. Kompletny podręcznik*, Wydanie II, Helion 2011
* P. Beynon-Davies, *Systemy baz danych*, WNT, Warszawa 2003
* Connolly T., Begg C., *Systemy baz danych*, T1, T2, Warszawa 2004

### Literatura uzupełniająca
* Hernandez M.J., *Projektowanie baz danych dla każdego. Przewodnik krok po kroku*, Wydanie IV, Helion 2022

---

### Środowisko pracy: Docker + pgAdmin

Na zajęciach standardem jest praca w kontenerach Docker — jedno środowisko dla wszystkich, mniej problemów z "u mnie działa". Instalacja natywna PostgreSQL jest dopuszczalna dla chętnych, ale **bez wsparcia technicznego na zajęciach** — w razie problemów wracamy do Dockera.

#### Wymagania wstępne
* zainstalowany [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac) lub Docker Engine + docker-compose-plugin (Linux),
* sprawdzić instalację:
```bash
docker --version
docker compose version
```

#### Plik `docker-compose.yml`
W katalogu kursu (`bd/`) znajduje się gotowy plik `docker-compose.yml`:
```yaml
services:
  db:
    image: postgres:16-alpine
    container_name: bd_postgres
    environment:
      POSTGRES_USER: student
      POSTGRES_PASSWORD: student
      POSTGRES_DB: cwiczenia
    ports:
      - "5432:5432"
    volumes:
      - db_data:/var/lib/postgresql/data

  pgadmin:
    image: dpage/pgadmin4
    container_name: bd_pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: student@example.com
      PGADMIN_DEFAULT_PASSWORD: student
    ports:
      - "8080:80"
    depends_on:
      - db

volumes:
  db_data:
```

#### Uruchomienie
```bash
docker compose up -d
```
Sprawdzenie, że oba kontenery działają:
```bash
docker compose ps
```

#### Połączenie pgAdmin z bazą
1. Otwórz przeglądarkę: [http://localhost:8080](http://localhost:8080), zaloguj się (`student@example.com` / `student`).
2. **Add New Server** → zakładka *General*: nazwa np. `bd-lokalnie`.
3. Zakładka *Connection*:
   * Host name/address: `db` (nazwa usługi z docker-compose, nie `localhost`!)
   * Port: `5432`
   * Username: `student`
   * Password: `student`
4. Zapisz — w drzewie po lewej pojawi się baza `cwiczenia`.

#### Pierwsze zapytanie
W pgAdmin: PPM na bazę `cwiczenia` → **Query Tool**:
```sql
SELECT version();
```

Alternatywa z linii poleceń (psql wewnątrz kontenera):
```bash
docker exec -it bd_postgres psql -U student -d cwiczenia -c "\dt"
```

#### Zatrzymanie/restart środowiska
```bash
docker compose stop      # zatrzymuje kontenery, dane zostają
docker compose down      # usuwa kontenery, wolumin z danymi zostaje
docker compose down -v   # usuwa też dane (pełny reset od zera)
```

### Zadanie do wykonania
* uruchomić środowisko (`docker compose up -d`),
* połączyć pgAdmin z bazą `cwiczenia`,
* wykonać `SELECT version();` i zapisać zrzut ekranu z wynikiem,
* oddać: zrzut ekranu połączonego pgAdmin + wynik zapytania.
