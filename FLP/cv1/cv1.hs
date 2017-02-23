-- FLP exercise #1
-- 14. 2. 2017
-- Petr Stehlik

hello = print "Hello world!"

-- #2 Factorial
fac x =
	if x < 0 then
		error "Common..."
	else if x == 0 then
		1
	else
		fac (x - 1) * x

-- #3 Fibonacci
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

-- much faster
fib' n = f 0 1 n
	where
		f x _ 0 = x
		f a b n = f b (a + b) (n-1)

-- #4 lists
spoj [] ys = ys
spoj (x:xs) ys = x : spoj xs ys

-- Curryfication - right associative!!!
plus1 x = (+ 1) x

--filter (<10) [1, 9, 10, 11, 20]

-- We dont specify the second argument --> etha reduction
addList n m = map (+ n) m -- is equivalent to
addList' n = map (+n)

addFilterList addN = filter (>10) . addList (addN)

-- FoldX - accumulate values from a list
andl x = foldl (&&) True x
andr x = foldr (&&) True x

foldl' f acc [] = acc
foldl' f acc (x:xs) = foldl' f (f acc x) xs
--foldl' f acc (x:xs) = 

map' f = foldr(\a acc -> f a : acc) []

-- MAP na pulsemku!!!
map.map jakou ma signaturu?
