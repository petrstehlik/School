module Main
        (main)
    where

import System.Environment
import System.IO
import Data.Char
import Data.List
import Data.List.Split
import Debug.Trace

import Parameters
import Models
import ReachableState hiding(debug)

debug = flip trace

rmdups :: (Ord a) => [a] -> [a]
rmdups = map head . group . sort

stripChars :: String -> String -> String
stripChars = filter . flip notElem

--rmdups' :: [String] -> [[Char]]
--rmdups' (x:xs) = x ++ (rmdups' xs)

p :: String -> [[Char]]
p (x:xs) = if length xs == 1 then [[x]] ++ [xs] else ([[x]] ++ (p (xs)))

main :: IO ()
main = do
    args <- getArgs
    let params = parseArgs args
    content <- (fetchFile ( inputFile params ) )

    -- Loaded grammar
    let cfg = parseContent (lines content)

    -- Just print the loaded grammar
    if printFlag params
        then if length (outputFile params) > 0
            then saveCFG cfg (outputFile params)
            else printCFG cfg

    -- Remove non-generating nonterminals
    else if first_alg params
        then do
            let nNonTerms = (termGenerators cfg)
            let nRules = clearRules nNonTerms (rules cfg) []
            let nTerms = nub $ clearTerminals nNonTerms nRules []

            let nonGenCFG = CFG {
                nonTerminals = nNonTerms
                , startSymbol = (startSymbol cfg)
                , terminals = nTerms
                , rules = nRules
            }

            if length (outputFile params) > 0
                then saveCFG nonGenCFG (outputFile params)
                else printCFG nonGenCFG
    -- convert grammar to proper grammar
    else if second_alg params
        then do
            -- Remove non-generating nonterminals aka first algorithm
            let nTerm = (termGenerators cfg)
            let newCfg = CFG {
                nonTerminals = ( nTerm)
                -- Start symbol is always the same
                , startSymbol = (startSymbol cfg)
                , terminals = (terminals cfg)
                , rules = (clearRules nTerm (rules cfg) [])
            }

            -- Continue with removing unreachable rules
            let properNT = findReachableStates newCfg
            let properRules = clearRules properNT (rules newCfg) []
            let properTerms = nub $ clearTerminals properNT properRules []

            let properCFG = CFG {
                nonTerminals = properNT
                -- start symbol is always the same
                , startSymbol = (startSymbol newCfg)
                , terminals = properTerms
                , rules = properRules
            }

            if length (outputFile params) > 0
                then saveCFG properCFG (outputFile params)
                else printCFG properCFG
    else
        error "Wrong arguments"

fetchFile :: String -> IO String
fetchFile inFile = if length inFile  > 0
    then readFile inFile
    else getContents

