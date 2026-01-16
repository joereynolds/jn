import std/parsecfg

const aliases* = @["h", "help"]

const usage* =
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

proc process*(config: Config) =
  echo usage
