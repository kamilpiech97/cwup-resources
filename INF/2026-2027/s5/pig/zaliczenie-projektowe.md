## Projektowanie interfejsów graficznych
### Zasady zaliczenia zajęć projektowych

#### Warunki zaliczenia

Zaliczenie zajęć projektowych kursu **Projektowanie interfejsów graficznych** odbywa się poprzez zaprojektowanie interfejsu użytkownika systemu realizowanego w ramach kursu **Projektowanie i programowanie systemów internetowych II** (dalej: PPSI2), opracowanie biblioteki komponentów, sprawozdania oraz prezentację pracy projektowej. Ocena końcowa $\Omega$ będzie wyliczana w następujący sposób:

$$ \Omega = 0.4k_1 + 0.3k_2 + 0.3k_3 $$

gdzie kolejne $k_n$ powinny być rozumiane następująco:

- $k_1$ - ocena za projekt interfejsu w Figmie (design system, makiety);
- $k_2$ - ocena za bibliotekę komponentów;
- $k_3$ - ocena za sprawozdanie i prezentację pracy projektowej.

Oddanie pracy projektowej wymaga obecności całego zespołu, a warunkiem koniecznym jest $k_n > 2.0$. Ocena jest wystawiana zespołowo.

#### Powiązanie z PPSI2

Oba kursy realizowane są na jednym wspólnym projekcie, ale oceniają jego różne strony:
- PPSI2 ocenia **działanie systemu** - backend, API, wdrożenie, testy, kompletność funkcjonalną;
- Projektowanie interfejsów graficznych ocenia **projekt systemu z perspektywy użytkownika** - proces projektowy, makiety, spójny design system i jego implementację w postaci biblioteki komponentów.

W związku z tym:
- projekt jest wykonywany w tych samych zespołach i na tym samym temacie, co w ramach PPSI2;
- link do repozytorium projektu powinien zostać zgłoszony prowadzącemu zajęcia najpóźniej do drugich zajęć projektowych, a w pliku `README.md` repozytorium musi znajdować się link do pliku Figma (z dostępem do podglądu i komentowania dla prowadzącego); w przeciwnym razie każdy członek grupy otrzyma modyfikator $-0.5$ do oceny końcowej za projekt;
- biblioteka komponentów musi być zaimplementowana w technologii frontendu wybranej w PPSI2;
- komponenty z biblioteki **muszą być faktycznie wykorzystane** w aplikacji oddawanej w ramach PPSI2 - biblioteka istniejąca wyłącznie jako osobna prezentacja komponentów nie spełnia wymagań.

#### Organizacja pracy

Projekt jest realizowany zdalnie. Prace muszą być widoczne w historii pliku Figma i repozytorium w sposób rozłożony w czasie - przyrost pracy wykonany jednorazowo tuż przed terminem oddania skutkuje obniżeniem oceny.

#### Wymagania ogólne dotyczące interfejsu

Poniższe wymagania dotyczą całego projektu - zarówno makiet w Figmie, jak i biblioteki komponentów oraz wdrożonej aplikacji.

**Użyteczność (UX)**
- interfejs jest spójny - te same akcje wyglądają i działają tak samo na wszystkich ekranach, a elementy o tej samej funkcji korzystają z tych samych komponentów;
- użytkownik zawsze wie, gdzie jest i co się dzieje - aktywny element nawigacji jest wyróżniony, każda akcja daje informację zwrotną (ładowanie, powodzenie, błąd);
- interfejs zapobiega błędom - akcje nieodwracalne (np. usunięcie) wymagają potwierdzenia, a przyciski niedostępnych akcji są wyłączone lub ukryte;
- formularze mają etykiety widoczne nad polami (nie tylko placeholder), komunikaty walidacji wyświetlane przy polu, którego dotyczą, i opisujące, jak naprawić błąd;
- treść komunikatów jest zrozumiała dla użytkownika - bez kodów błędów i żargonu technicznego;
- najważniejsza akcja na ekranie jest wyraźnie wyróżniona wizualnie względem akcji drugorzędnych;
- hierarchia wizualna (rozmiar, grubość i kolor tekstu, odstępy) odzwierciedla ważność informacji.

**Responsywność (RWD)**
- interfejs jest projektowany w podejściu mobile-first i obsługuje min. trzy szerokości ekranu: mobile (od 360 px), tablet (od 768 px) i desktop (od 1280 px);
- na żadnej z obsługiwanych szerokości nie występuje poziome przewijanie strony;
- nawigacja dostosowuje się do szerokości ekranu (np. menu boczne na desktopie, menu rozwijane lub dolny pasek na mobile);
- tabele i widoki z dużą ilością danych mają osobne rozwiązanie dla mobile (np. karty zamiast wierszy, przewijanie tylko w obrębie tabeli);
- breakpointy w kodzie odpowiadają breakpointom zdefiniowanym w Figmie.

**Kontrast**
- kontrast tekstu względem tła wynosi min. 4.5:1, a dla dużego tekstu (od 24 px lub od 18.66 px pogrubionego) min. 3:1;
- kontrast elementów interfejsu (obramowania pól, ikony pełniące funkcję) względem otoczenia wynosi min. 3:1;
- kolor nie jest jedynym nośnikiem informacji - np. status zgłoszenia oprócz koloru ma etykietę tekstową lub ikonę, a błąd w formularzu oprócz czerwonej ramki ma komunikat;
- kontrast jest zweryfikowany dla każdej pary kolorów tekst/tło użytej w design systemie (np. wtyczką w Figmie lub narzędziami przeglądarki);
- jeżeli projekt posiada tryb ciemny, wszystkie powyższe wymagania dotyczą również jego.

