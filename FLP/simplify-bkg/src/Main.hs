-- Project #1 FLP
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: Convert CFG accoring to algorithm 4.3 (course TIN)
module Main
        (main)
    where

import System.Environment
import System.IO
import Data.Char
import Data.List
import Data.List.Split

import Type.CFG

import Parser.Parameters
import Parser.CFG
import Parser.ClearNT
import Parser.ReachableState

import Utils.Cleaners

-- Workflow is as follows:
--  1) parse argument
--  2) parse input file

main :: IO ()
main = do
    (flag,file) <- parseArgs <$> getArgs

    if length file > 0
        then do
            cfg <- parseCFG <$> readFile file
            convert flag cfg
        else do
            cfg <- parseCFG <$> getContents
            convert flag cfg

-- We can begin with the magic
--              .
--          \^/|
--         _/ \|_
--
--      I SHALL PASS
convert :: Parameter -> Either String CFG -> IO ()
convert flag cfg =
            case cfg of
                Right c -> case flag of
                    Print -> putStr $ show c
                    ClearNonterminals -> clearNonTerminals c
                    ClearGrammar -> clearGrammar c
                Left e -> putStrLn $ "Error!\nReason: " ++ (e)

-- Initial function for Algorithm #4.1
-- @Input Grammar to clear
-- @Output IO
clearNonTerminals :: CFG -> IO ()
clearNonTerminals cfg
    | checkCFG cfg = putStr ( show $ ( clearTerminals
                                     . clearRules
                                     . findTermGenerators
                                     ) cfg )
    | otherwise = error "Incorrect grammar"

-- Initial function for Algorithm #4.3 (#4.2 included for free!)
-- @Input Grammar to clear
-- @Output IO
clearGrammar :: CFG -> IO ()
clearGrammar cfg
    | checkCFG cfg = putStr ( show $ ( clearTerminals
                                     . clearRules
                                     . findReachableStates
                                     . clearRules
                                     . findTermGenerators
                                     ) cfg )
    | otherwise = error "Incorrect grammar"

-- Sanity check of a grammar
-- @Input Grammar to check
-- @Output Validity of the given grammar
checkCFG :: CFG -> Bool
checkCFG (CFG n e p s)
    | (not $ all isUpper n) = error "All nonterminals are not capitals"
    | (not $ all isLower (e \\ ['#'])) = error "All terminals must be lower case"
    | (not $ isUpper s) || (not $ elem s n) = error "Incorrect start symbol"
    | ( length p ) < 1 = error "No rules specified"
    | otherwise = checkRules p n e

-- Check all rules if they are made of defined terminals and nonterminals
-- @Input List of rules
-- @Input List of nonterminals
-- @Input List of terminals
-- @Output True if all is valid
checkRules :: [Rule] -> [Symbol] -> [Symbol] -> Bool
checkRules ((Rule s b):rules) p t
    | (not $ elem s p) = error "Symbol not in list of symbols"
    | (not (null $ (((nub b) \\ p) \\ t))) = error "Rule is of undefined symbols"
    | otherwise = checkRules rules p t
checkRules [] _ _ = True
