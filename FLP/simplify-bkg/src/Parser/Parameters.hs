-- Project #1 FLP
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: Get parameters
module Parser.Parameters
    where

data Parameter
    = Print                 -- -i
    | ClearNonterminals     -- -1
    | ClearGrammar          -- -2
    deriving (Show)

data PError
    = ParamsError
    | UnknownFlag
    | BadCombination

-- Argument handling
-- @Input List of arguments
-- @Output Flag and path to file
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
