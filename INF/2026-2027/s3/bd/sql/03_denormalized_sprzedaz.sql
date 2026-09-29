-- Celowo zdenormalizowana, płaska tabela do ćwiczenia normalizacji na laboratorium 3a (lab05).
-- Dane powtarzają się (ten sam klient/produkt wielokrotnie) - pokazuje anomalie insercji/aktualizacji/usuwania.

CREATE TABLE sprzedaz_flat (
    id                  SERIAL PRIMARY KEY,
    klient_imie         VARCHAR(50),
    klient_nazwisko     VARCHAR(50),
    klient_email        VARCHAR(150),
    klient_miasto       VARCHAR(100),
    produkt_nazwa       VARCHAR(150),
    produkt_kategoria   VARCHAR(100),
    produkt_cena        NUMERIC(10,2),
    data_sprzedazy      DATE,
    ilosc               INTEGER
);

INSERT INTO sprzedaz_flat
    (klient_imie, klient_nazwisko, klient_email, klient_miasto,
     produkt_nazwa, produkt_kategoria, produkt_cena, data_sprzedazy, ilosc)
SELECT
    'Kl_Imie' || (i % 50 + 1),
    'Kl_Nazwisko' || (i % 50 + 1),
    'klientflat' || (i % 50 + 1) || '@example.com',
    (ARRAY['Warszawa','Krakow','Wroclaw','Poznan','Gdansk'])[(i % 5) + 1],
    'Produkt_Flat' || (i % 30 + 1),
    (ARRAY['Elektronika','AGD','Odziez','Ksiazki','Zabawki','Sport'])[(i % 6) + 1],
    round((10 + (i % 30) * 15.5)::numeric, 2),
    CURRENT_DATE - (i % 365),
    (i % 5) + 1
FROM generate_series(1, 500) AS i;

-- Zadanie: rozbić powyższą tabelę do 3NF (osobne tabele klienci/produkty/sprzedaż)
-- i przenieść dane poleceniami CREATE TABLE + INSERT...SELECT. Patrz lab05.md.
