import std/os
import std/osproc
import std/parsecfg
import std/strutils

import ../config
import ../files
import ../grep

const aliases* = @["tag", "tags"]

proc process*(searchTerm: string, config: Config) =
  var tagTerm = searchTerm.strip()
  
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

  if matches == "":
    echo "No matches, quitting"
    quit()

  var choice = execProcess("echo " & quoteShell(matches) & " | " & fuzzy)
  choice.stripLineEnd()

  if choice == "":
    quit()

  discard os.execShellCmd(getEditor() & " " & quoteShell(choice))
