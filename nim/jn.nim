import std/terminal
import std/tables

proc get_directories(): Table[string, int] =
    return {
        "root": 43,
        "rambles": 4,
        "random": 8
    }.toTable

proc print_directories(directories: Table[string, int]) =
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
  [Tab]                   Fuzzy search all notes
  config, -c, --config    Edit the jn config file
  help, -h, --help        Display this help
  version, -v, --version  Print jn's version

Examples:
   
    Show all notes for a book called 'docker'
        jn @docker
    """
    return usage

echo get_usage()
print_directories(get_directories())
