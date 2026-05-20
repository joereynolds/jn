import std/parsecfg
import ../config

let editor = getEditor()
let usage* =
  """
jn - a file-based command line notebook

Usage:
  jn [command]

Available Commands:
  @<book>              Show all notes for a book
  c,cat                Fuzzy search and print note
  conf,config          Open config in $EDITOR (""" & editor & ")" & """

  e,edit               Fuzzy search and open note in $EDITOR (""" & editor & ")" & """

  /,grep,rg            Grep for term and fuzzy search to edit
  ls                   List all notes in your notes directory
  mv                   Fuzzy search and rename note
  r,re,recent          Displays the 15 most recent files
  rm                   Fuzzy search and delete note
  share                Share a note online. A permalink is given back (uses paste.rs, be respectful!)
  star                 Mark a note as "starred"
  tags                 Search for notes by tag (e.g. #vim)
  template,temp,tm     Fuzzy search and edit template files
  t,todo               Fuzzy search all incomplete tasks and complete them

  h, help, -h, --help  Display this help
  --version            Print jn's version

  jn [command] --help  Display help for a specific command

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
"""

proc process*(config: Config) =
  echo usage
