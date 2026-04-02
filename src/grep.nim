import std/[os, parsecfg, paths, re, strutils]
import ./[config, files]

type Match* = object
  file*: string # TODO - make this a Path instead
  searchTerm*: string
  lineContent: string

# TODO - Move this to files and put it as part of getFilesForDir
# there's no need to bring back binary files, that's dumb
proc isSkippable(filename: string): bool =
  let ext = filename.splitFile.ext.toLowerAscii()

  return ext in [
    ".wav", ".mp3", ".mp4", ".avi", ".jpg", ".jpeg", 
    ".png", ".gif", ".zip", ".tar", ".gz", ".pdf", 
    ".exe", ".dll", ".so", ".bin", ".ttf",  ".pyc",
    ".otf", ".pyi", ".ogg", ".flac", ".reapeaks", ".rpp",
    ".rpp-bak"
  ]


proc getMatches*(term: string, config: Config): seq[Match] = 
  var matches: seq[Match] = @[]

  let pattern = re("(?i)" & term)

  for file in getFilesForDir(getNotesPath(config)):

    if isSkippable(file.name):
      continue

    try:
      # - TODO - changed to line-by-line so we can grab the line, 
      # performance is down now though
      for line in lines(file.name):
        if line.contains(pattern):
          matches.add(
            Match(
              file: file.name,
              searchTerm: term,
              lineContent: line
            )
          )
    except IOError:
      discard

  return matches

proc search*(term: string, config: Config): seq[Match] =
  getMatches(term, config)
