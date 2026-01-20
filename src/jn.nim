import std/os
import std/cmdline
import std/parseopt
import std/strutils

import config
import subcommands/[book, cat, config as sconfig, edit, grep, help, mv, rm, star, tags, tmpl]
import files
import console

const version = "1.0.3"


let configuration = getConfig(getConfigLocation())

createNecessaryDirectories(configuration)

try:
  let validationResults = config.validate(configuration)
  for item in validationResults: echo item
except Exception as e:
  info(e.msg)

let params = commandLineParams()

for kind, key, val in getopt():
  case kind
  of cmdShortOption, cmdLongOption:
    case key
    of "h", "help":
      help.process(configuration)
    of "v", "version":
      echo version
  of cmdArgument:
    if key in cat.aliases:
      cat.process(configuration)
      quit()

    if key in sconfig.aliases:
      sconfig.process(configuration)
      quit()

    if key in edit.aliases:
      edit.process(configuration)
      quit()

    if key in help.aliases:
      help.process(configuration)
      quit()

    if key in tmpl.aliases:
      tmpl.process(configuration)
      quit()

    if key in star.aliases:
      star.process(configuration)
      quit()

    if key in rm.aliases:
      rm.process(configuration)
      quit()

    if key in mv.aliases:
      mv.process(configuration)
      quit()

    if key in grep.aliases:
      let searchTerm =
        if params.len > 1:
          params[1]
        else:
          ""
      grep.process(searchTerm, configuration)
      quit()

    if key in tags.aliases:
      let searchTerm =
        if params.len > 1:
          params[1]
        else:
          ""
      tags.process(searchTerm, configuration)
      quit()

    if key.startsWith("@"):
      book.process(params, configuration)
      quit()
    else:
      # Check if there's a book parameter (starts with @) in the params
      var bookName = ""
      for param in params:
        if param.startsWith("@"):
          bookName = param[1..^1]  # Remove the @ prefix
          break
      
      files.createNote(key, configuration, bookName)
  of cmdend:
    discard

if paramCount() <= 0:
  printDirectories(getDirectories(getNotesPath(configuration)))
