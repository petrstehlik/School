# fifteen puzzle (patnactka)
### FIT VUT | Course FLP | Project #2
### Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>

## Description
Write a program solves the fifteen puzzle. The puzzle can be in any dimensions.

## Notes about the code
There are 3 algorithms available -- DFS, DLS and IDS from which you can choose by un/commenting the given line in main.

Thanks to your advice the IDS algorithm finds the shortest solution and was really easy to implement thanks to DLS.

## Building the project
Suprisingly `make`

## Tests
Tests are located in the `tests` folder.

* test_orig.in -- this test is from the assignment document
* test_small.in -- a really small puzzle solvable in 1 step
* test_numbers.in -- numbers are not sequential
* test_8_steps.in -- 8 steps to solve the puzzle, it takes around 0.05 s to solve
* test_10_steps.in -- 10 steps, takes around 0.22 s
* test_12_steps.in -- 12 steps, takes around 1 s
* test_14_steps.in -- 14 steps, takes around 4 s
* test_16_steps.in -- 16 steps to solve the puzzle, it takes around 15 s to solve
* test_18_steps.in -- 18 steps to solve the puzzle, it takes around 80 s to solve

More complex matrices are really useless to test because it will take really long to solve it.
