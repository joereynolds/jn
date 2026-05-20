import std/os
import std/cmdline
import std/parseopt
import std/strutils

import cligen

import config
import subcommands/[
  book, cat, config as sconfig, edit,
  grep, help, ls, mv, recent, rm,
  share, star, tags, todo, tmpl
]
import files
import console

clCfg.version = "1.2.0"


let configuration = getConfig(getConfigLocation())

createNecessaryDirectories(configuration)


proc catProxy(query: seq[string] = @[]) = cat.process(configuration, query.join(" "))
proc configProxy() = sconfig.process(configuration)
proc editProxy(query: seq[string] = @[]) = edit.process(configuration, query.join(" "))
proc grepProxy(query: seq[string] = @[]) = grep.process(configuration, query.join(" "))
proc lsProxy() = ls.process(configuration)
proc mvProxy(query: seq[string] = @[], plain: bool = false) = mv.process(configuration, query.join(" "), plain)
proc recentProxy(limit: int = 15) = recent.process(configuration, limit)
proc rmProxy(query: seq[string] = @[]) = rm.process(configuration, query.join(" "))
proc shareProxy() = share.process(configuration)
proc starProxy() = star.process(configuration)
proc todoProxy(add: seq[string] = @[]) = todo.process(configuration, add.join(" "))

dispatchMulti(
  [catProxy, cmdName = "cat", positional = "query", doc="help goes here"],
  [configProxy, cmdName = "config", doc="help goes here"],
  [editProxy, cmdName = "edit", positional = "query", doc="help goes here"],
  [grepProxy, cmdName = "grep", positional = "query", doc="help goes here"],
  [lsProxy, cmdName = "ls", doc="help goes here"],
  [mvProxy, cmdName = "mv", positional = "query", doc="help goes here"],
  [recentProxy, cmdName = "recent", doc="help goes here"],
  [rmProxy, cmdName = "rm", positional = "query", doc="help goes here"],
  [shareProxy, cmdName = "share", doc="help goes here"],
  [starProxy, cmdName = "star", doc="help goes here"],
  [todoProxy, cmdName = "todo", doc="help goes here"],
)

#
# try:
#   let validationResults = config.validate(configuration)
#   for item in validationResults: echo item
# except Exception as e:
#   info(e.msg)
#
# let params = commandLineParams()
#
# for kind, key, val in getopt():
#   case kind
#   of cmdArgument:
#
#     if key in tmpl.aliases:
#       tmpl.process(configuration)
#       quit()
#
#     if key in tags.aliases:
#       let searchTerm =
#         if params.len > 1:
#           params[1]
#         else:
#           ""
#       tags.process(searchTerm, configuration)
#       quit()
#
#     if key.startsWith("@"):
#       book.process(params, configuration)
#       quit()
#     else:
#       # Check if there's a book parameter (starts with @) in the params
#       var bookName = ""
#       for param in params:
#         if param.startsWith("@"):
#           bookName = param[1..^1]  # Remove the @ prefix
#           break
#
#       files.createNote(key, configuration, bookName)
#   of cmdend:
#     discard
#
# if paramCount() <= 0:
#   info(configuration.getNotesPath())
#   printDirectories(getDirectories(getNotesPath(configuration)))
