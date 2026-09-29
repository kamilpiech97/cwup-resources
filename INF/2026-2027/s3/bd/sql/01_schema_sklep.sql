-- Schemat wspólnej bazy "sklep internetowy" używanej na laboratoriach 2a-4b.

CREATE TABLE kategorie (
    id      SERIAL PRIMARY KEY,
    nazwa   VARCHAR(100) NOT NULL,
    opis    TEXT
);

CREATE TABLE produkty (
    id              SERIAL PRIMARY KEY,
    nazwa           VARCHAR(150) NOT NULL,
    kategoria_id    INTEGER NOT NULL REFERENCES kategorie(id),
    cena            NUMERIC(10,2) NOT NULL CHECK (cena > 0),
    ilosc_magazyn   INTEGER NOT NULL DEFAULT 0,
    data_dodania    DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE klienci (
    id                  SERIAL PRIMARY KEY,
    imie                VARCHAR(50) NOT NULL,
    nazwisko            VARCHAR(50) NOT NULL,
    email               VARCHAR(150) UNIQUE NOT NULL,
    data_rejestracji    DATE NOT NULL DEFAULT CURRENT_DATE,
    miasto              VARCHAR(100)
);

CREATE TABLE pracownicy (
    id                  SERIAL PRIMARY KEY,
    imie                VARCHAR(50) NOT NULL,
    nazwisko            VARCHAR(50) NOT NULL,
    stanowisko          VARCHAR(100),
    data_zatrudnienia   DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE zamowienia (
    id              SERIAL PRIMARY KEY,
    klient_id       INTEGER NOT NULL REFERENCES klienci(id),
    pracownik_id    INTEGER REFERENCES pracownicy(id),
    data_zamowienia DATE NOT NULL DEFAULT CURRENT_DATE,
    status          VARCHAR(20) NOT NULL DEFAULT 'nowe'
                    CHECK (status IN ('nowe','w realizacji','wyslane','zrealizowane','anulowane'))
);

CREATE TABLE pozycje_zamowien (
    id                  SERIAL PRIMARY KEY,
    zamowienie_id       INTEGER NOT NULL REFERENCES zamowienia(id) ON DELETE CASCADE,
    produkt_id          INTEGER NOT NULL REFERENCES produkty(id),
    ilosc               INTEGER NOT NULL CHECK (ilosc > 0),
    cena_jednostkowa    NUMERIC(10,2) NOT NULL
);
