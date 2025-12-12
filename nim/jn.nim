import std/parseopt
import std/terminal
import std/tables
import config

type DirectoryListing = Table[string, int]

proc get_directories(): DirectoryListing =
    return {
        "root": 43,
        "rambles": 4,
        "random": 8
    }.toTable

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
  [Tab]                   Fuzzy search all notes
  config, -c, --config    Edit the jn config file
  help, -h, --help        Display this help
  version, -v, --version  Print jn's version

Examples:
   
    Show all notes for a book called 'docker'
        jn @docker
    """
    return usage



# print_directories(get_directories())
# echo get_config_dir()


for kind, key, val in getopt():
    case kind
    of cmdend: discard
    of cmdShortOption, cmdLongOption:
        case key:
            of "h", "help":
                echo get_usage()
            of "v", "version":
                echo "0.1"
    of cmdArgument:
        discard
