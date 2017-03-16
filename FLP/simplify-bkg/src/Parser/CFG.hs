-- Project #1 FLP
-- Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
-- Description: Parse string into CFG
-- Mostly taken from: https://github.com/Tr1p0d/universal-turing-machine/blob/master/src/TM/Parser/TuringMachine.hs

module Parser.CFG
    where

import Text.ParserCombinators.ReadP
import Type.CFG

-- Parse the string to CFG
-- @Input CFG as string
-- @Output CFG
parseCFG :: String -> Either String CFG
parseCFG s = case readP_to_S cfgParser s of
    [(a,_)] -> Right a
    _ -> Left "Parser failed"

-- The parser
cfgParser :: ReadP CFG
cfgParser = do
    nonterminals <- parseSymbols
    newLine
    terminals <- parseSymbols
    newLine
    startsymbol <- get
    newLine
    rules <- parseRules
    eof
    return $ CFG nonterminals terminals rules startsymbol

-- Consume newline char
newLine :: ReadP Char
newLine = char '\n'

-- Consume comma
comma :: ReadP Char
comma = char ','

-- Consume '>'
gt :: ReadP Char
gt = char '>'

-- Consume '-'
-- Note: didn't have the nerve to solve it by one function (the "->")
minus :: ReadP Char
minus = char '-'

-- Fetch one symbol
parseSymbol :: ReadP Symbol
parseSymbol = get

-- Fetch symbols
parseSymbols :: ReadP [Symbol]
parseSymbols = sepBy1 parseSymbol comma

-- Fetch one rule
parseRuleBody :: ReadP Body
parseRuleBody = many1 $ satisfy (/= '\n')

-- Parse all the rules
parseRules :: ReadP [Rule]
parseRules = many1 $ do
    r <- parseRule
    newLine
    return r
  where
    parseRule = do
        symbol <- get
        minus
        gt
        body <- parseRuleBody
        return $ Rule symbol body
