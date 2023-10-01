## Analiza i uruchamianie demonstracyjnych programów w środowisku IDE.

### Agenda
Przewidywany plan zajęć kształtuje się następująco:
* przedstawienie opcji związanych z IDE oraz poruszanie się po nim,
* przedstawienie programów demonstracyjnych,
* uruchomienie i analiza programów demonstracyjnych,
* inne opcje językowe.

### IDE
* CLion
* Eclipse
* Code::Blocks
* NetBeans
* Atom

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

### Te same programy ale w języku PHP

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