import std/os
import std/cmdline
import std/parseopt
import std/strutils
import std/terminal

import config
import subcommands/[book, cat, config as sconfig, edit, grep, star]
import files


const version = "0.1"

const usage = """
jn - a file-based command line notebook

Usage:
  jn [command]

Available Commands:
  book                    Show all books
  @<book>                 Show all notes for a book
  c,cat                   Fuzzy search and print note
  conf,config             Open config in $EDITOR
  e,edit                  Fuzzy search and open note in $EDITOR
  /,grep,rg               Grep for term and fuzzy search to edit
  s,star                  Mark a note as "starred"
  -h, --help              Display this help
  -v, --version           Print jn's version

Examples:
   
Show all notes for a book called 'docker':
  jn @docker

Grep for a term:
  jn grep "assignment"

Greo using alternative command name:
  jn / "assignment"
"""


try:
    config.validate()
except Exception as e:
    stdout.styledWriteLine(fgYellow, e.msg)


let params = commandLineParams()

for kind, key, val in getopt():
    case kind
    of cmdShortOption, cmdLongOption:
        case key:
            of "h", "help":
                echo usage
            of "v", "version":
                echo version
    of cmdArgument:
        if key in ["c", "cat"]:
            cat.process()
            quit()

        if key in ["conf", "config"]:
            sconfig.process()
            quit()

        if key in ["e", "edit"]:
            edit.process()
            quit()

        if key in ["s", "star"]:
            star.process()
            quit()

        # TODO - Read grep program from config and inject as key here
        if key in ["/", "grep", "rg"]:
            let searchTerm = if params.len > 1: params[1] else: ""
            grep.process(searchTerm)
            quit()

        if key.startsWith("@"):
            book.process(params)
            quit()

        else:
            files.createNote(key)
    of cmdend: discard

if paramCount() <= 0:
    printDirectories(getDirectories(getNotesLocation()))
