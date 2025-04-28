# fawry_Task

1.  A breakdown of how your script handles arguments and options.

Uses a while loop and case to parse options.
Supports -n (show line numbers), -v (invert match).
Verifies that search string and filename are provided.
Shows a help message if input is wrong.

2.  A short paragraph: If you were to support regex or -i/-c/-l options, how would your structure change?

Use grep built-in options: -i for ignore case, -c for count, -l for list matching files.
Extend case block to accept these flags.
Adjust the matching logic inside the while loop accordingly.

3.  What part of the script was hardest to implement and why?

Handling combined options like -vn together correctly.
Needed careful checking inside the loop without breaking argument parsing.

