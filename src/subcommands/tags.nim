import std/[os, osproc, parsecfg, sequtils, strutils]

import ../fuzzy
import ../config
import ../files
import ../grep


proc process*(config: Config, query: string) =
  var tagTerm = query.strip()

  # Strip '#' if user provided it
  if tagTerm.startsWith("#"):
    tagTerm = tagTerm[1..^1]

  if tagTerm == "":
    echo "Tags command is missing the tag name"
    quit()

  # Add '#' prefix to search for tags
  let tagSearch = "#" & tagTerm

  let notes = getFilesForDir(getNotesPath(config))
  let fuzzy = getFuzzyProvider(config)
  let matches = search(tagSearch, config)
  let fileNames = matches.mapIt(it.file)

  if matches == @[]:
    echo "No matches, quitting"
    quit()

  var choice = selectFromChoice(fileNames, config)

  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
