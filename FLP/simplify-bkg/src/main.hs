import System.Console.GetOpt
import System.Environment
import System.IO
import System.Exit
import Control.Monad

hello = putStrLn "Hello!"

main = do
	getArgs >>= parseArgs

help = "FUN project FLP 2017 \n" ++
	"usage: ./main [-i|-1|-2] input-file output-file"

parseArgs [flag, inFile, outFile] = do
	if (inFile == "")
		then inFile <- stdio
		--else do hinFile <- ( openFile inFile ReadMode )

	if outFile == ""
		then outFile = stdout--( openFile stdout WriteMode )
		--else let houtFile = ( openFile outFile WriteMode )


	hinFile <- ( openFile inFile ReadMode )
	houtFile <- (openFile outFile WriteMode )

	case flag of
		("-i") -> print "found i!"
		("-1") -> print "found 1!"
		("-2") -> print "found 2!"

--print "Found i!" >> exitWith ExitSuccess
parseArgs [flag, inFile] = parseArgs [flag, inFile, ""]
parseArgs [flag] = parseArgs [flag, "", ""]
parseArgs [] = parseArgs ["", "", ""]
parseArgs fs = putStrLn help >> exitWith ExitSuccess

data Flags = Verbose
	| ParseOnly
	| Input (Maybe String)
	| Output (Maybe String)
	| Alg1
	| Alg2


options =
    [ Option ['v']  ["verbose"] (NoArg Verbose)       "chatty output on stderr"
    , Option ['i']  []  (NoArg ParseOnly)		"just parse the input"
    , Option ['1']  []  (NoArg Alg1)			"do just the first algorithm"
    , Option ['2']  []  (NoArg Alg2)			"do just the second algorithm"
    ]
