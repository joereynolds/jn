import std/[options, os, parsecfg, paths, strutils, unittest]
import ../src/[grep, todo]
import ../src/subcommands/todo


suite "Todo tests":

  setup:
    let todoTestFile = Path("./tests/data/todo/all-states") / Path("todo.md")
    if fileExists($todoTestFile):
      removeFile($todoTestFile)

  test "It does not return complete todos":
    var c = newConfig()

    let location = Path("./tests/data/todo/complete-todos-only")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[]
    let actual = getTodos(c, TaskState.Todo)

    check(expected == actual)

  test "A todo without a trailing space is ignored":
    var c = newConfig()

    let location = Path("./tests/data/todo/no-trailing-space")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[]
    let actual = getTodos(c, TaskState.Todo)

    check(expected == actual)

  test "Two identical todos are both returned":
    var c = newConfig()

    let location = Path("./tests/data/todo/identical-todos")
    c.setSectionKey("", "notes_location", $location)

    let actual = getTodos(c, TaskState.Todo)

    check(len(actual) == 2)

  test "A todo not at the start of the line is ignored":
    var c = newConfig()

    let location = Path("./tests/data/todo/not-at-the-start")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[]
    let actual = getTodos(c, TaskState.Todo)

    check(expected == actual)

  test "It only brings back incomplete todos":
    var c = newConfig()

    let location = Path("./tests/data/todo/complete-and-incomplete")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[
      Match(
        file: "tests/data/todo/complete-and-incomplete/complete-and-incomplete-todos.md",
        searchTerm: "^- \\[ \\] ",
        lineContent: "- [ ] An incomplete todo",
        lineNumber: 1
      )
    ]

    let actual = getTodos(c, TaskState.Todo)

    check(expected == actual)

  test "It returns done todos":
    var c = newConfig()

    let location = Path("./tests/data/todo/done-todos")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[
      Match(
        file: "tests/data/todo/done-todos/done-todos.md",
        searchTerm: "^- \\[x\\] ",
        lineContent: "- [x] A done todo",
        lineNumber: 0
      )
    ]

    let actual = getTodos(c, TaskState.Done)

    check(expected == actual)

  test "It returns wip todos":
    var c = newConfig()

    let location = Path("./tests/data/todo/wip-todos")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[
      Match(
        file: "tests/data/todo/wip-todos/wip-todos.md",
        searchTerm: "^- \\[/\\] ",
        lineContent: "- [/] A wip todo",
        lineNumber: 0
      )
    ]

    let actual = getTodos(c, TaskState.Wip)

    check(expected == actual)

  test "It returns cancelled todos":
    var c = newConfig()

    let location = Path("./tests/data/todo/cancelled-todos")
    c.setSectionKey("", "notes_location", $location)

    let expected: seq[Match] = @[
      Match(
        file: "tests/data/todo/cancelled-todos/cancelled-todos.md",
        searchTerm: "^- \\[-\\] ",
        lineContent: "- [-] A cancelled todo",
        lineNumber: 0
      )
    ]

    let actual = getTodos(c, TaskState.Cancelled)

    check(expected == actual)

  test "It only returns the requested state from a mixed file":
    var c = newConfig()

    let location = Path("./tests/data/todo/all-states")
    c.setSectionKey("", "notes_location", $location)

    let actual = getTodos(c, TaskState.Wip)

    check(len(actual) == 1)
    check(actual[0].lineContent == "- [/] A wip task")

  test "It adds todos with a task (--add) specified":
    var c = newConfig()

    let location = Path("./tests/data/todo/all-states")
    let todoFile = location / Path("todo.md")
    c.setSectionKey("", "notes_location", $location)

    let taskString = "It's a damn fine day to be nude"
    process(c, taskString, none(TaskState))
    let actual = readFile($todoFile)
    check(taskString in actual)
