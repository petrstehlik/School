-- 3 elements
data Vector a = Vec Int [a]
	deriving (Show) -- po inicializaci je vzdy vypise

--initVector::[a] -> Vector a
initVector l = Vec (length l) l

dotProd (Vec l1 v1) (Vec l2 v2) =
	if l1 /= l2 then
		error "Mismatch in length"
	else
		sum ( zipWith (*) v1 v2)

-- next task
data Student = Student {
		name :: String,
		stip :: Integer,
		phd :: Bool
	}
	deriving (Show)

phdPayRise = map ppr where
	ppr s =
		if phd s then
			Student (name s) (2 * stip s) (phd s)
		else
			s

-- next task
data LExp = LVar String |
	LApp LExp LExp |
	LAbs String LExp
	deriving (Show)

freeVars le = fv le [] where
	fv (LVar v) l = if elem v l then [] else [v] -- if v in l return empty list
	fv (LApp e1 e2) l = fv e1 l ++ fv e2 l -- join two elems
	fv (LAbs v e) l = fv e (v:l) -- rekurzivne pridam do seznamu prvek z hlavicky

-- next task

countlines file = fmap (length . lines) (readFile file)
