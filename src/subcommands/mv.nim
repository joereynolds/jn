import std/os
import std/parsecfg
import std/strutils
import std/times

import ../config
import ../fuzzy
import ../console

const aliases* = @["mv", "move"]

proc process*(config: Config, flags: seq[string]) =
  var choice = selectFromDir(
    getNotesPath(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

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

  if "--plain" in flags:
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
