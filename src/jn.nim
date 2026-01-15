import std/os
import std/cmdline
import std/parseopt
import std/strutils

import config
import subcommands/[book, cat, config as sconfig, edit, grep, rm, star, tmpl]
import files
import console

const version = "0.2"

const usage =
  """
jn - a file-based command line notebook

Usage:
  jn [command]

Available Commands:
  @<book>                 Show all notes for a book
  c,cat                   Fuzzy search and print note
  conf,config             Open config in $EDITOR
  e,edit                  Fuzzy search and open note in $EDITOR
  /,grep,rg               Grep for term and fuzzy search to edit
  rm,remove               Fuzzy search and delete note
  s,star                  Mark a note as "starred"
  template,temp,tm        Fuzzy search and edit template files
  -h, --help              Display this help
  -v, --version           Print jn's version

Examples:
   
Show all books:
  jn

Show all notes for a book called 'docker':
  jn @docker

Create a note:
  jn "my note title"

Create a note in a specific book:
  jn "how to exit vim" @vim

Grep for a term:
  jn grep "assignment"

Grep using alternative command name:
  jn / "assignment"
"""

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
      echo usage
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

    if key in tmpl.aliases:
      tmpl.process(configuration)
      quit()

    if key in star.aliases:
      star.process(configuration)
      quit()

    if key in rm.aliases:
      rm.process(configuration)
      quit()

    if key in grep.aliases:
      let searchTerm =
        if params.len > 1:
          params[1]
        else:
          ""
      grep.process(searchTerm, configuration)
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
