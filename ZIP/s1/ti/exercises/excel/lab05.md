### Zadanie na ocenę:
 
W [folderze](https://drive.google.com/drive/folders/14SMoExtYHCAyPIriSClO--kAnpi85Vk4?usp=sharing) na dysku Google znajdziemy 4 pliki, które są arkuszami Excel:
* **BTCUSD** arkusz który posiada kurs Bitcoina do dolara z wybranych 3 miesięcy,
* **EURPLN** arkusz który posiada kurs polskiego złotego w odniesieniu do euro z tego samego zakresu,
* **USDPLN** arkusz który posiada kurs polskiego złotego w odniesieniu do dolara z tego samego zakresu,
* **CHFKPLN** arkusz który posiada kurs polskiego złotego w odniesieniu do franka szwajcarskiego z tego samego zakresu.

Wszystkie pliki z kursami walut posiadają takie informacje jak średnia cena. Plik z kursem BTCUSD posiada trochę więcej infromacji takich jak cena otwarcia, najwyższa i najniższa wartość.

Zadania do wykonania:
1. Proszę utworzyć arkusz o nazwie [numer indeksu]-bitcoin. Nazwać obecną zakładkę arkusza jako **BTCUSD**(dolny lewy róg).
2. Do świeżo utworzonego arkusza proszę skopiować dane z arkusza **BTCUSD** takie jak: Date(data), Price(USD), High(najwyższa wartość), Low(najniższa wartość). Opisy z okrągłych nawiasów to nazwy kolumn, które powinny znaleźć się w Waszym arkuszu.
3. Utwórz nową zakładę/kartę w swoim arkuszu (dolny lewy róg - przycisk z ikoną **+**).
4. Do świeżo utworzonej zakładki proszę skopiować dane z arkusza **EURPLN** takie jak: Data(data), Kurs średni(cena). Opisy z okrągłych nawiasów to nazwy kolumn, które powinny znaleźć się w Waszym arkuszu. Nazwać zakładkę arkusza jako **EURPLN**(dolny lewy róg).
5. Te same kroki proszę wykonać dla **USDPLN** i **CHFKPLN**.
6. Dla każdej z zakładek proszę wykonać następujące zadania:
   1. dodać odpowiednie formatowanie danych zawartych w arkuszu
   1. dodać nową kolumnę o nazwie **zmiana**, ma ona liczyć procentową zmianę ceny kursu w odniesieniu do dnia poprzedniego,
   2. dodać wykres liniowy, który będzie pokazywał wizualnie zmieniający się kurs waluty oraz odpowiednio opisać osie,
   3. dodać w komórce **O1** formułę, która pokaże najwyższą wartość kursu,
   4. dodać w komórce **O2** formułę, która pokaże najniższą wartość kursu,
   4. dodać w komórce **O3** formułę, która policzy średnią cenę kursu,
   5. dodać w komórce **O4** formułę, która pokaże największa wartość zmiany % pomiędzy kursami,
   5. dodać w komórce **O5** formułę, policzy różnicę pomiędzy najwyższym a najniższym kursem.
6. Dodatkowo dla zakładki **BTCUSD** proszę wykonać następujące zadania:
   1. dodać 3 kolumny (**PLN**, **CHF** i **EUR**), w których zostanie dodana formuła, która przeliczy nam wartość **Bitcoina** z **USD** na waluty z reszty zakładek (**PLN**, **CHF** i **EUR**) - odpowiednio sformatuj waluty.
   2. dodać w komórce **P1** formułę, która pokaże najwyższą wartość kursu Bitcoin w **USD**,
   3. dodać w komórce **P2** formułę, która pokaże najwyższą wartość kursu Bitcoin w **PLN**,
   4. dodać w komórce **P3** formułę, która pokaże najwyższą wartość kursu Bitcoin w **CHF**,
   5. dodać w komórce **P4** formułę, która pokaże najwyższą wartość kursu Bitcoin w **EUR**,
   2. dodać w komórce **Q1** formułę, która pokaże najniższą wartość kursu Bitcoin w **USD**,
   3. dodać w komórce **Q2** formułę, która pokaże najniższą wartość kursu Bitcoin w **PLN**,
   4. dodać w komórce **Q3** formułę, która pokaże najniższą wartość kursu Bitcoin w **CHF**,
   5. dodać w komórce **Q4** formułę, która pokaże najniższą wartość kursu Bitcoin w **EUR**,
   2. dodać w komórce **R1** formułę, która policzy średnią cenę kursu Bitcoin w **USD**,
   3. dodać w komórce **R2** formułę, która policzy średnią cenę kursu Bitcoin w **PLN**,
   4. dodać w komórce **R3** formułę, która policzy średnią cenę kursu Bitcoin w **CHF**,
   5. dodać w komórce **R4** formułę, która policzy średnią cenę kursu Bitcoin w **EUR**,
   6. odpowiednio sformatować dane w komórkach - nadanie formatu (liczbowy, walutowy),
   7. dodać wykres liniowy który będzie pokazywał zmianę ceny Bitcoina na przestrzeni 3 miesięcy dla każdej waluty(**PLN**, **CHF**, **USD** i **EUR**).

