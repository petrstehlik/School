-- | Project #1 FLP
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: Types and utils for CFG
module Type.CFG
    where
-- | Each symbol is just a Character
type Symbol = Char
-- | Body of any rule is a non-empty string
type Body = String

-- | Structure that holds a single rule
data Rule = Rule
        { symbol :: Symbol
        , body :: Body
        }
    deriving (Eq, Show)

-- | Structure that holds the whole context-free grammar
data CFG = CFG
    { nonterminals :: [Symbol]
    , terminals :: [Symbol]
    , rules :: [Rule]
    , startsymbol :: Symbol
    } deriving (Eq)

-- | Textual representation of given CFG as project dictates
instance Show CFG where
    show (CFG n e p s) =
        showSymbols n "" ++ "\n"
        ++ showSymbols e "" ++ "\n"
        ++ [s] ++ "\n"
        ++ showRules p ""

-- | Helper function to display symbols separated by a comma
showSymbols :: [Symbol] -> String -> String
showSymbols (n:nt) s = showSymbols nt (s ++ [n] ++ ",")
showSymbols [] s
    | length s == 0 = ""
    | otherwise = init s

-- | Helper function to display rules
showRules :: [Rule] -> String -> String
showRules (r:rs) s = showRules rs (s ++ [(symbol r)] ++ "->" ++ (body r) ++ "\n")
showRules [] s = s

-- | Try at displaying correct errors
data TError =
    ParseError
