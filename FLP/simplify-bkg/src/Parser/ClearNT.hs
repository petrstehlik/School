module Parser.ClearNT
    ( findTermGenerators )
  where

import Data.List
import Data.Char
import Type.CFG
import Debug.Trace

debug = flip trace

findTermGenerators :: CFG -> CFG
findTermGenerators (CFG n e p s) = CFG (termGenerators p []) e p s
    where
        termGenerators :: [Rule] -> [Symbol] -> [Symbol]
        termGenerators rules nonTerms = do
            let newNonTerms = (termGenerators'' rules nonTerms)
            nub $ until (\x -> not $ null $ x \\ newNonTerms ) (termGenerators'' rules) newNonTerms

termGenerators'' :: [Rule] -> [Symbol] -> [Symbol]
termGenerators'' (rule:rules) nonTerms =
    if (isTermGenerator rule nonTerms)
        then termGenerators'' rules (nonTerms ++ [symbol rule])
        else termGenerators'' rules nonTerms
termGenerators'' [] nonTerms = nonTerms

isTermGenerator :: Rule -> [Symbol] -> Bool
isTermGenerator (Rule s b) nonTerms =
    if ( any isLower b ) && (null $ (nub $ filter isUpper b) \\ (nub nonTerms)) && ([s] /= b)
        then True
    else if (null $ (nub $ filter isUpper b) \\ (nub nonTerms)) && ([s] /= b)
        then True
    else if ( b == "#" )
        then True
    else False
