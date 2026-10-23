\# 10-23-2026 5:27pm



I started working on the main part of the calculator by making a function that can read and evaluate a prefix expression. I decided to work on the actual expression evaluation first before trying to add the history and the input loop, since it seemed easier to get the basic operations working on their own.



The main function is eval-expr. It checks the first character to figure out what kind of expression it is dealing with. For numbers it calls read-number, and for operators it evaluates the expressions that come after them. The functions return a list containing the result and the rest of the characters that have not been read yet. This seems like a useful way to handle nested expressions without having to keep track of the position manually.



I also added skip-space so that spaces between parts of an expression do not cause problems. Right now the code handles addition, multiplication, and negation. I tested these with a few simple expressions, including a nested one, to make sure the recursion was working. There is still a lot missing, including division, history references, and the main loop that keeps asking the user for expressions. I want to get the basic parsing working first and then add those features one at a time.



\# 10-23-2026 6:16



I continued working on the expression evaluator and added division. I also spent some time looking at how the parser reads numbers and how it handles the characters left over after evaluating an expression. I am still using the same approach where each function returns the answer along with the rest of the input, since that makes it easier to evaluate nested expressions.



For division I used quotient, which performs integer division in Racket. I also added a check for dividing by zero so that the calculator does not try to perform an invalid operation. I tested the existing addition, multiplication, and negation examples again, along with a simple division example, to check that the new operator did not break the earlier ones.



The calculator is still far from finished. It currently evaluates expressions directly through test calls instead of repeatedly asking the user for input. It also does not have history references yet, and I still need to make sure that leftover characters are rejected. Those are the main things I want to work on next.

