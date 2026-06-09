import std/[os, parsecfg, sequtils, sugar, strutils]

import ../config
import ../fuzzy/fuzzy
import ../console

const name = "cp"

proc process*(config: Config, query: string) =
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

    let fileName = lastPathPart(choice)
    let dirPath = parentDir(choice)

    stdout.write("Copy ")
    dim(dirPath & "/")
    stdout.write(fileName)
    stdout.write(" -> ")
    
    dim($dirPath & "/")
    stdout.flushFile()
  
    let input = stdin.readLine().strip()
  
    if input == "":
      warn("No name provided, aborting")
      quit()
  
    let newPath = dirPath / input
  
    if fileExists(newPath):
      warn("File already exists at: " & newPath)
      continue
  
    try:
      copyFile(choice, newPath)
      success("Copied: " & choice & " -> " & newPath)
    except OSError as e:
      warn("Failed to copy file: " & e.msg)
