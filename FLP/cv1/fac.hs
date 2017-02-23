fac x =
	if x == 0 then
		1
	else
		fac (x - 1) * x

faktorial 0 = 1
faktorial n = n * faktorial (n-1)

main = print ( faktorial 50000 )
