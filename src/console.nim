import std/[envvars, terminal]

proc plain*(message: string) =
  echo message

proc success*(message: string) =

  if existsEnv("NO_COLOR"):
    plain(message)
    return
  
  stdout.styledWriteLine(fgGreen, message)

proc info*(message: string) =

  if existsEnv("NO_COLOR"):
    plain(message)
    return

  stdout.styledWriteLine(fgYellow, message)

proc dim*(message: string) =
  if existsEnv("NO_COLOR"):
    stdout.write(message)
    return

  stdout.styledWrite({styleDim}, message)

proc warn*(message: string) {.raises: [].} =
  if existsEnv("NO_COLOR"):
    plain(message)
    return

  try:
    stdout.styledWriteLine(fgRed, message)
  except:
    echo message
