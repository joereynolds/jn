import std/times


proc validatePrefix*(prefix: string): string =
  try:
    discard now().format(prefix)
    return ""
  except TimeFormatParseError:
    return "The notes_prefix of " & prefix & " in your config is an invalid date format"
