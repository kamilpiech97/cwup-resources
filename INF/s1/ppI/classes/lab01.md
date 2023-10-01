## Wprowadzenie do pracowni podstaw programowania

### Agenda
Przewidywany plan zajęć kształtuje się następująco:
* przedstawienie zasad zaliczenia przedmiotu,
* przedstawienie planu tematów i zajęć na cały semestr,
* przedstawienie sugerowanej literatury przedmiotu,
* przedstawienie programów demonstracyjnych.

### Zasady zaliczenia przedmiotu
Zajęcia i obecność:
* w trakcie semestru zostanie zrealizowanych 15 zajęć laboratoryjnych,
* obecność na nich jest obowiązkowa,
* prowadzący akceptuje dwie nieusprawiedliwione nieobecności.

### Listy zadań:
* laboratoria 1-7 poruszają cztery tematy, które kończą się kolokwium w połowie semestru,
* laboratoria 9-14 poruszają kolejne cztery tematy, które kończą się kolokwium na koniec semestru,
* każde laboratorium będzie posiadało listę zadań która musi zostać wykonana indywidualnie oraz przesłana na wskazane repozytorium,
* sumienne wykonanie każdej listy zadań będzie skutkowało podwyższeniem oceny końcowej lecz brak nadesłania listy będzie skutkiem odwrotnym czyli będzie obniżał ocenę końcową.

### Ocena końcowa:
* ocena końcowa wyliczana jest na podstawie wzoru:

```math
finalGrade = \frac{k_{1} + k_{2}}{2} + p \times 0.05 - n \times 0.1
```
* gdzie $k_1$ to ocena z kolokwium nr 1, $k_2$ to ocena z kolokwium nr 2, $p$ to ilość wykonanych list zadań a $n$ to ilość nienadesłanych list zadań
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

