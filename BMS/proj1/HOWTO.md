## Krok 1 (hotovo)
pripravit tridy pro praci se soubory

## Krok 2
upravit RSCode encode a decode funkce tak, aby prijimaly vektory a nepouzivaly NPAR. Byly parametrizovatelne.

pozn: puvodni soubor + NPAR = celkova velikost soubor + 1

## Krok 3
spojit RSCode s vlastnim kodem (soubory)

## Krok 4
napsat testovaci skript

## Poznamky
idealni pomer: (28/20) * (32/26) = 1.723 x velikost puvodniho souboru (max 175%). Vezmeme stejny princip jako se pouziva v CD (prvni pruchod slabe kodovani, druhe silnejsi). Dokaze odstranit i vetsi burstove chyby.
