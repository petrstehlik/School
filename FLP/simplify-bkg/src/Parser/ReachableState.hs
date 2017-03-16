-- Project #1 FLP
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: convert CFG to CFG without unreachable states
module Parser.ReachableState
    where

import Data.Char
import Data.List
import Type.CFG

-- Initialize the algorithm with starting symbol of the supplied grammar
-- 
-- @Input CFG
-- @Output array of reachable states
findReachableStates :: CFG -> CFG
findReachableStates (CFG n e p s) = CFG (frs p [s]) e p s
    where
        -- Start the computation of reachable states until the previous and curent
        -- nonTerminals are the same
        -- @Input Set of rules
        -- @Input Set of reachable states
        -- @Output New set of reachable states
        -- Note: I know this is ugly but I don't know how else it should be
        frs :: [Rule] -> [Symbol] -> [Symbol]
        frs rules symbols = do
            let newNT = frs' rules symbols

            if null newNT
                then error "The grammar must not generate empty language"
            else if (null $ newNT \\ symbols)
                then newNT
            else
                frs rules newNT

        frs' :: [Rule] -> [Symbol] -> [Symbol]
        frs' ((Rule s b):rules) v
                         |(elem s v) = frs' rules (v ++ (nub $ filter isUpper b))
                         | True = frs' rules v
        frs' [] v = nub v
