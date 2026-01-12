import std/terminal

proc success*(message: string) =
    stdout.styledWriteLine(fgGreen, message)

proc info*(message: string) =
    stdout.styledWriteLine(fgYellow, message)

proc warn*(message: string) =
    stdout.styledWriteLine(fgRed, message)
