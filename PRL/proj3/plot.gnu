set terminal svg enhanced font "arial,13" size 600,350
set output 'res_8.svg'
set style textbox transparent margins  1.0,  1.0 border
set xtics 0,1,16
set xlabel "Počet prvků (n)"
set ylabel "Čas výpočtu [s]"
f(x) = 0.001*x
stddev(x1,x2,avg) = ((x1-avg)*(x1-avg) + (x2-avg)*(x2-avg))/2
set key top left
#set logscale y
plot [0.5:8.5][0.00001:]\
		'results.dat' using 1:2 t "Odhad" smooth cspline, \
		'results.dat' using 1:2 t "Průměr" ,\
		'results.dat' using 1:3 t "Minimum",\
		'results.dat' using 1:4 t "Maximum"#,\
#(x > 0 && x < 16) ? f(x) : 1/0 t "Lineární odhad" dashtype "_ "
#($2 - (($3-$2)^2 + ($4-$2)^2)/2):($2 + (($3-$2)^2 + ($4-$2)^2)/2)
