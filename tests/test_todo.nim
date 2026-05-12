import std/[parsecfg, paths, unittest]
import ../src/[grep, todo]


suite "Todo tests":

  test "It does not return complete todos":
    var c = newConfig()

    let location = Path("./tests/data/todo/complete-todos-only")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[]
    let actual = getTodos(c)

    check(expected == actual)

  test "A todo without a trailing space is ignored":
    var c = newConfig()

    let location = Path("./tests/data/todo/no-trailing-space")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[]
    let actual = getTodos(c)

    check(expected == actual)

  test "Two identical todos are both returned":
    var c = newConfig()

    let location = Path("./tests/data/todo/identical-todos")
    c.setSectionKey("", "notes_location", $location)

    let actual = getTodos(c)

    check(len(actual) == 2)

  test "A todo not at the start of the line is ignored":
    var c = newConfig()

    let location = Path("./tests/data/todo/not-at-the-start")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[]
    let actual = getTodos(c)

    check(expected == actual)

  test "It only brings back incomplete todos":
    var c = newConfig()

    let location = Path("./tests/data/todo/complete-and-incomplete")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[
      Match(
        file: "tests/data/todo/complete-and-incomplete/complete-and-incomplete-todos.md",
        searchTerm: incompleteTodoPattern,
        lineContent: "- [ ] An incomplete todo",
        lineNumber: 1
      )
    ]

    let actual = getTodos(c)

    check(expected == actual)

