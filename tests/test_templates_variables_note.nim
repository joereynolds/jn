import std/[paths, unittest]
import ../src/templates/variables/note


suite "Template variable note tests":

  test "It returns the name of the note":
    let expected = "oh-jeeze.md"
    let actual = note.process(Path("ohman/ohboy/oh-jeeze.md"))

    check(expected == actual)
