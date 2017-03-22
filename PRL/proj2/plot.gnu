set terminal svg enhanced font "arial,14" size 600,400
set output 'res.svg'
set style textbox transparent margins  1.0,  1.0 border
set xtics 0,10,110
set xlabel "Počet prvků (n)"
set ylabel "Čas výpočtu [s]"

set key top left
plot [0:105][0:0.065]\
		'data.dat' using 1:2 t "Odhad" smooth cspline, \
		'data.dat' using 1:2 t "Naměřené výsledky"
