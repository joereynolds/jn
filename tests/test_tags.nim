import std/[os, parsecfg, strutils, unittest]
import ../src/subcommands/tags


suite "Tags tests":

  test "Tags aliases include 'tag' and 'tags'":
    check("tag" in tags.aliases)
    check("tags" in tags.aliases)
