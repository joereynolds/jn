Output reddit.webm

Require jn

Set Shell "bash"
Set FontSize 18
Set Width 1200
Set Height 600
Set TypingSpeed 75ms

Hide
Type "touch ~/Documents/jn-demo/jn-file-1"
Enter
Type "touch ~/Documents/jn-demo/jn-file-2"
Enter
Type "touch ~/Documents/jn-demo/jn-file-3"
Enter
Type "touch ~/Documents/jn-demo/jn-file-4"
Enter
Type "rm -f ~/Documents/jn-demo/todo.md"
Enter
Ctrl+l
Show

# multi-select mv
Sleep 1s
Type "jn mv"
Sleep 1s
Enter
Sleep 1s
Type "jn-file"
Tab
Sleep 200ms
Tab
Sleep 200ms
Tab
Sleep 200ms
Enter

Type "War and Peace"
Enter
Sleep 1s

Type "Peace sells"
Enter
Sleep 1s

Type "Rust in Peace"
Enter
Sleep 1s

Sleep 2s
Ctrl+l

# multi-select rm
Sleep 1s
Type "jn rm"
Sleep 1s
Enter
Sleep 1s
Type "Peace"
Tab
Sleep 200ms
Tab
Sleep 200ms
Tab
Sleep 200ms
Enter
Sleep 2s
Ctrl+l


# multi-select cat
Sleep 1s
Type "jn cat"
Sleep 1s
Enter
Sleep 1s
Type "guitar"
Tab
Sleep 200ms
Tab
Sleep 200ms
Tab
Sleep 200ms
Tab
Sleep 500ms
Enter
Sleep 500ms
Sleep 2s
Ctrl+l


# todos 
Sleep 1s
Type "jn todo --add 'bacon'"
Enter
Sleep 500ms
Type "jn todo --add 'sausage'"
Enter
Sleep 500ms
Type "jn todo --add 'eggs'"
Enter
Sleep 500ms
Type "jn todo --add 'do NOT forget beans'"
Enter
Sleep 2s
Ctrl+l


Sleep 1s
Type "jn todo"
Enter
Sleep 500ms
Tab
Sleep 200ms
Tab
Sleep 200ms
Tab
Sleep 200ms
Enter
Sleep 2s
Ctrl+l


Sleep 1s
Type "jn todo --filter done"
Enter
Sleep 3s
Ctrl+l

# The rest
Sleep 1s
Type "# Check it out at https://github.com/joereynolds/jn"
Enter
Sleep 2s

