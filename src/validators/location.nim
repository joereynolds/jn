import std/os


proc validateLocation*(location: string): string =
  if not dirExists(os.expandTilde(location)):
    return "The notes_location of " & location & " in your config does not exist"
  ""
