## Środowisko pracy: Docker + pgAdmin

Na zajęciach standardem jest praca w kontenerach Docker — jedno środowisko dla wszystkich, mniej problemów z "u mnie działa". Instalacja natywna PostgreSQL jest dopuszczalna dla chętnych, ale **bez wsparcia technicznego na zajęciach** — w razie problemów wracamy do Dockera.

### Wymagania wstępne
* zainstalowany [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac) lub Docker Engine + docker-compose-plugin (Linux),
* sprawdzić instalację:
```bash
docker --version
docker compose version
```

### Plik `docker-compose.yml`
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

### Uruchomienie
```bash
docker compose up -d
```
Sprawdzenie, że oba kontenery działają:
```bash
docker compose ps
```

### Połączenie pgAdmin z bazą
1. Otwórz przeglądarkę: [http://localhost:8080](http://localhost:8080), zaloguj się (`student@example.com` / `student`).
2. **Add New Server** → zakładka *General*: nazwa np. `bd-lokalnie`.
3. Zakładka *Connection*:
   * Host name/address: `db` (nazwa usługi z docker-compose, nie `localhost`!)
   * Port: `5432`
   * Username: `student`
   * Password: `student`
4. Zapisz — w drzewie po lewej pojawi się baza `cwiczenia`.

### Pierwsze zapytanie
W pgAdmin: PPM na bazę `cwiczenia` → **Query Tool**:
```sql
SELECT version();
```

Alternatywa z linii poleceń (psql wewnątrz kontenera):
```bash
docker exec -it bd_postgres psql -U student -d cwiczenia -c "\dt"
```

### Zatrzymanie/restart środowiska
```bash
docker compose stop      # zatrzymuje kontenery, dane zostają
docker compose down      # usuwa kontenery, wolumin z danymi zostaje
docker compose down -v   # usuwa też dane (pełny reset od zera)
```
