module Main
        (main)
    where

import System.Environment
import System.IO
import Data.Char
import Data.List
import Data.List.Split
import Debug.Trace

import Type.CFG

import Parser.Parameters
import Parser.CFG
import Parser.ClearNT
import ReachableState hiding (debug)

main :: IO ()
main = do
    (flag,file) <- parseArgs <$> getArgs

    if length file > 0
        then do
            cfg <- parseCFG <$> readFile file

            case flag of
                Print -> putStr . either show show $ cfg
                ClearNonterminals -> clearNonTerminals cfg
                ClearGrammar -> clearGrammar cfg
        else undefined

clearNonTerminals :: Either String CFG -> IO ()
clearNonTerminals (Right (cfg)) = do
    if checkCFG cfg
        then putStr ( show $ ( clearTerminals . clearRules . findTermGenerators ) cfg)
        else error "Incorrect grammar"

clearGrammar :: Either String CFG -> IO ()
clearGrammar (Right (cfg)) = do
    if checkCFG cfg
        then putStr ( show $ ( clearTerminals . clearRules . findReachableStates . clearRules . findTermGenerators ) cfg)
        else error "Incorrect grammar"


checkCFG :: CFG -> Bool
checkCFG (CFG n e p s)
    | not $ all isUpper n = error "All nonterminals are not capitals"
    | not $ ( all isLower e || any (== '#') e ) = error "All terminals must be lower case"
    | (not $ isUpper s) = error "Incorrect start symbol"
    | ( length p ) < 1 = error "No rules specified"
    | otherwise = True

clearRules :: CFG -> CFG
clearRules (CFG n e p s) = CFG n e (clearRules' n p []) s
    where
        -- Clear rules of useless rules
        -- @Input List of acceptable non-terminals
        -- @input List of all rules
        -- @Input List of cleared rules
        clearRules' :: [Symbol] -> [Rule] -> [Rule] -> [Rule]
        clearRules' nonTerms ((Rule s b) : rules) clr = do
            let clearedNonTerm = ([s] \\ nonTerms)
            if null clearedNonTerm
                then if (all isLower ((nub b) \\ nonTerms))
                        || (length ((nub b) \\ nonTerms) == 0)
                        || (b == ['#'])
                    then clearRules' nonTerms rules (clr ++ [Rule s b])
                    else clearRules' nonTerms rules clr
            else clearRules' nonTerms rules clr
        clearRules' nonTerms [] clr = clr

clearTerminals :: CFG -> CFG
clearTerminals (CFG n e p s) = CFG n (nub $ clearTerminals' n p []) p s
    where
        -- Clear terminals of useless rules
        -- @Input List of acceptable non-terminals
        -- @Input List of rules
        -- @Input List of cleared terminals
        -- @Output Cleared list of terminals
        clearTerminals' :: [Symbol] -> [Rule] -> [Symbol] -> [Symbol]
        clearTerminals' nonTerms ((Rule s b):rules) terms = do
            let clrBody = (nub b) \\ nonTerms
            if length clrBody > 0
                then clearTerminals' nonTerms rules (terms ++ clrBody)
                else clearTerminals' nonTerms rules terms
        clearTerminals' nonTerms [] terms = terms
