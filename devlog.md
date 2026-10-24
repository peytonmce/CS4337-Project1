\# 10-23-2026 5:27pm



I started working on the main part of the calculator by making a function that can read and evaluate a prefix expression. I decided to work on the actual expression evaluation first before trying to add the history and the input loop, since it seemed easier to get the basic operations working on their own.



The main function is eval-expr. It checks the first character to figure out what kind of expression it is dealing with. For numbers it calls read-number, and for operators it evaluates the expressions that come after them. The functions return a list containing the result and the rest of the characters that have not been read yet. This seems like a useful way to handle nested expressions without having to keep track of the position manually.



I also added skip-space so that spaces between parts of an expression do not cause problems. Right now the code handles addition, multiplication, and negation. I tested these with a few simple expressions, including a nested one, to make sure the recursion was working. There is still a lot missing, including division, history references, and the main loop that keeps asking the user for expressions. I want to get the basic parsing working first and then add those features one at a time.



\# 10-23-2026 6:16



I continued working on the expression evaluator and added division. I also spent some time looking at how the parser reads numbers and how it handles the characters left over after evaluating an expression. I am still using the same approach where each function returns the answer along with the rest of the input, since that makes it easier to evaluate nested expressions.



For division I used quotient, which performs integer division in Racket. I also added a check for dividing by zero so that the calculator does not try to perform an invalid operation. I tested the existing addition, multiplication, and negation examples again, along with a simple division example, to check that the new operator did not break the earlier ones.



The calculator is still far from finished. It currently evaluates expressions directly through test calls instead of repeatedly asking the user for input. It also does not have history references yet, and I still need to make sure that leftover characters are rejected. Those are the main things I want to work on next.



\# 10-23-2026 6:49pm



I worked on checking that the entire input is a valid expression instead of only evaluating the part that the calculator understands. Before this, the evaluator returned the result and the remaining characters, but nothing was checking whether those remaining characters were actually supposed to be there.



I added a new function called eval-complete. It calls the existing evaluator and then checks the leftover characters after skipping whitespace. If there is nothing left, it returns the result. Otherwise, it raises an invalid expression error. I kept this separate from `eval-expr so the parsing logic could stay mostly the same.



I added a test with extra text after a valid expression to check that it gets rejected, along with the earlier arithmetic tests. Next I want to start connecting the evaluator to the actual input loop so the program can read expressions repeatedly instead of only running the test calls.



\# 10-23-2026 7:36pm



I worked on adding history references to the calculator. The idea is that an expression can use a previous result by writing something like $0 instead of typing the number again. I added a function called read-history to read the digits after the dollar sign and use that number as an index into the history list.



I also changed eval-expr so it receives the history list as an argument. This lets history references work inside larger expressions, instead of only being handled separately. I updated eval-complete to pass the history along as well.



I added tests for using one previous result and combining two history references in the same expression. I also kept the earlier arithmetic tests to make sure the new changes did not break them. The next step is to connect the evaluator to the main input loop and work on the interactive and batch modes.



\# # 10-23-2026 9:21pm



I connected the expression evaluator to a loop that reads input repeatedly. Before this, the program only ran a few test expressions and stopped. Now it reads one line at a time and keeps going until the user enters `quit` or the input ends.



I also added the history handling to the loop. When an expression works, the result is printed with its history ID and added to the front of the history list using `cons`. The IDs start at 1, while the newest result is at the front of the list, so I had to account for that when looking up `$n` references. If an expression fails, it prints an error and keeps the existing history unchanged.



I added command-line argument checking for interactive and batch mode. Interactive mode shows a prompt, while batch mode should only print results and errors. I still need to test the different input cases carefully and make sure the output matches the assignment requirements.



\# 10-23-2026 10:05pm



Final Entry

I fixed the missing closing parentheses in read-history and the division case so the program could run correctly. I also corrected the $n history lookup to account for the order in which results are stored using cons. I reviewed division behavior and output formatting against the assignment samples, including number formatting, error message capitalization, and handling unexpected trailing characters. Finally, I checked the command-line mode handling for batch execution.



I also added a README file :D

