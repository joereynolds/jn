import std/[paths, times, unittest]
import ../src/templates/variables/today


suite "Template variable today tests":

  test "It returns today's date formatted as YYYY-MM-dd":
    let expected = now().format("YYYY-MM-dd")
    let actual = today.process(Path("does-not-matter"))
    check(expected == actual)
