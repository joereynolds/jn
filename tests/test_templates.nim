import std/[os, unittest]
import ../src/templates


suite "Template tests":

  test "It gets the template location from env if present":
    putEnv("XDG_DATA_HOME", "my-config")

    let expected = "my-config/jn"
    let actual = getTemplateLocation()

    check(expected == actual)
