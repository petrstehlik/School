-- | Module to find all generating nonterminals according to algorithm 4.1 (course TIN)
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: Find all nonterminals generating terminals
module Parser.ClearNT
    ( findTermGenerators )
  where

import Data.List
import Data.Char
import Type.CFG
import Debug.Trace

-- debug = flip trace

-- | Find all term generators according to algorithm 4.1
-- @Input Grammar to clear
-- @Output Cleared grammar
findTermGenerators :: CFG -> CFG
findTermGenerators (CFG n e p s) = case (termGenerators p []) of
    Left e -> error $ show e
    Right nt -> CFG nt e p s
    where
        -- | Find term generators
        -- @Input List of rules
        -- @Input List of symbols generatings terms
        -- @Output Error message
        -- @Output New list of symbols generating terms
        termGenerators :: [Rule] -> [Symbol] -> Either String [Symbol]
        termGenerators rules nonTerms = do
            -- Sort of do-while block
            let newNonTerms = termGenerators'' rules nonTerms
            -- Check if there is at least one term generator
            -- otherwise there is no reson to continue because of empty language
            if null newNonTerms
                then Left "The grammar must not generate empty language"
            else if (null $ newNonTerms \\ nonTerms)
                then Right newNonTerms
                else termGenerators rules newNonTerms

-- | Helper to determine list of all available term generators
-- Is called in the until loop until the result is stable (same as before)
-- @Input List of rules
-- @Input List of term generators
-- @Output Updated list of term generators
termGenerators'' :: [Rule] -> [Symbol] -> [Symbol]
termGenerators'' (rule:rules) nonTerms
    | isTermGenerator rule nonTerms = termGenerators'' rules (nonTerms ++ [symbol rule])
    | otherwise = termGenerators'' rules nonTerms
termGenerators'' [] nonTerms = nub nonTerms

-- | Determine if a rule is a term generator
-- @Input Rule
-- @Input List of term generators
-- @Output Bool
isTermGenerator :: Rule -> [Symbol] -> Bool
isTermGenerator (Rule s b) nonTerms
    | any isLower b && (null $ (nub $ filter isUpper b) \\ nonTerms) = True
    | null $ (nub $ filter isUpper b) \\ nonTerms = True
    | b == "#" = True
    | otherwise = False
