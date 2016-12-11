#!/bin/bash
pow=9
base=2

dt=0.001f
steps=1000
thr_blc=128
input=131072.dat
output=step0.dat

#8192 0.001f 1000 128 ../input.dat ../step0.dat

for i in `seq $pow 17`
do
	echo $i
	N=$((2**i))
	out="$(./nbody $N $dt $steps $thr_blc $input $output)"
	#timer="$(sed '/s/Time: \(.*\) s/\1/g/' $out)"
	timer="$(echo $out | cut -d" " -f18)"
	#echo $out
	echo $timer

done

