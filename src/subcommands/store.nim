import std/[os, parsecfg, strformat, strutils]

import ../config
import ../console

const name = "store"

proc process*(config: Config, file: string) =
  if file.strip() == "":
    echo "Please supply a file i.e. jn store your-file.md"
    quit()

  if not fileExists(file):
    warn(fmt"File '{file}' does not exist.")
    return

  let target = getNotesPath(config) & file

  if fileExists(target):
    warn(fmt"File '{file}' already exists.")
    return

  moveFile(file, getNotesPath(config) & file)


