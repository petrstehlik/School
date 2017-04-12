set terminal svg enhanced font "arial,13" size 600,350
set output 'res.svg'
set style textbox transparent margins  1.0,  1.0 border
set xtics 0,10,110
set xlabel "Počet prvků (n)"
set ylabel "Čas výpočtu [s]"
f(x) = 0.00003*x
stddev(x1,x2,avg) = ((x1-avg)*(x1-avg) + (x2-avg)*(x2-avg))/2
set key top left
#set logscale y
plot [0:16][0.00001:]\
		'results.dat' using 1:2 t "Odhad" smooth cspline, \
		'results.dat' using 1:2 t "Naměřené výsledky" ,\
		'results.dat' using 1:3 t "Min",\
		'results.dat' using 1:4 t "Max",\
		(x > 0 && x < 16) ? f(x) : 1/0 t "Lineární odhad" dashtype "_ "
#($2 - (($3-$2)^2 + ($4-$2)^2)/2):($2 + (($3-$2)^2 + ($4-$2)^2)/2)
