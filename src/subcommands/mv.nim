import std/[os, parsecfg, sequtils, sugar, strutils, times]

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

    stdout.write("Rename " & lastPathPart(choice) & " to ")
    stdout.flushFile()
  
    let newName = stdin.readLine().strip()
  
    if newName == "":
      warn("No name provided, aborting")
      quit()
  
    let suffix = getNotesSuffix(config)
    let dateFormat = getNotesPrefix(config)
    let prefix = now().format(dateFormat)
  
    var fileName = prefix & "-" & newName.replace(" ", "-") & suffix
  
    if plain:
      fileName = newName
  
    let oldPath = choice
    let dirPath = parentDir(oldPath)
    let newPath = dirPath / fileName
  
    if fileExists(newPath):
      warn("File already exists at: " & newPath)
      quit()
  
    try:
      moveFile(oldPath, newPath)
      success("Renamed: " & lastPathPart(oldPath) & " -> " & fileName)
    except OSError as e:
      warn("Failed to rename file: " & e.msg)
      quit()
