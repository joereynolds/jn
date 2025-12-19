import std/[os, parsecfg, unittest]
import ../../src/config




suite "Config tests":

  test "It gets the config location from env if present":
    putEnv("XDG_CONFIG_HOME", "my-config")

    let expected = "my-config/jn/config.ini"
    let actual = getConfigLocation()

    check(expected == actual)

  test "It gets the editor from the env if present":
    putEnv("EDITOR", "jim")

    let expected = "jim"
    let actual = getEditor()

    check(expected == actual)

  test "It has a fallback editor if no env value for editor present":
    delEnv("EDITOR")

    let expected = "vi"
    let actual = getEditor()

    check(expected == actual)

  test "It gets note locations from the config":
    var c = newConfig()

    c.setSectionKey("", "notes_location", "this/is/my/dir/")

    let expected = "this/is/my/dir/"
    let actual = getNotesLocation(c)

    check(expected == actual)

  test "It adds trailing slashes to note locations if not present":
    var c = newConfig()

    c.setSectionKey("", "notes_location", "this/directory")

    let expected = "this/directory/"
    let actual = getNotesLocation(c)

    check(expected == actual)
