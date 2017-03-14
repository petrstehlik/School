module ReachableState where

import Data.Char
import Data.List
import Models

import Debug.Trace

debug = flip trace

--rmdups = map head . group . sort

-- Initialize the algorithm with starting symbol of the supplied grammar
-- @Input CFG
-- @Output array of reachable states
findReachableStates :: CFG -> [String]
findReachableStates cfg = (frs' (rules cfg) [[startSymbol cfg]])

-- Start the computation of reachable states until the previous and curent
-- nonTerminals are the same
-- @Input Set of rules
-- @Input Set of reachable states (in this context only the starting symbol)
-- @Output New set of reachable states
frs' :: [Rule] -> [String] -> [String]
frs' rules symbols = do
    let newNT = frs'' rules symbols
    let cleared = nub $ until ( /= newNT) (frs'' rules) newNT
    -- The last elem is an empty string, remove it
    init cleared --`debug` (show cleared)

frs'' :: [Rule] -> [String] -> [String]
frs'' (rule:rules) symbols = if length ([[nt rule]] \\ symbols) == 0
    then frs'' rules (symbols ++ (splitString $ filter isUpper (body rule)))
    else frs'' rules symbols

frs'' [] symbols = symbols

-- Splits a string into a list of strings
-- @Bug leaves an empty string at the end
splitString :: String -> [String]
splitString (a:aa) = [[a]] ++ (splitString aa)
splitString [] = [[]]
