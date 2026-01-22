import std/[os, parsecfg, paths, unittest]
import ../src/config
import ../src/grep


suite "Grep tests":

  test "It finds our search term":
    var c = newConfig()

    let location = Path("./tests/data/notes")
    c.setSectionKey("", "notes_location", $location)

    let expected = @["tests/data/notes/a-file-for-grep.md"]
    let actual = getMatches("search-term", c)

    check(expected == actual)

  test "It finds our search with no case sensitivity":
    var c = newConfig()

    let location = Path("./tests/data/notes")
    c.setSectionKey("", "notes_location", $location)

    let expected = @["tests/data/notes/a-file-for-grep.md"]
    let actual = getMatches("inlowercase", c)

    check(expected == actual)

  test "It finds parts of a term":
    var c = newConfig()

    let location = Path("./tests/data/notes")
    c.setSectionKey("", "notes_location", $location)

    let expected = @["tests/data/notes/a-file-for-grep.md"]

                        # searchterm
    let actual = getMatches("rchter", c)

    check(expected == actual)

  test "It finds things with regex":
    var c = newConfig()

    let location = Path("./tests/data/notes")
    c.setSectionKey("", "notes_location", $location)

    let expected = @["tests/data/notes/a-file-for-grep.md"]

                           # searchterm
    let actual = getMatches("..arc...rm", c)

    check(expected == actual)
