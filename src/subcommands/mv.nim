import std/[os, parsecfg, sequtils, sugar, strutils]

import ../config
import ../fuzzy/fuzzy
import ../console

const name = "mv"

proc process*(config: Config, query: string, plain: bool) =
  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let choices = choice.split("\0")
                      .map(c => c.strip())
                      .filterIt(it != "")

  for choice in choices:

    let dirPath = parentDir(choice)
    let fileName = lastPathPart(choice)

    stdout.write("Rename ")
    dim(dirPath & "/")
    stdout.write(filename)
    stdout.write(" -> ")

    dim($dirPath & "/")
    stdout.flushFile()
  
    let newName = stdin.readLine().strip()
  
    if newName == "":
      warn("No name provided, aborting")
      quit()
  
    let dateFormat = getNotesPrefix(config)
    var input = newName.replace(" ", "-")
    let newPath = dirPath / input
  
    if fileExists(newPath):
      warn("File already exists at: " & newPath)
      continue
  
    try:
      moveFile(choice, newPath)
      success("Renamed: " & choice & " -> " & newPath)
    except OSError as e:
      warn("Failed to rename file: " & e.msg)
