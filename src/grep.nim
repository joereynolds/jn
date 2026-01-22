import std/[os, parsecfg, re, strutils]
import ./[config, files]

# TODO - Move this to files and put it as part of getFilesForDir
# there's no need to bring back binary files, that's dumb
proc isSkippable(filename: string): bool =
  let ext = filename.splitFile.ext.toLowerAscii()

  return ext in [
    ".wav", ".mp3", ".mp4", ".avi", ".jpg", ".jpeg", 
    ".png", ".gif", ".zip", ".tar", ".gz", ".pdf", 
    ".exe", ".dll", ".so", ".bin", ".ttf",  ".pyc",
    ".otf", ".pyi", ".ogg", ".flac", ".reapeaks"
  ]


proc getMatches*(term: string, config: Config): seq[string] = 
  var matches: seq[string] = @[]

  let pattern = re("(?i)" & term)

  for file in getFilesForDir(getNotesPath(config)):

    if isSkippable(file):
      continue

    try:
      if readFile(file).contains(pattern):
        matches.add(file)
    except IOError:
      discard

  return matches

proc search*(term: string, config: Config): seq[string] =
  getMatches(term, config)

