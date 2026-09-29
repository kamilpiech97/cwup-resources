-- Resetuje roboczą kopię bazy "sklep" do czystego stanu.
-- Odpalać na początku zajęć, gdy poprzednie ćwiczenia (DDL/DML/transakcje) namieszały w danych.

DROP TABLE IF EXISTS pozycje_zamowien CASCADE;
DROP TABLE IF EXISTS zamowienia CASCADE;
DROP TABLE IF EXISTS pracownicy CASCADE;
DROP TABLE IF EXISTS produkty CASCADE;
DROP TABLE IF EXISTS klienci CASCADE;
DROP TABLE IF EXISTS kategorie CASCADE;
DROP TABLE IF EXISTS sprzedaz_flat CASCADE;

-- Po DROP odpalić po kolei:
--   01_schema_sklep.sql
--   02_seed_sklep.sql
--   03_denormalized_sprzedaz.sql (tylko jeśli lab tego wymaga)
