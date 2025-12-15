import std/os
import std/cmdline
import std/dirs
import std/osproc
import std/parseopt
import std/terminal
import std/tables
import std/strutils
import std/syncio

import config

type DirectoryListing = Table[string, int]

const version = "0.1"

proc getDirectories(notesDir: string): DirectoryListing =
    var directories = initTable[string, int]()

    for kind, path in walkDir(expandTilde(notesDir)):
        
        let path_as_key = lastPathPart(path)
        if kind == pcDir and not isHidden(path):
            directories[path_as_key] = 0

            for other_kind, other_path in walkDir(path):
                if other_kind == pcFile:
                    directories[path_as_key] += 1

    return directories

proc getNotes(notesDir: string): seq[string] =
    var notes = @[""]

    for note in walkDirRec(expandTilde(notesDir)):
        notes.add(note)
    return notes


proc printDirectories(directories: DirectoryListing) =
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
                let notes = getNotes(getNotesLocation())
                let fuzzy = getFuzzyProvider()
                var choice = execProcess("echo '" & notes.join("\n") & "' | " & fuzzy)
                choice.stripLineEnd()
                let content = readFile(choice)
                echo content

            of "config":
                discard os.execShellCmd(getEditor() & " " & getConfigLocation())
            else:
                echo "handle strings here"
    of cmdend: discard

if paramCount() <= 0:
    printDirectories(getDirectories(getNotesLocation()))
