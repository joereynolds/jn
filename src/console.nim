import std/[envvars, terminal]

proc canDisplayColour(): bool =
  return existsEnv("NO_COLOR") or not stdout.isatty()

proc plain*(message: string) =
  echo message

proc success*(message: string) =

  if canDisplayColour():
    plain(message)
    return
  
  stdout.styledWriteLine(fgGreen, message)

proc info*(message: string) =

  if canDisplayColour():
    plain(message)
    return

  stdout.styledWriteLine(fgYellow, message)

proc dim*(message: string) =
  if canDisplayColour():
    stdout.write(message)
    return

  stdout.styledWrite({styleDim}, message)

proc warn*(message: string) {.raises: [].} =
  if canDisplayColour():
    plain(message)
    return

  try:
    stdout.styledWriteLine(fgRed, message)
  except:
    echo message
