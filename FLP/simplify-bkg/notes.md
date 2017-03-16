To check if two lists are the same
```Haskell
(["1", "2"] \\ ["2", "1", "3"]) ++ (["3", "1", "2"] \\ ["2", "1"])
```

To check if elem is in list
```Haskell
elem "S" ["A", "S"]
```

## How to compile
`ghc --make Main.hs -o ../simplify-bkg -hidir tmp`

## Resources
http://www.sanfoundry.com/automata-theory-cfg-eliminating-useless-symbols/
