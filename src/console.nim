import std/terminal

proc success*(message: string) =
  stdout.styledWriteLine(fgGreen, message)

proc info*(message: string) =
  stdout.styledWriteLine(fgYellow, message)

proc warn*(message: string) {.raises: [].} =
  try:
    stdout.styledWriteLine(fgRed, message)
  except:
    echo message

proc plain*(message: string) =
  echo message
