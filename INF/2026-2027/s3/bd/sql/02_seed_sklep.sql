-- Generuje realistyczną ilość danych w bazie "sklep" (wymaga wcześniejszego 01_schema_sklep.sql).
-- ~200 klientów, ~150 produktów, ~1000 zamówień, ~3000 pozycji zamówień.
-- Nazwy (produkty/klienci/kategorie) są realistyczne, nie placeholderowe - część zadań w lab03
-- (LIKE/pierwsza litera/końcówka nazwiska) opiera się na tym, że dane wyglądają jak prawdziwe.

INSERT INTO kategorie (nazwa, opis)
SELECT nazwa, 'Kategoria: ' || nazwa
FROM unnest(ARRAY[
    'Elektronika','AGD','Sport i turystyka','Dom i ogrod','Moda',
    'Zabawki','Ksiazki','Uroda','Motoryzacja','Zdrowie',
    'Biuro i szkola','Zwierzeta','Muzyka i film','Gry i konsole','Ogrodnictwo'
]) AS nazwa;

INSERT INTO produkty (nazwa, kategoria_id, cena, ilosc_magazyn, data_dodania)
SELECT
    (ARRAY[
        'Laptop','Telefon','Sluchawki','Monitor','Klawiatura','Mysz komputerowa','Drukarka','Tablet',
        'Kamera sportowa','Glosnik Bluetooth','Router WiFi','Dysk SSD','Powerbank','Ladowarka USB-C',
        'Kabel HDMI','Lampka LED','Krzeslo biurowe','Biurko narozne','Plecak sportowy','Termos stalowy',
        'Namiot turystyczny','Rower miejski','Deska do prasowania','Konsola do gier','Pralka',
        'Lodowka','Czajnik elektryczny','Odkurzacz bezprzewodowy','Suszarka do wlosow','Zelazko parowe'
    ])[floor(random() * 30 + 1)] || ' ' || i,
    (random() * 14 + 1)::int,
    round((random() * 490 + 10)::numeric, 2),
    (random() * 200)::int,
    CURRENT_DATE - (random() * 700)::int
FROM generate_series(1, 150) AS i;

INSERT INTO klienci (imie, nazwisko, email, data_rejestracji, miasto)
SELECT
    (ARRAY[
        'Jan','Anna','Piotr','Maria','Krzysztof','Ewa','Tomasz','Magdalena','Michal','Katarzyna',
        'Pawel','Agnieszka','Marek','Joanna','Andrzej','Barbara','Lukasz','Monika','Grzegorz','Aleksandra'
    ])[floor(random() * 20 + 1)],
    (ARRAY[
        'Kowalski','Wisniewski','Lewandowski','Zielinski','Szymanski','Kaminski','Jankowski','Piotrowski',
        'Grabowski','Kozlowski','Nowak','Wojcik','Kowalczyk','Wozniak','Mazur','Krawczyk','Kaczmarek',
        'Zajac','Wieczorek','Kubiak'
    ])[floor(random() * 20 + 1)],
    'klient' || i || '@example.com',
    CURRENT_DATE - (random() * 1000)::int,
    (ARRAY['Warszawa','Krakow','Wroclaw','Poznan','Gdansk','Lodz','Legnica'])[floor(random() * 7 + 1)]
FROM generate_series(1, 200) AS i;

INSERT INTO pracownicy (imie, nazwisko, stanowisko, data_zatrudnienia)
SELECT
    (ARRAY[
        'Jan','Anna','Piotr','Maria','Krzysztof','Ewa','Tomasz','Magdalena','Michal','Katarzyna',
        'Pawel','Agnieszka','Marek','Joanna','Andrzej','Barbara','Lukasz','Monika','Grzegorz','Aleksandra'
    ])[floor(random() * 20 + 1)],
    (ARRAY[
        'Kowalski','Wisniewski','Lewandowski','Zielinski','Szymanski','Kaminski','Jankowski','Piotrowski',
        'Grabowski','Kozlowski','Nowak','Wojcik','Kowalczyk','Wozniak','Mazur','Krawczyk','Kaczmarek',
        'Zajac','Wieczorek','Kubiak'
    ])[floor(random() * 20 + 1)],
    (ARRAY['sprzedawca','magazynier','kierownik','obsluga klienta'])[floor(random() * 4 + 1)],
    CURRENT_DATE - (random() * 1500)::int
FROM generate_series(1, 20) AS i;

INSERT INTO zamowienia (klient_id, pracownik_id, data_zamowienia, status)
SELECT
    (random() * 199 + 1)::int,
    (random() * 19 + 1)::int,
    CURRENT_DATE - (random() * 365)::int,
    (ARRAY['nowe','w realizacji','wyslane','zrealizowane','anulowane'])[floor(random() * 5 + 1)]
FROM generate_series(1, 1000) AS i;

INSERT INTO pozycje_zamowien (zamowienie_id, produkt_id, ilosc, cena_jednostkowa)
SELECT
    (random() * 999 + 1)::int,
    (random() * 149 + 1)::int,
    (random() * 4 + 1)::int,
    round((random() * 490 + 10)::numeric, 2)
FROM generate_series(1, 3000) AS s;
