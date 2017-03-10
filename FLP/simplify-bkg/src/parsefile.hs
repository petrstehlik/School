import System.Environment
import System.IO
import Data.Char
import Data.List
import Data.List.Split
import Debug.Trace

import Parameters

debug = flip trace

rmdups :: (Ord a) => [a] -> [a]
rmdups = map head . group . sort

stripChars :: String -> String -> String
stripChars = filter . flip notElem

--rmdups' :: [String] -> [[Char]]
--rmdups' (x:xs) = x ++ (rmdups' xs)

p :: String -> [[Char]]
p (x:xs) = if length xs == 1 then [[x]] ++ [xs] else ([[x]] ++ (p (xs)))

data Rule = Rule {
	nt :: Char
	, body :: String
	} deriving (Eq, Show)


data CFG = CFG { nonTerminals :: [String]
				, startSymbol :: Char
				, terminals :: [String]
				, rules :: [Rule]
			} deriving (Eq, Show)

data Params = Params {
	first_alg :: Bool
		, second_alg :: Bool
		, printFlag :: Bool
		, inputFile :: String
		, outputFile :: String
} deriving (Show, Eq)

defaultParams = Params {
	first_alg    = False
	, second_alg = False
	, printFlag = False
	, inputFile  = ""
	, outputFile = ""
}

main :: IO ()
main = do
	args <- getArgs
	let params = parseArgs args
	content <- (fetchFile ( inputFile params ) )
	let cfg = parseContent (lines content)

	if printFlag params then
		if length (outputFile params) > 0
			then saveCFG cfg (outputFile params)
		else
			printCFG cfg
	else print "should continue"

	print cfg

	print "done"

parseArgs :: [[Char]] -> Params
parseArgs ["-i"] = defaultParams { printFlag = True }
parseArgs ["-i", inFile] = defaultParams {
	printFlag = True
	, inputFile = inFile
}
parseArgs ["-i", inFile, outFile] = defaultParams {
	printFlag = True
	, inputFile = inFile
	, outputFile = outFile
}

parseArgs ["-1"] = defaultParams { first_alg = True }
--parseArgs ["-2"] = (False, True, False, "", "")

--parseArgs ["-i"] = (False, False, True, "", "")
--parseArgs ["-i", inFile] = (False, False, True, inFile, "")
--parseArgs ["-i", inFile, outFile] = (False, False, True, inFile, outFile)
parseArgs [] = error "Flag must be set"
parseArgs [_] = error "Flag must be set"

fetchFile :: String -> IO String
fetchFile inFile = if length inFile  > 0
	then readFile inFile
	else getContents

parseContent :: [String] -> CFG
parseContent content = if (null content || length content < 4)
	then error "Wrong input file"
	else CFG {
		nonTerminals = parseNonTerminals content
		, startSymbol = getStartSymbol content
		, terminals = parseTerminals content
		, rules = parseRules content
	}
	--else [getStartState content]

parseNonTerminals :: [String] -> [String]
parseNonTerminals (nonTerm : _ ) = splitOn "," nonTerm

parseTerminals :: [String] -> [String]
parseTerminals (_ : term : _) = splitOn "," term

getStartSymbol :: [String] -> Char
getStartSymbol (_ : _ : state : _) = state !! 0

parseRules :: [String] -> [Rule]
parseRules(_:_:_:rules) = parseRules' rules

parseRules' :: [String] -> [Rule]
parseRules' [rule] = [parseRule rule]
parseRules'(rule : rules) = ([parseRule rule]) ++ (parseRules' rules)

parseRule :: String -> Rule
parseRule (rule) = parseRule' (splitOn "->" rule)

parseRule' :: [String] -> Rule
parseRule' (nonterm : rule) = Rule {
									nt = nonterm !! 0
									, body = rule !! 0
								}

splitAtComma :: String -> [String]
splitAtComma ""  = []
splitAtComma seq = let (s, seq') = break (== ',') seq
		   in s : case seq' of
			       []	   -> []
			       (_ : seq'') -> splitAtComma seq''


printCFG :: CFG -> IO ()
printCFG cfg = do
	putStrLn (intercalate "," ( nonTerminals cfg ) )
	putStrLn (intercalate "," ( terminals cfg ) )
	putStrLn ([startSymbol cfg])
	putStrLn (intercalate "\n" ( map ( ruleToString ) ( rules cfg ) ) )

saveCFG :: CFG -> String -> IO ()
saveCFG cfg outFile = do
	writeFile outFile ( (intercalate "," ( nonTerminals cfg ) ) ++ "\n" )
	appendFile outFile ( (intercalate "," ( terminals cfg ) ) ++ "\n" )
	appendFile outFile ( ( [startSymbol cfg] ) ++ "\n" )
	appendFile outFile ((intercalate "\n" ( map ( ruleToString ) ( rules cfg ) ) )++"\n")

--rulesToString :: [Rule] -> [String]

ruleToString :: Rule -> String
ruleToString rule = [(nt rule)] ++ "->" ++ (body rule)


