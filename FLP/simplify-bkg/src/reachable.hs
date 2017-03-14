module ReachableState where

import Data.Char
import Models

rmdups = map head . group . sort

findReachableStates :: CFG -> [String]
findReachableStates cfg = frs' (rules cfg) [[startSymbol cfg]]

frs' :: ([Rule] -> [String]) -> [String]
frs' rules symbols = do
	let newNT = frs'' rules symbols
	nub $ until ( /= newNT) (frs'' rules) newNT

frs'' :: [Rule] -> [String] -> [String]
frs'' (rule:rules) symbols = if isReachable (filter isUpper rule) symbols
	then frs'' rules (symbols ++ [[nt rule]])
	else frs'' rules symbols

isReachable :: Rule -> [String] -> Bool
isReachable rule symbols = map if isUpper x &&  then [x] else []) "sdfAAAAF"

isReachable' :: [String] -> String -> Bool
isReachable' (symbol:symbols) rule = map (\x -> if symbol == x then True else isReachable' symbols rule) rule
isReachable' [] rule = False

stripLowerCase :: [String] -> [String]
stripLowerCase x = map ()
