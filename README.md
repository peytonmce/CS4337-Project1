\# README



This project is a prefix calculator written in Racket for CS4337 Project 1.



\## Files



\- `calculator.rkt` - Contains the calculator, including expression evaluation, history references, and interactive/batch mode handling.

\- `devlog.md` - Contains notes on the development process, including bugs and fixes.



\## Running the Program



Make sure Racket is installed, then open a terminal in the project directory.



To run in interactive mode:



```bash

racket calculator.rkt

```



To run in batch mode:



```bash

racket calculator.rkt -b

```



The program also accepts `--batch`. Enter `quit` to exit interactive mode.



\## Notes for the TA



The calculator supports addition, multiplication, integer division, unary negation, and references to previous results using `$n`. Successful results are assigned history IDs starting at 1. Invalid expressions and division by zero should produce an error message beginning with `Error:`.



Thank you for grading my project!

