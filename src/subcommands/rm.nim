import std/[os, parsecfg, strutils, tempfiles]
import ../fuzzy/fuzzy
import ../console
import ../config

const name = "rm"

proc process*(config: Config, query: string) =
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
