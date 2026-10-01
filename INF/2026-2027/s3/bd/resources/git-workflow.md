## Praca z repozytorium git — przykład

Zadania z laboratorium oddawane są w repozytorium git studenta (zob. sekcja "Oddawanie zadań" w [`lab01.md`](../lab01.md)). Poniżej przykładowy workflow na cały semestr.

### Założenie repozytorium (raz, na początku semestru)
1. Załóż puste repo na GitHub/GitLab, np. `bd-{numer-indeksu}`.
2. Udostępnij je prowadzącemu (dodaj jako collaborator albo ustaw publiczne — zależnie od ustaleń z zajęć 1).
3. Sklonuj lokalnie:
```bash
git clone git@github.com:{login}/bd-{numer-indeksu}.git
cd bd-{numer-indeksu}
```

### Sugerowana struktura katalogów
```
bd-123456/
├── lab02/
│   ├── create.sql
│   └── insert.sql
├── lab03/
│   └── select.sql
├── lab07/
│   └── erd.png
├── projekt/
│   └── ...
└── README.md
```
Jeden katalog na zajęcia — nazewnictwo ustalone na pierwszych zajęciach (`labNN/`).

### `.gitignore`
Warto od razu dodać, żeby nie commitować śmieci:
```
.DS_Store
*.log
node_modules/
.env
__pycache__/
```

### Codzienny workflow (po każdym bloku)
```bash
# sprawdź co się zmieniło
git status

# dodaj nowe/zmienione pliki z danego laboratorium
git add lab04/

# commit z sensownym opisem
git commit -m "lab04: zapytania JOIN i GROUP BY"

# wyślij na zdalne repo
git push
```

### Przykładowa historia commitów
```
lab02: CREATE TABLE + INSERT, schemat sklep
lab03: zapytania SELECT z WHERE, ORDER BY, LIMIT
lab04: JOIN, GROUP BY, HAVING, podzapytania
lab05: normalizacja schematu do 3NF
lab06: transakcje, FK, integralność referencyjna
lab07: diagram ERD (export z narzędzia)
lab09: init projektu, połączenie z DB
lab10: operacje CRUD — szkielet
```
Zasada: **commit po każdym bloku, nie jeden zbiorczy commit na koniec semestru** — historia ma pokazywać postęp w czasie (szczególnie ważne dla zajęć 9-14, gdzie commit = potwierdzenie obecności).

### Podstawowe komendy — ściąga
```bash
git status              # co zmienione / nieśledzone
git add <plik>          # dodaj plik do staging
git add .                # dodaj wszystko ze zmienionych/nowych
git commit -m "opis"    # zatwierdź zmiany
git push                # wyślij commity na zdalne repo
git pull                # pobierz zmiany ze zdalnego repo
git log --oneline       # krótka historia commitów
git diff                # podgląd niezatwierdzonych zmian
```

### Częste błędy
* commit dopiero na koniec semestru jedną paczką — nie będzie uznany,
* brak dostępu prowadzącego do repo (prywatne repo bez dodanego collaboratora),
* commitowanie haseł/danych wrażliwych — `.env` z prawdziwymi danymi do bazy produkcyjnej nie powinien trafić do repo,
* commitowanie całych katalogów narzędziowych (`node_modules/`, `venv/`) — użyj `.gitignore`.
