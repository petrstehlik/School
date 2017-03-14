module Models where

data Rule = Rule {
    nt :: Char
    , body :: String
    } deriving (Eq, Show)


data CFG = CFG { nonTerminals :: [String]
                , startSymbol :: Char
                , terminals :: [String]
                , rules :: [Rule]
            } deriving (Eq, Show)

