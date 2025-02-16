# **Migracje w systemach baz danych**

## **1. Cel zajęć**
- Wprowadzenie do migracji jako sposobu na wersjonowanie schematów baz danych.
- Praktyczne zastosowanie migracji w Laravel (PHP) i Doctrine (Symfony, PHP).
- Porównanie podejść: **ręczne definiowanie migracji vs autogenerowanie**.
- Omówienie rollbacków i rewersji zmian.

---

## **2. Wprowadzenie do migracji**
- **Co to są migracje?**
    - Zmiany struktury bazy danych zapisywane jako skrypty wersjonowane.
    - Umożliwiają kontrolowanie zmian i współpracę zespołową.
- **Zalety używania migracji:**
    - Powtarzalność zmian w różnych środowiskach.
    - Możliwość cofania błędnych zmian (rollback).
    - Lepsza kontrola nad historią zmian w bazie danych.

---

## **3. Migracje w Laravel**
### **3.1 Tworzenie migracji**
- Generowanie nowej migracji:
  ```bash
  php artisan make:migration create_users_table
  ```
- Struktura pliku migracji:
  ```php
  public function up()
  {
      Schema::create('users', function (Blueprint $table) {
          $table->id();
          $table->string('name');
          $table->string('email')->unique();
          $table->timestamps();
      });
  }

  public function down()
  {
      Schema::dropIfExists('users');
  }
  ```
- **Uruchamianie migracji**:
  ```bash
  php artisan migrate
  ```
- **Cofanie migracji (rollback)**:
  ```bash
  php artisan migrate:rollback
  ```

### **3.2 Modyfikacja istniejącej tabeli**
- Generowanie migracji do zmiany schematu:
  ```bash
  php artisan make:migration add_phone_to_users_table --table=users
  ```
- Przykład dodania nowej kolumny:
  ```php
  public function up()
  {
      Schema::table('users', function (Blueprint $table) {
          $table->string('phone')->nullable();
      });
  }

  public function down()
  {
      Schema::table('users', function (Blueprint $table) {
          $table->dropColumn('phone');
      });
  }
  ```

---

## **4. Migracje w Doctrine (Symfony)**
### **4.1 Instalacja migracji w Symfony**
- Instalacja Doctrine Migrations:
  ```bash
  composer require doctrine/doctrine-migrations-bundle
  ```
- Konfiguracja w `doctrine.yaml` (jeśli wymagane).

### **4.2 Tworzenie migracji**
- **Definiowanie encji (ORM)**:
  ```php
  #[ORM\Entity]
  class User
  {
      #[ORM\Id]
      #[ORM\GeneratedValue]
      #[ORM\Column(type: "integer")]
      private int $id;

      #[ORM\Column(type: "string", length: 255)]
      private string $name;
  }
  ```
- **Generowanie migracji na podstawie encji**:
  ```bash
  php bin/console doctrine:migrations:diff
  ```
- **Uruchamianie migracji**:
  ```bash
  php bin/console doctrine:migrations:migrate
  ```

### **4.3 Cofanie migracji**
- **Wyświetlenie listy migracji**:
  ```bash
  php bin/console doctrine:migrations:status
  ```
- **Wycofanie ostatniej migracji**:
  ```bash
  php bin/console doctrine:migrations:execute --down MIGRATION_ID
  ```

---

## **5. Porównanie Laravel vs Doctrine**
| Cecha              | Laravel                     | Doctrine (Symfony)          |
|-------------------|---------------------------|----------------------------|
| **Tworzenie migracji** | Ręcznie (`make:migration`) | Automatyczne (`diff`) |
| **Definiowanie schematu** | W kodzie migracji | W encjach (ORM) |
| **Uruchamianie migracji** | `php artisan migrate` | `php bin/console doctrine:migrations:migrate` |
| **Cofanie migracji** | `migrate:rollback` | `migrations:execute --down` |
| **Dodatkowe funkcje** | Seeder’y, Factory | Tworzenie na podstawie ORM |

---

## **6. Zadania dla studentów**
1. **Ćwiczenie 1**: Utworzenie migracji w Laravelu dla tabeli `products` i dodanie pola `price` do istniejącej tabeli.
2. **Ćwiczenie 2**: W Symfony/Doctrine utworzenie encji `Order` oraz wygenerowanie migracji.
3. **Ćwiczenie 3**: Cofnięcie ostatniej migracji i ponowne jej uruchomienie w obu technologiach.

---

## **7. Podsumowanie**
- Migracje są kluczowe w zarządzaniu zmianami w bazach danych.
- Laravel oferuje ręczne definiowanie migracji, podczas gdy Doctrine generuje je na podstawie ORM.
- Możliwość rollbacków zwiększa bezpieczeństwo zmian.
- Migracje ułatwiają współpracę w zespołach i automatyzację wdrożeń.

---
