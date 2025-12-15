import std/os
import std/cmdline
import std/parseopt

import config
import subcommands/cat
import subcommands/config as sconfig
import files


const version = "0.1"

proc get_usage(): string =
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
    return usage




for kind, key, val in getopt():
    case kind
    of cmdShortOption, cmdLongOption:
        case key:
            of "h", "help":
                echo get_usage()
            of "v", "version":
                echo version
    of cmdArgument:
        case key:
            of "cat":
                cat.process()

            of "config":
                sconfig.process()

            else:
                echo "handle strings here"
    of cmdend: discard

if paramCount() <= 0:
    printDirectories(getDirectories(getNotesLocation()))
