-- | Project #1 FLP
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: Utilities for both algorithms

module Utils.Cleaners
    (clearRules
    , clearTerminals
    )
    where

import Data.List
import Data.Char

import Type.CFG

-- | Clear useless rules from the grammar
-- @Input grammar to clear
-- @Output cleared grammar
clearRules :: CFG -> CFG
clearRules (CFG n e p s)
    | null n || null p = error "Incorrect grammar"
    | otherwise = CFG n e (clearRules' n p []) s
    where
        -- | Clear rules of useless rules
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

-- | Clear useless terminals from the grammar
-- @Input grammar to clear
-- @Output cleared grammar
clearTerminals :: CFG -> CFG
clearTerminals (CFG n e p s) = CFG n (nub $ clearTerminals' n p []) p s
    where
        -- | Clear terminals of useless rules
        -- @Input List of acceptable non-terminals
        -- @Input List of rules
        -- @Input List of cleared terminals
        -- @Output Cleared list of terminals
        clearTerminals' :: [Symbol] -> [Rule] -> [Symbol] -> [Symbol]
        clearTerminals' nonTerms ((Rule s b):rules) terms = do
            let clrBody = filter (/= '#') $ (nub b) \\ nonTerms
            if length clrBody > 0
                then clearTerminals' nonTerms rules (terms ++ clrBody)
                else clearTerminals' nonTerms rules terms
        clearTerminals' nonTerms [] terms = terms
