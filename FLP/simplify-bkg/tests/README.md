# simplify-bkg-tests
Tests for FIT FLP project #1

## Running the tests

```Bash
bash testrunner.sh [1|2|i] (optional)
```
The option specifies the argument for simplify-bkg program. Defaults to `2`.

The script assumes several things:
* the binary is in parent folder
* the binary is named simplify-bkg
* tests are in testfiles/ folder
* the naming is as follows
    * `{testnumber}-test.in` for input file
    * `{testnumber}-test-1.out` for output of the first algorithm
    * `{testnumber}-test-2.out` for output of the second algorithm
