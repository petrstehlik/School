set terminal svg enhanced font "arial,13" size 600,350
set output 'res.svg'
set style textbox transparent margins  1.0,  1.0 border
set xtics 0,10,110
set xlabel "Počet prvků (n)"
set ylabel "Čas výpočtu [s]"
f(x) = 0.0003*x
set key top left
plot [0:105][0:0.055]\
		'data.dat' using 1:2 t "Odhad" smooth cspline, \
		'data.dat' using 1:2 t "Naměřené výsledky",\
		(x > 5 && x < 100) ? f(x) : 1/0 t "Lineární odhad" dashtype "_ "
