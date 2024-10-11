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
mkdir pp1
cd pp1
mkdir 123456
cd 123456
```

Kolejne polecenia oznaczają:
```
przejdź do głównego katalogu
utwórz katalog o nazwie pp1
przejdź do katalogu o nazwie pp1
utwórz katalog o nazwie 123456 (tutaj dobrze wpisać swój numer indeksu)
przejdź do katalogu o nazwie 123456 (ponownie: indeks)
```

#### Inicjalizacja repozytorium:
Znając adres repozytorium (np. https://github.com/collegiumwitelona/2024-inf-pp1-3(1)-twojanazwauzytkownika) należy wykonać następujące polecenia:

```bash
git init
git remote add origin https://github.com/collegiumwitelona/2023-inf-pp1-twojanazwauzytkownika
git pull origin master
git status
```

Kolejne polecenia oznaczają:
```
oznacz folder jako repozytorium git
ustaw połączenie z serwerem
ściąga dane z serwera (jeśli repozytorium jest puste, możecie dostać błąd, wtedy proszę przejść do kroku instrukcji poniżej - 'Wprowadzanie zmian do repozytorium')
pokazuje stan repozytorium
```

Przy komendzie ```git pull origin master``` lub ```git push origin master``` GitHub poprosi nas o dane uwierzytelniające do naszego repozytorium czyli login i hasło do konta GitHub. 
**I tutaj ważna sprawa!** GitHub od 2021 roku nie pozwala potwierdzać logowania zwykłym hasłem do Waszego konta GitHub lecz tylko za pomocą tokenu lub klucza SSH.
Klasyczny token możecie wygenerować pod tym [linkiem](https://github.com/settings/tokens/new), można ustawić w nim czas żywotności i listę uprawnień 
(zaznaczyć proszę wszystko) a następnie po jego wygenerowaniu proszę sobie go zapisać.


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
* katalog o nazwie `lab01` z plikami/folderami programów demonstracyjnych i tych do wykonania z prezentowanego pliku PDF(załączony na classroom).
