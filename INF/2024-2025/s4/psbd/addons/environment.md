# **Środowisko uruchomieniowe dla PostgreSQL i MySQL w Dockerze**

## **1. Cel zajęć**
- Wprowadzenie do Dockera jako narzędzia do uruchamiania i zarządzania bazami danych.
- Konfiguracja PostgreSQL i MySQL w kontenerach Docker.
- Wykorzystanie `docker-compose` do definiowania środowisk wielokontenerowych.
- Podłączanie baz danych w różnych narzędziach i testowanie podstawowych operacji.

---

## **2. Wprowadzenie do Dockera**
- **Czym jest Docker?** – platforma do uruchamiania aplikacji w kontenerach.
- **Zalety użycia Dockera w bazach danych**:
    - Szybka konfiguracja i izolacja środowiska.
    - Możliwość łatwego resetowania i backupowania baz danych.
    - Identyczne środowisko na różnych komputerach.
- **Instalacja Dockera** – [pobranie](https://docs.docker.com/engine/install/) i konfiguracja na Windows, macOS, Linux.
- **Pamiętaj o post-installation steps!** - kroki dla [Ubuntu](https://docs.docker.com/engine/install/linux-postinstall/).

---
## **3. Uruchamianie PostgreSQL i MySQL w Dockerze**
### **3.1 Uruchamianie PostgreSQL**
- Pobranie i uruchomienie kontenera PostgreSQL:
  ```bash
  docker run --name postgres-container -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin -p 5432:5432 -d postgres
  ```
- Sprawdzenie działania:
  ```bash
  docker ps
  docker logs postgres-container
  ```
- Połączenie do PostgreSQL przez CLI:
  ```bash
  docker exec -it postgres-container psql -U admin
  ```

### **3.2 Uruchamianie MySQL**
- Pobranie i uruchomienie kontenera MySQL:
  ```bash
  docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=testdb -p 3306:3306 -d mysql
  ```
- Sprawdzenie działania:
  ```bash
  docker ps
  docker logs mysql-container
  ```
- Połączenie do MySQL przez CLI:
  ```bash
  docker exec -it mysql-container mysql -u root -p
  ```

---
## **4. Konfiguracja za pomocą `docker-compose`**
### **4.1 Tworzenie pliku `docker-compose.yml` dla PostgreSQL i MySQL**
- Uproszczenie zarządzania usługami bazy danych:
  ```yaml
  version: '3.8'

  services:
    postgres:
      image: postgres
      container_name: postgres-container
      restart: always
      environment:
        POSTGRES_USER: admin
        POSTGRES_PASSWORD: admin
        POSTGRES_DB: mydb
      ports:
        - "5432:5432"
      volumes:
        - pg_data:/var/lib/postgresql/data

    mysql:
      image: mysql
      container_name: mysql-container
      restart: always
      environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: mydb
      ports:
        - "3306:3306"
      volumes:
        - mysql_data:/var/lib/mysql

  volumes:
    pg_data:
    mysql_data:
  ```

### **4.2 Uruchamianie i zatrzymywanie kontenerów**
- Start kontenerów:
  ```bash
  docker-compose up -d
  ```
- Sprawdzenie działania:
  ```bash
  docker-compose ps
  ```
- Zatrzymanie kontenerów:
  ```bash
  docker-compose down
  ```

---

## **5. Podłączanie klientów do baz danych**
### **5.1 Połączenie przez interfejs graficzny**
1. PhpStorm / DataGrip – wbudowany moduł obsługi baz.
2. Utworzenie nowego połączenia do PostgreSQL:
    - Host: `localhost`
    - Port: `5432`
    - Użytkownik: `admin`
    - Hasło: `admin`
3. Utworzenie nowego połączenia do MySQL:
    - Host: `localhost`
    - Port: `3306`
    - Użytkownik: `root`
    - Hasło: `root`

### **5.2 Podłączenie przez terminal**
- PostgreSQL:
  ```bash
  psql -h localhost -U admin -d mydb
  ```
- MySQL:
  ```bash
  mysql -h localhost -u root -p
  ```


---

## **6. Zarządzanie danymi w kontenerach**
### **6.1 Tworzenie tabel i wstawianie przykładowych danych**
- PostgreSQL:
  ```sql
  CREATE TABLE users (
      id SERIAL PRIMARY KEY,
      name VARCHAR(100)
  );
  INSERT INTO users (name) VALUES ('Jan Kowalski');
  SELECT * FROM users;
  ```
- MySQL:
  ```sql
  CREATE TABLE users (
      id INT AUTO_INCREMENT PRIMARY KEY,
      name VARCHAR(100)
  );
  INSERT INTO users (name) VALUES ('Anna Nowak');
  SELECT * FROM users;
  ```

### **6.2 Kopiowanie danych z/do kontenera**
- Eksport bazy PostgreSQL:
  ```bash
  docker exec -t postgres-container pg_dump -U admin mydb > backup.sql
  ```
- Import bazy PostgreSQL:
  ```bash
  docker exec -i postgres-container psql -U admin -d mydb < backup.sql
  ```
- Eksport bazy MySQL:
  ```bash
  docker exec -t mysql-container mysqldump -u root -p mydb > backup.sql
  ```
- Import bazy MySQL:
  ```bash
  docker exec -i mysql-container mysql -u root -p mydb < backup.sql
  ```

---

## **7. Usuwanie i czyszczenie kontenerów**
- **Zatrzymanie i usunięcie kontenerów:**
  ```bash
  docker-compose down -v
  ```
- **Usunięcie pojedynczego kontenera:**
  ```bash
  docker rm -f postgres-container mysql-container
  ```
- **Usunięcie obrazów Dockera:**
  ```bash
  docker rmi postgres mysql
  ```

---

## **8. Podsumowanie**
- Docker to wygodne narzędzie do pracy z bazami danych w izolowanych środowiskach.
- `docker-compose` upraszcza zarządzanie wieloma usługami.
- PostgreSQL i MySQL można uruchamiać w kontenerach i testować w różnych klientach.
- Praca z danymi w kontenerach jest szybka i efektywna.

---

### **9. Zadanie dla chętnych**
1. Uruchom kontenery PostgreSQL i MySQL w Dockerze za pomocą `docker-compose`.
2. Połącz się z bazami danych przez CLI lub klientów graficznych -  **PhpStorm**, **DataGrip**.
3. Stwórz nowe bazy danych, tabele i wstaw przykładowe dane - jedna tabeka wystarczy.
4. Wykonaj eksport i import danych z/do kontenerów - opcjonalnie.
5. Zatrzymaj i usuń kontenery oraz obrazy Dockera.