termGenerators :: CFG -> [String]
termGenerators cfg = ( termGenerators' (rules cfg) [[startSymbol cfg]] )

termGenerators' :: [Rule] -> [String] -> [String]
termGenerators' rules nonTerms = do
    let newNonTerms = (termGenerators'' rules nonTerms) --`debug` "new: " ++ newNonTerms
    nub $ until ( /= newNonTerms) (termGenerators'' rules) newNonTerms

termGenerators'' :: [Rule] -> [String] -> [String]
termGenerators'' (rule : rules) nonTerms  = if (isTermGenerator rule nonTerms)
    then termGenerators'' rules (nonTerms ++ [[nt rule]])
    else termGenerators'' rules nonTerms
termGenerators'' [] nonTerms = nonTerms

isTermGenerator :: Rule -> [String] -> Bool
isTermGenerator rule nonTerms = if ( any isLower (body rule) ) &&
    (termGenerator (body rule) nonTerms)
        then True
    else if ( (body rule) == "#" )
        then True
    else False --`debug` (body rule)

termGenerator :: String -> [String] -> Bool
termGenerator (nonT : bodyRule ) nonTerms = if ([[nonT]] \\ nonTerms == [])
        then termGenerator bodyRule nonTerms
    else if (isLower nonT)
        then termGenerator bodyRule nonTerms
    else False
termGenerator [] _ = True

-- Clear rules of useless rules
-- @Input List of acceptable non-terminals
-- @input List of all rules
-- @Input List of cleared rules
clearRules :: [String] -> [Rule] -> [Rule] -> [Rule]
clearRules nonTerms (rule : rules) clr = do
    let clearedNonTerm = ([[nt rule]] \\ nonTerms)
    if clearedNonTerm == [] &&
       (all isLower (stripChars (concat nonTerms) (body rule)))
    then clearRules nonTerms rules (clr ++ [Rule {nt = (nt rule), body = (body rule)}])
    else if clearedNonTerm == [] &&
        length (stripChars (concat nonTerms) (body rule)) == 0
    then clearRules nonTerms rules (clr ++ [Rule {nt = (nt rule), body = (body rule)}])
    else if clearedNonTerm == [] && (body rule) == "#"
    then clearRules nonTerms rules (clr ++ [Rule {nt = (nt rule), body = (body rule)}])
    else clearRules nonTerms rules clr

clearRules nonTerms [] clr = clr

-- Clear terminals of useless rules
-- @Input List of acceptable non-terminals
-- @Input List of rules
-- @Input List of cleared terminals
-- @Output Cleared list of terminals
clearTerminals :: [String] -> [Rule] -> [String] -> [String]
clearTerminals nonTerms (rule:rules) terms = do
    let clrBody = stripChars (concat nonTerms) (body rule)
    if length clrBody > 0 --`debug` ("body: " ++ clrBody) `debug` ("rule: " ++ [(nt rule)])

        then clearTerminals nonTerms rules (terms ++ init (splitString clrBody))
        else clearTerminals nonTerms rules terms
clearTerminals nonTerms [] terms = terms
--
-- Parse input CFG
--
parseContent :: [String] -> CFG
parseContent content = if (null content || length content < 4)
    then error "Wrong input file"
    else CFG {
        nonTerminals = parseNonTerminals content
        , startSymbol = getStartSymbol content
        , terminals = parseTerminals content
        , rules = parseRules content
    }

parseNonTerminals :: [String] -> [String]
parseNonTerminals (nonTerm : _ ) = splitOn "," nonTerm

parseTerminals :: [String] -> [String]
parseTerminals (_ : term : _) = splitOn "," term

getStartSymbol :: [String] -> Char
getStartSymbol (_ : _ : state : _) = state !! 0

parseRules :: [String] -> [Rule]
parseRules(_:_:_:rules) = parseRules' rules

parseRules' :: [String] -> [Rule]
parseRules' [rule] = [parseRule rule]
parseRules'(rule : rules) = ([parseRule rule]) ++ (parseRules' rules)

parseRule :: String -> Rule
parseRule (rule) = parseRule' (splitOn "->" rule)

parseRule' :: [String] -> Rule
parseRule' (nonterm : rule) = Rule { nt = nonterm !! 0, body = rule !! 0 }

--
-- print and save the CFG
--
printCFG :: CFG -> IO ()
printCFG cfg = do
    putStrLn (intercalate "," ( ( nonTerminals cfg )) )
    putStrLn (intercalate "," ( terminals cfg ) )
    putStrLn ([startSymbol cfg])
    putStrLn (intercalate "\n" ( map ( ruleToString ) ( rules cfg ) ) )

saveCFG :: CFG -> String -> IO ()
saveCFG cfg outFile = do
    writeFile outFile ( (intercalate "," ( nonTerminals cfg ) ) ++ "\n" )
    appendFile outFile ( (intercalate "," ( terminals cfg ) ) ++ "\n" )
    appendFile outFile ( ( [startSymbol cfg] ) ++ "\n" )
    appendFile outFile ((intercalate "\n" ( map ( ruleToString ) ( rules cfg ) ) )++"\n")

ruleToString :: Rule -> String
ruleToString rule = [(nt rule)] ++ "->" ++ (body rule)


