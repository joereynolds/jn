import std/[cmdline, os, parsecfg, strutils, tempfiles]
import ../fuzzy
import ../console
import ../config

const aliases* = @["rm", "remove"]

proc process*(config: Config) =
  var query = commandLineParams()[1..^1].join(" ")

  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  var content = ""
  try:
    content = readFile(choice)
  except IOError:
    discard

  removeFile(choice)

  let (tempFile, path) = createTempFile("jn-", "")
  tempfile.write(content)

  let message = "Deleted " & choice & ". Backup is at " & path
  success(message)

  close tempFile
