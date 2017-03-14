module Models where

import Data.List


data Rule = Rule
    { nt :: Char
    , body :: String
    } deriving (Eq, Show)


data CFG = CFG
    { nonTerminals :: [String]
    , terminals :: [String]
    , rules :: [Rule]
    , startSymbol :: Char
    } deriving (Eq)

instance Show CFG where
    show (CFG n e p s) = show ( intercalate "," n ) ++ "\n"
        ++ show ( intercalate "," e ) ++ "\n"
        ++ show s ++ "\n"
        ++ show p
