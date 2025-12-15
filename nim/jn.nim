import std/os
import std/cmdline
import std/dirs
import std/parseopt
import std/terminal
import std/tables

import config

type DirectoryListing = Table[string, int]

const version = "0.1"

proc get_directories(): DirectoryListing =
    var directories = initTable[string, int]()

    for kind, path in walkDir(expandTilde("~/Documents/work/")):
        
        let path_as_key = lastPathPart(path)
        if kind == pcDir:
            directories[path_as_key] = 0

            for other_kind, other_path in walkDir(path):
                if other_kind == pcFile:
                    directories[path_as_key] += 1

    return directories

proc print_directories(directories: DirectoryListing) =
    for directory, fileCount in directories:
        let noteCount = " (" & $fileCount & " notes" & ")"

        stdout.write(directory)
        stdout.styledWriteLine(fgYellow, noteCount)


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
                discard os.execShellCmd("ls")
            of "config":
                let editor = get_editor()
                let location = get_config_location()
                discard os.execShellCmd(editor & " " & location)
            else:
                echo "handle strings here"
    of cmdend: discard

if paramCount() <= 0:
    print_directories(get_directories())
