import std/[os, paths, unittest]
import ../src/templates


suite "Template tests":

  test "It returns an empty string if the template is non-existent":
    let expected = ""
    let actual = parse(Path("blah"))

    check(expected == actual)

  test "It returns the content of a template if it exists":
    let expected = "This is a test template\n"
    let actual = parse(Path("./tests/data/templates/test-template.md"))

    check(expected == actual)
