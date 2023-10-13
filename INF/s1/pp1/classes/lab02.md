## Analiza i uruchamianie demonstracyjnych programów w środowisku IDE.

### Agenda
Przewidywany plan zajęć kształtuje się następująco:
* przedstawienie opcji związanych z IDE oraz poruszanie się po nim,
* konto JetBrains i licencja CLion,
* przedstawienie programów demonstracyjnych,
* uruchomienie i analiza programów demonstracyjnych,
* wprowadzenie do systemu kontroli wersji Git oraz środowiska Github,
* inne opcje językowe.

### IDE
* [**CLion**](https://www.jetbrains.com/clion/)
* Dev-Cpp
* Eclipse
* Code::Blocks
* NetBeans
* Atom

### Konto JetBrains i licencja CLion
IDE CLion to narzędzie firmy [JetBrains](https://www.jetbrains.com/), ogólnie jest to płatne narzędzie lecz jest opcja aby skorzystać z niego bezpłatnie. 
Należy założyć konto za pomocą adresu e-mail studenckiego na platformie JetBrains - uzyskamy dostęp do dużej ilości darmowych IDE w tym CLion, który jest nam potrzebny.

Proszę wejść na ten [link](https://www.jetbrains.com/shop/eform/students) i załóżyć konto na adres e-mail z domeny uczelnianej (@studenci.collegiumwitelona.pl).
Następnie jeśli na komputerze nie ma IDE CLion proszę je pobrać, i tu mamy dwie opcje:
* pobranie narzędzia [JetBrains Toolbox](https://www.jetbrains.com/lp/toolbox/), a następnie po uruchomieniu z listy aplikacji zainstalować CLion,
* pobranie bezpośrednio [CLion](https://www.jetbrains.com/clion/download).

Przy pierwszym uruchomieniu CLion'a spyta on nas o licencję i wtedy nalezy zalogować się na konto JetBrains, które wcześniej zostało utworzone przez Państwa.
Po zakończeniu pracy/ćwiczeń zalecałbym wylogować się ze swojgo konto (z menu wybieramy **Help** > **Register**, następnie w lewym dolnym rogu będzie widoczne nasze imię i nazwisko - po kliknięciu będziemy mogli się wylogować).

### Programy demonstracyjne w C

* program wypisujący "Hello, World!":

```php
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

* program obliczający pole prostokąta:

```php
#include <stdio.h>

int main() {
    float dlugosc, szerokosc, pole;

    printf("Podaj długość prostokąta: ");
    scanf("%f", &dlugosc);

    printf("Podaj szerokość prostokąta: ");
    scanf("%f", &szerokosc);

    pole = dlugosc * szerokosc;

    printf("Pole prostokąta wynosi: %.2f\n", pole);

    return 0;
}
```

* program sprawdzający, czy podana liczba jest dodatnia, ujemna czy równa zeru:
```php
#include <stdio.h>

int main() {
    int liczba;

    printf("Podaj liczbę całkowitą: ");
    scanf("%d", &liczba);

    if (liczba > 0) {
        printf("Liczba jest dodatnia.\n");
    } else if (liczba < 0) {
        printf("Liczba jest ujemna.\n");
    } else {
        printf("Liczba jest równa zeru.\n");
    }

    return 0;
}
```

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
Znając adres repozytorium (np. https://github.com/collegiumwitelona/2023-inf-pp1-twojanazwauzytkownika) należy wykonać następujące polecenia:

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
* katalog o nazwie `lab01` z plikami/folderem programu demonstracyjnego z prezentowanego pliku PDF(załączony na classroom).

### Te same programy ale w języku PHP [dodatek]

* program wypisujący "Hello, World!":

```php
<?php
echo "Hello, World!";
?>
```

* program obliczający pole prostokąta:

```php
<?php
$dlugosc = 5;
$szerokosc = 3;

$pole = $dlugosc * $szerokosc;

echo "Pole prostokąta wynosi: $pole";
?>
```

* program obliczający pole prostokąta z wczytywaniem zmiennych z konsoli:

```php
<?php
if (count($argv) != 3) {
    echo "Użycie: php program.php <długość> <szerokość>\n";
    exit(1);
}

$dlugosc = floatval($argv[1]);
$szerokosc = floatval($argv[2]);

$pole = $dlugosc * $szerokosc;

echo "Pole prostokąta wynosi: $pole\n";
?>
```

lub

```php
<?php
echo "Podaj długość prostokąta: ";
$dlugosc = floatval(trim(fgets(STDIN)));

echo "Podaj szerokość prostokąta: ";
$szerokosc = floatval(trim(fgets(STDIN)));

$pole = $dlugosc * $szerokosc;

echo "Pole prostokąta wynosi: $pole\n";
?>
```

* program sprawdzający, czy podana liczba jest dodatnia, ujemna lub równa zeru po wczytaniu liczby od użytkownika:

```php
<?php
echo "Podaj liczbę: ";
$liczba = floatval(trim(fgets(STDIN)));

if ($liczba > 0) {
    echo "Liczba jest dodatnia.\n";
} elseif ($liczba < 0) {
    echo "Liczba jest ujemna.\n";
} else {
    echo "Liczba jest równa zeru.\n";
}
?>
```