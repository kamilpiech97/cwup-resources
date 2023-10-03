## Wprowadzenie do pracowni podstaw programowania

### Agenda
Przewidywany plan zajęć kształtuje się następująco:
* przedstawienie zasad zaliczenia przedmiotu,
* przedstawienie planu tematów i zajęć na cały semestr,
* przedstawienie sugerowanej literatury przedmiotu,
* wprowadzenie do systemu kontroli wersji Git oraz środowiska Github.

### Zasady zaliczenia przedmiotu
Zajęcia i obecność:
* w trakcie semestru zostanie zrealizowanych 15 zajęć laboratoryjnych,
* obecność na nich jest obowiązkowa,
* prowadzący akceptuje dwie nieusprawiedliwione nieobecności.

### Listy zadań:
* laboratoria 1-7 poruszają cztery tematy, które kończą się kolokwium w połowie semestru,
* laboratoria 9-14 poruszają kolejne cztery tematy, które kończą się kolokwium na koniec semestru,
* każde laboratorium będzie posiadało listę zadań która musi zostać wykonana indywidualnie oraz przesłana na wskazane repozytorium,
* sumienne wykonanie każdej listy zadań będzie skutkowało podwyższeniem oceny końcowej.

### Ocena końcowa:
* ocena końcowa wyliczana jest na podstawie wzoru:

```math
x = \frac{k_{1} + k_{2}}{2} + p \times 0.05
```
* gdzie $x$ to ocena końcowa, $k_1$ to ocena z kolokwium nr 1, $k_2$ to ocena z kolokwium nr 2 a $p$ to ilość wykonanych list zadań
* aby zaliczyć kurs, obie oceny z kolokwium muszą być pozytywne.

### Przegląd tematów w semestrze
1. Przedstawienie warunków zaliczenia przedmiotu. Rozpoznanie środowiska
   programistycznego (IDE).Programy demonstracyjne.
1. Analiza i uruchamianie demonstracyjnych programów w środowisku IDE.
1. Rozwiązywanie praktycznych zadań z wykorzystaniem predefiniowanych typów danych,
   operatorów arytmetycznych, logicznych, relacji; instrukcji warunkowych oraz prostych
   operacji we/wy. (3 lab)
1. Rozwiązywanie praktycznych zadań z wykorzystaniem instrukcji iteracyjnych oraz tablic
   jednowymiarowych. (2 lab)
1. Sprawdzian praktyczny (kolokwium nr 1)
1. Rozwiązywanie praktycznych zadań z wykorzystaniem funkcji, tablic jedno- i
   wielowymiarowych oraz różnych sposobów przekazywania parametrów
1. Rozwiązywanie praktycznych zadań z wykorzystaniem funkcji, wskaźników i funkcji
   bibliotecznych do przetwarzania znaków i napisów (2 lab)
1. Rozwiązywanie praktycznych zadań z wykorzystaniem funkcji, typów strukturowych oraz
   struktur dynamicznych (2 lab)
1. Rozwiązywanie praktycznych zadań z wykorzystaniem operacji na plikach tekstowych i
   binarnych
1. Sprawdzian praktyczny (kolokwium nr 2)

### Literatura podstawowa
* King K. N., *Język C. Nowoczesne programowanie.* Wydanie II, Wydawnictwo HELION, Gliwice 2011.
* Prata S., *Język C. Szkoła programowania.* Wydanie VI, Wydawnictwo HELION, Gliwice 2016

### Literatura uzupełniająca
* S. G. Kochan , *Język C. Kompendium wiedzy.* Wydanie IV, Helion, Gliwice 2015.

### System kontroli wersji
Należy utworzyć konto użytkownika na platformie [Github](http://github.com/) pod adresem studenckim. Jeżeli student już posiada konto, w ustawieniach profilu można dodać drugi adres. Prowadzący doda studentów do [organizacji uczelnianej](https://github.com/collegiumwitelona), przez którą będzie się odbywała realizacja zajęć i oddawanie list.

Należy sprawdzić czy Git jest zainstalowany w systemie: najlepiej uruchomić wybraną konsolę i wpisać:
```bash
git --version
```

Jeżeli nie jest zainstalowany, należy go zainstalować. Instrukcja dla użytkowników Windowsa - [dostępna tutaj](https://github.com/git-guides/install-git).

#### Inicjalizacja katalogu repozytorium:
Należy utworzyć katalog repozytorium:
```bash
cd /
mkdir ppo
cd ppo
mkdir 123456
cd 123456
```

Kolejne polecenia oznaczają:
```
przejdź do głównego katalogu
utwórz katalog o nazwie ppo
przejdź do katalogu o nazwie ppo
utwórz katalog o nazwie 123456 (tutaj dobrze wpisać swój numer indeksu)
przejdź do katalogu o nazwie 123456 (ponownie: indeks)
```

#### Inicjalizacja repozytorium:
Znając adres repozytorium (np. https://github.com/collegiumwitelona/2023-pp1-twojanazwauzytkownika) należy wykonać następujące polecenia:

```bash
git init
git remote add origin https://github.com/collegiumwitelona/2023-ppo1-twojanazwauzytkownika
git pull origin master
git status
```

Kolejne polecenia oznaczają:
```
oznacz folder jako repozytorium git
ustaw połączenie z serwerem
ściąga dane z serwera
pokazuje stan repozytorium
```

#### Wprowadzanie zmian do repozytorium
Prawdopodobnie przy pierwszych zmianach będzie trzeba dodać poświadczenia uwierzytelniające:
```
git config user.name "Imię Nazwisko"
git config user.email "imie.nazwisko@student.collegiumwitelona.pl"
```

Warto podać swoje prawdziwe dane, aby Github później przyjął żądanie. Po jakiejkolwiek zmianie, dodaniu lub usunięciu pliku, należy zapisać swoje zmiany:
```bash
git add .
git status
git commit -am "zmiany"
git push origin master
```

Kolejne polecenia oznaczają:
```
dodaje wszystkich niedodanych plików z katalogu "." do repozytorium
pokazuje stan repozytorium
tworzy commit o nazwie "zmiany"
przesyła commity na serwer
```

Z poziomu narzędzi takich jak produkty JetBrains, SourceTree, GitHub Desktop czy GitKraken te same polecenia można wykonać przez graficzny interfejs użytkownika.

### Zadanie do wykonania
W repozytorium proszę dodać:
* plik `readme.md` z podanym numerem indeksu, adresem mejlowym oraz imieniem i nazwiskiem studenta;
* katalog o nazwie `lab01` z plikami programu demonstracyjnego z prezentowanego pliku PDF.