#### Projekt interfejsu w Figmie

Należy zaprojektować spójny design system oraz makiety systemu. Wymagania:
- zdefiniowana paleta kolorów (w tym kolory semantyczne, np. błąd, sukces, ostrzeżenie) i typografia, stosowane konsekwentnie na wszystkich ekranach;
- elementy interfejsu powtarzające się na ekranach zdefiniowane jako komponenty Figmy;
- min. 4 kluczowe ekrany w wersji hi-fi, każdy w wersji mobile i desktop;
- uwzględnione stany ekranów: pusty widok, ładowanie, błąd, komunikat o powodzeniu operacji;
- spełnienie [wymagań ogólnych](#wymagania-ogólne-dotyczące-interfejsu).

Dodatkowo premiowane w ocenie $k_1$:
- tokeny projektowe zdefiniowane jako Figma Variables: kolory, typografia, odstępy, zaokrąglenia, cienie;
- komponenty zbudowane z wykorzystaniem auto layoutu, wariantów i właściwości komponentów, korzystające wyłącznie z tokenów (bez wartości wpisanych na sztywno).

#### Biblioteka komponentów

Należy zaimplementować komponenty zaprojektowane w Figmie jako bibliotekę komponentów. Biblioteka może zostać udokumentowana w Storybooku (opcjonalnie) lub przedstawiona jako prosty zbiór komponentów wyświetlonych na jednej stronie (np. osobny widok w aplikacji). Wymagania:
- min. 12 komponentów, w tym zarówno komponenty podstawowe (np. przycisk, pole tekstowe, etykieta statusu), jak i złożone z innych komponentów (np. karta zgłoszenia, formularz, tabela z filtrowaniem);
- prezentacja każdego komponentu we wszystkich jego stanach, które mają sens dla danego komponentu: domyślny, hover, focus, wyłączony, błąd, ładowanie;
- kolory i typografia w kodzie odpowiadają tym z Figmy, a jeżeli w Figmie zdefiniowano tokeny - tokeny w kodzie mają te same nazwy i wartości;
- komponenty są responsywne;
- instrukcja uruchomienia biblioteki w pliku `README.md` repozytorium;
- spełnienie [wymagań ogólnych](#wymagania-ogólne-dotyczące-interfejsu).

Wykorzystanie Storybooka (story dla każdego stanu, edycja parametrów przez panel controls, dokumentacja komponentów) jest dodatkowo premiowane w ocenie $k_2$.

#### Sprawozdanie

Należy opracować sprawozdanie z pracy projektowej. Warunki zaliczenia kształtują się następująco:
- sprawozdanie jest skonstruowane w technologii $\LaTeX$ i oddane w formacie PDF, niezależnie od sprawozdania z PPSI2;
- sprawozdanie jest dostarczone najpóźniej w dniu oddania całego projektu w formie elektronicznej (najlepiej dodane do repozytorium);
- sprawozdanie zawiera jako rozdziały lub sekcje:
    - opis użytkowników i interesariuszy systemu,
    - opis design systemu: kolorystyka, typografia, komponenty (oraz tokeny, jeżeli zostały zdefiniowane), zasady ich stosowania,
    - uzasadnienie najważniejszych decyzji projektowych,
    - opis rozwiązań w zakresie użyteczności, responsywności i kontrastu (breakpointy, zachowanie nawigacji i widoków na mobile, kolorystyka i kontrast),
    - wnioski projektowe od każdego z członków zespołu.

#### Prezentacja pracy projektowej

Należy przedstawić całym zespołem efekty swojej pracy. Prezentacja obejmuje przejście przez proces projektowy - od makiety do gotowego komponentu - oraz pokazanie spójności między makietą w Figmie, biblioteką komponentów i wdrożoną aplikacją. W trakcie prezentacji prowadzący zadaje pytania poszczególnym członkom zespołu dotyczące podjętych decyzji projektowych i implementacji komponentów oraz może poprosić o wprowadzenie zmiany na żywo.

Dopuszczalne jest korzystanie z narzędzi opartych o sztuczną inteligencję. Zespół odpowiada jednak za całość oddanej pracy - brak zrozumienia własnych decyzji projektowych lub kodu w trakcie obrony skutkuje obniżeniem oceny $k_3$, a w skrajnych przypadkach również pozostałych ocen.

#### Kryteria oceny

| Ocena | Co jest oceniane                                                                                                                                                     |
|-------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| $k_1$ | spójność i kompletność design systemu, konsekwentne stosowanie kolorystyki, typografii i komponentów, jakość wizualna makiet, spełnienie wymagań UX, RWD i kontrastu |
| $k_2$ | zgodność komponentów z Figmą, kompletność stanów, jakość kodu komponentów, wykorzystanie komponentów w aplikacji z PPSI2, spełnienie wymagań UX, RWD i kontrastu  |
| $k_3$ | sprawozdanie, prezentacja, spójność makiet, biblioteki komponentów i wdrożonej aplikacji, odpowiedzi na pytania                                                   |
