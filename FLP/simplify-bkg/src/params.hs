module Parameters (Params
		, parseArgs
		, first_alg
		, second_alg
		, printFlag
		, inputFile
		, outputFile) where

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


--
-- Argument handling
--
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
parseArgs ["-1", inFile] = defaultParams {
	first_alg = True
	, inputFile = inFile
}
parseArgs ["-1", inFile, outFile] = defaultParams {
	first_alg = True
	, inputFile = inFile
	, outputFile = outFile
}

parseArgs ["-2"] = defaultParams { second_alg = True }
parseArgs ["-2", inFile] = defaultParams {
	second_alg = True
	, inputFile = inFile
}
parseArgs ["-2", inFile, outFile] = defaultParams {
	second_alg = True
	, inputFile = inFile
	, outputFile = outFile
}

parseArgs [] = error "Flag must be set"
parseArgs [_] = error "Flag must be set"
