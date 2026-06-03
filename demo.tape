# VHS documentation
#
# Output:
#   Output <path>.gif               Create a GIF output at the given <path>
#   Output <path>.mp4               Create an MP4 output at the given <path>
#   Output <path>.webm              Create a WebM output at the given <path>
#
# Require:
#   Require <string>                Ensure a program is on the $PATH to proceed
#
# Settings:
#   Set FontSize <number>           Set the font size of the terminal
#   Set FontFamily <string>         Set the font family of the terminal
#   Set Height <number>             Set the height of the terminal
#   Set Width <number>              Set the width of the terminal
#   Set LetterSpacing <float>       Set the font letter spacing (tracking)
#   Set LineHeight <float>          Set the font line height
#   Set LoopOffset <float>%         Set the starting frame offset for the GIF loop
#   Set Theme <json|string>         Set the theme of the terminal
#   Set Padding <number>            Set the padding of the terminal
#   Set Framerate <number>          Set the framerate of the recording
#   Set PlaybackSpeed <float>       Set the playback speed of the recording
#   Set MarginFill <file|#000000>   Set the file or color the margin will be filled with.
#   Set Margin <number>             Set the size of the margin. Has no effect if MarginFill isn't set.
#   Set BorderRadius <number>       Set terminal border radius, in pixels.
#   Set WindowBar <string>          Set window bar type. (one of: Rings, RingsRight, Colorful, ColorfulRight)
#   Set WindowBarSize <number>      Set window bar size, in pixels. Default is 40.
#   Set TypingSpeed <time>          Set the typing speed of the terminal. Default is 50ms.
#
# Sleep:
#   Sleep <time>                    Sleep for a set amount of <time> in seconds
#
# Type:
#   Type[@<time>] "<characters>"    Type <characters> into the terminal with a
#                                   <time> delay between each character
#
# Keys:
#   Escape[@<time>] [number]        Press the Escape key
#   Backspace[@<time>] [number]     Press the Backspace key
#   Delete[@<time>] [number]        Press the Delete key
#   Insert[@<time>] [number]        Press the Insert key
#   Down[@<time>] [number]          Press the Down key
#   Enter[@<time>] [number]         Press the Enter key
#   Space[@<time>] [number]         Press the Space key
#   Tab[@<time>] [number]           Press the Tab key
#   Left[@<time>] [number]          Press the Left Arrow key
#   Right[@<time>] [number]         Press the Right Arrow key
#   Up[@<time>] [number]            Press the Up Arrow key
#   Down[@<time>] [number]          Press the Down Arrow key
#   PageUp[@<time>] [number]        Press the Page Up key
#   PageDown[@<time>] [number]      Press the Page Down key
#   Ctrl+<key>                      Press the Control key + <key> (e.g. Ctrl+C)
#
# Display:
#   Hide                            Hide the subsequent commands from the output
#   Show                            Show the subsequent commands in the output
#   ScrollUp[@<time>] [number]      Scroll terminal viewport up by rows
#   ScrollDown[@<time>] [number]    Scroll terminal viewport down by rows

# Output demo.gif
Output demo.webm

Require jn

Set Shell "bash"
Set FontSize 18
Set Width 1000
Set Height 600
Set TypingSpeed 75ms


# Show raw invocation
Sleep 1s
Type "# jn on its own will give you an overview of your notes"
Enter
Sleep 1s
Type "jn"
Sleep 1s
Enter
Sleep 2s
Ctrl+l

# Show creating notes
Sleep 1s
Type "# Give jn a string to start writing notes"
Enter
Sleep 1s
Type "jn 'demo time'"
Sleep 500ms
Enter
Sleep 500ms
Type "iHello peepers!" 
Sleep 400ms
Escape
Type ":wq"
Enter
Sleep 3s
Ctrl+l


# Cat the note
Sleep 1s
Type "# Display notes with jn cat"
Enter
Type "jn cat"
Sleep 500ms
Enter
Type "demotime" 
Sleep 200ms
Enter
Sleep 2s
Ctrl+l

# Edit the note
Sleep 1s
Type "# Edit notes with jn edit"
Enter
Type "jn edit" 
Sleep 500ms
Enter
Sleep 500ms
Type "demotime"
Sleep 200ms
Enter
Type "o"
Enter
Type "Some more edits, right in your $EDITOR."
Escape
Type ":wq"
Enter
Sleep 2s
Ctrl+l

# Grep
Sleep 1s
Type "# Search notes with jn grep"
Enter
Type "jn grep peepers"
Sleep 500ms
Enter
Sleep 500ms
Enter
Sleep 500ms
Type "G"
Enter
Type "oFound via your grep."
Sleep 2s
Escape
Type ":wq"
Enter
Ctrl+l


# rm
Sleep 1s
Type "# Delete notes with jn rm"
Enter
Type "jn rm"
Sleep 500ms
Enter
Type "demotime"
Sleep 500ms
Enter
Sleep 500ms
Sleep 2s
Ctrl+l



# multi-select cat
Sleep 1s
Type "# Did I mention all commands support multi-selection?"
Enter
Type "jn cat"
Sleep 500ms
Enter
Type "de"
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
Type "# Oh, you can also manage tasks"
Enter
Type "jn todo --add 'bacon'"
Enter
Sleep 500ms
Type "jn todo --add 'sausage'"
Enter
Sleep 500ms
Type "jn todo --add 'eggs'"
Enter
Sleep 500ms
Type "jn todo --add 'bread'"
Enter
Sleep 500ms
Type "jn todo --add 'do NOT forget beans'"
Enter
Sleep 2s
Ctrl+l


Sleep 1s
Type "# Let's complete some tasks"
Enter
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
Type "# Let's find our 'done' tasks"
Enter
Type "jn todo --filter done"
Enter
Sleep 3s
Ctrl+l


# The rest
Sleep 1s
Type "# There's a lot you can do that I haven't covered. Read the README :)"
Enter
Sleep 2s

