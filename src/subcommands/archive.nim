import std/[cmdline, options, os, parsecfg, paths, sequtils, strutils, sugar]
import ../[config, console, files]
import ../fuzzy/fuzzy

const name = "archive"
const aliases = @["a"]

proc process*(
  config: Config,
  query: string,
  ls: Option[bool],
  noPrintDate: Option[bool]
  ) =

  if ls.isSome:
    printFiles(
      getFilesforDir(getNotesPath(config) & ".jn-archive"),
      config,
      noPrintDate
    )
    return

  var query = commandLineParams()[1..^1].join(" ")

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

  let archive = Path(getNotesPath(config) & ".jn-archive")

  discard existsOrCreateDir($archive)

  for choice in choices:
    let fileName = extractFilename(choice)
    let fullName = choice.replace("/", "-")[1..^1] # Trim off the '/'
    let destination = joinPath($archive, fullName)

    moveFile(choice, destination)

    success("Archived " & $fileName & " -> " & destination)
