-- Project #1 FLP
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: Types and utils for CFG
module Type.CFG
    where

type Symbol = Char
type Body = String

data Rule = Rule
        { symbol :: Symbol
        , body :: Body
        }
    deriving (Eq, Show)


data CFG = CFG
    { nonterminals :: [Symbol]
    , terminals :: [Symbol]
    , rules :: [Rule]
    , startsymbol :: Symbol
    } deriving (Eq)

instance Show CFG where
    show (CFG n e p s) =
        showSymbols n "" ++ "\n"
        ++ showSymbols e "" ++ "\n"
        ++ [s] ++ "\n"
        ++ showRules p ""

showSymbols :: [Symbol] -> String -> String
showSymbols (n:nt) s = showSymbols nt (s ++ [n] ++ ",")
showSymbols [] s
    | length s == 0 = ""
    | otherwise = init s

showRules :: [Rule] -> String -> String
showRules (r:rs) s = showRules rs (s ++ [(symbol r)] ++ "->" ++ (body r) ++ "\n")
showRules [] s = s

data TError =
    ParseError
