import std/[enumerate, os, parsecfg, paths, re, strutils]
import ./[config, files]

type Match* = object
  file*: string # TODO - make this a Path instead
  searchTerm*: string
  lineContent*: string
  lineNumber*: int


proc getMatches*(term: string, config: Config): seq[Match] = 
  var matches: seq[Match] = @[]

  let pattern = re("(?i)" & term)

  for file in getFilesForDir(getNotesPath(config)):

    try:
      let content = readFile(file.name)
      for lineNum, line in enumerate(content.splitLines()):
        if line.contains(pattern):
          matches.add(
            Match(
              file: file.name,
              searchTerm: term,
              lineContent: line,
              lineNumber: lineNum
            )
          )
    except IOError:
      discard

  return matches

proc search*(term: string, config: Config): seq[Match] =
  getMatches(term, config)
