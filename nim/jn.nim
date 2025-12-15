import std/os
import std/cmdline
import std/parseopt
import std/strutils
import std/terminal

import config
import subcommands/cat
import subcommands/config as sconfig
import files


const version = "0.1"

const usage="""
jn - a file-based command line notebook

Usage:
  jn [command]

Available Commands:
  book                    Show all books
  @<book>                 Show all notes for a book
  /                       Fuzzy search all notes
  config, -c, --config    Edit the jn config file
  -h, --help              Display this help
  -v, --version           Print jn's version

Examples:
   
    Show all notes for a book called 'docker'
        jn @docker
"""


try:
    config.validate()
except Exception as e:
    stdout.styledWriteLine(fgYellow, e.msg)


for kind, key, val in getopt():
    case kind
    of cmdShortOption, cmdLongOption:
        case key:
            of "h", "help":
                echo usage
            of "v", "version":
                echo version
    of cmdArgument:
        if key == "cat":
            cat.process()
            quit()

        if key == "config":
            sconfig.process()
            quit()

        if key.startsWith("@"):
            echo "Book stuff"

        else:
            files.createNote(key)
    of cmdend: discard

if paramCount() <= 0:
    printDirectories(getDirectories(getNotesLocation()))
