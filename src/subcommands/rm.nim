import std/os
import std/parsecfg
import std/strutils
import std/tempfiles
import ../fuzzy
import ../console
import ../config

const aliases* = @["rm", "remove"]

proc process*(config: Config) =
  var choice = makeSelection(
    getNotesLocation(config),
    config
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let content = readFile(choice)
  removeFile(choice)

  let (tempFile, path) = createTempFile("jn-", "")
  tempfile.write(content)

  let message = "Deleted " & choice & ". Backup is at " & path
  success(message)

  close tempFile
