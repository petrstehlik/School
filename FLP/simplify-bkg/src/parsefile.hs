import System.Environment
import System.IO
import Data.List
import Data.List.Split

data Rule = Rule {
	start :: Char
	, body :: String
	} deriving (Eq, Show)

data CFG = CFG { nonTerminals :: [String]
				, startSymbol :: Char
				, terminals :: [String]
				, rules :: [Rule]
			} deriving (Eq, Show)

main :: IO ()
main = do
	args <- getArgs
	let params = parseArgs args
	print params
	content <- (fetchFile params)
	let cfg = parseContent (lines content)

	--if checkIFlag params then printCFG cfg
	print (checkIFlag params)
	print cfg
	print "done"

parseArgs :: [[Char]] -> (Bool, Bool, Bool, String, String)
parseArgs ["-1"] = (True, False, False, "", "")
parseArgs ["-2"] = (False, True, False, "", "")
parseArgs ["-i"] = (False, False, True, "", "")
parseArgs ["-i", inFile] = (False, False, True, inFile, "")
parseArgs ["-i", inFile, outFile] = (False, False, True, inFile, outFile)
parseArgs [inFile, outFile] = (False, False, False, inFile, outFile)
parseArgs [inFile] = (False, False, False, inFile, "")
parseArgs [] = (False, False, False, "", "")

checkIFlag :: (Bool, Bool, Bool, String, String) -> Bool
checkIFlag (_:_:i:_:_) = i

fetchFile :: (Bool, Bool, Bool, String, String) -> IO String
fetchFile(_,_,_,inFile,_) = if length inFile > 0
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
									start = nonterm !! 0
									, body = rule !! 0
								}

splitAtComma :: String -> [String]
splitAtComma ""  = []
splitAtComma seq = let (s, seq') = break (== ',') seq
		   in s : case seq' of
			       []	   -> []
			       (_ : seq'') -> splitAtComma seq''


