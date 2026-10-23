\# 10-23-2026 6:00pm



I started working on the main part of the calculator by making a function that can read and evaluate a prefix expression. I decided to work on the actual expression evaluation first before trying to add the history and the input loop, since it seemed easier to get the basic operations working on their own.



The main function is eval-expr. It checks the first character to figure out what kind of expression it is dealing with. For numbers it calls read-number, and for operators it evaluates the expressions that come after them. The functions return a list containing the result and the rest of the characters that have not been read yet. This seems like a useful way to handle nested expressions without having to keep track of the position manually.



I also added skip-space so that spaces between parts of an expression do not cause problems. Right now the code handles addition, multiplication, and negation. I tested these with a few simple expressions, including a nested one, to make sure the recursion was working. There is still a lot missing, including division, history references, and the main loop that keeps asking the user for expressions. I want to get the basic parsing working first and then add those features one at a time.

