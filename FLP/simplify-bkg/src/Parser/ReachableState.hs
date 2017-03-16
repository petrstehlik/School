module Parser.ReachableState
    where

import Data.Char
import Data.List
import Type.CFG

-- Initialize the algorithm with starting symbol of the supplied grammar
-- @Input CFG
-- @Output array of reachable states
--findReachableStates :: CFG -> [String]
--findReachableStates cfg = (frs' (rules cfg) [[startsymbol cfg]])
findReachableStates :: CFG -> CFG
findReachableStates (CFG n e p s) = CFG (frs p [s]) e p s
    where
        -- Start the computation of reachable states until the previous and curent
        -- nonTerminals are the same
        -- @Input Set of rules
        -- @Input Set of reachable states (in this context only the starting symbol)
        -- @Output New set of reachable states
        frs :: [Rule] -> [Symbol] -> [Symbol]
        frs rules symbols = do
            let newNT = frs' rules symbols
            nub $ until (\x -> null $ x \\ newNT) (frs' rules) newNT

        frs' :: [Rule] -> [Symbol] -> [Symbol]
        frs' ((Rule s b):rules) v
                         | null ([s] \\ v) = frs' rules (v ++ (nub $ filter isUpper b))
                         | True = frs' rules v
        frs' [] v = v
