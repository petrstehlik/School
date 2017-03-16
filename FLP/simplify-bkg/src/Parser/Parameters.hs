module Parser.Parameters
    where

--data Params = Params
--    { first_alg :: Bool
--    , second_alg :: Bool
--    , printFlag :: Bool
--    , inputFile :: String
--    }
--  deriving (Show, Eq)

data Parameter
    = Print                 -- -i
    | ClearNonterminals     -- -1
    | ClearGrammar          -- -2
    deriving (Show)

data PError
    = ParamsError
    | UnknownFlag
    | BadCombination


--------------------------------------------------------------------------------
-- Argument handling
--
parseArgs :: [String] -> (Parameter, String)
parseArgs [x,y]
    | x == "-1" = ( ClearNonterminals, y )
    | x == "-2" = ( ClearGrammar, y )
    | x == "-i" = ( Print, y )
    | otherwise = error "Unknown flag"

parseArgs [x]
    | x == "-1" = ( ClearNonterminals, "" )
    | x == "-2" = ( ClearGrammar, "" )
    | x == "-i" = ( Print, "" )
    | otherwise = error "UnknownFlag"

parseArgs _ = error "BadCombination"
