module Parser.CFG
    where

import Text.ParserCombinators.ReadP
import Type.CFG

parseCFG :: String -> Either String CFG
parseCFG s = case readP_to_S cfgParser s of
    [(a,_)] -> Right a
    _ -> Left "Parser failed"

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

newLine :: ReadP Char
newLine = char '\n'

comma :: ReadP Char
comma = char ','

gt :: ReadP Char
gt = char '>'

minus :: ReadP Char
minus = char '-'

parseSymbol :: ReadP Symbol
parseSymbol = get

parseSymbols :: ReadP [Symbol]
parseSymbols = sepBy1 parseSymbol comma

parseRuleBody :: ReadP Body
parseRuleBody = many1 $ satisfy (/= '\n')

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
