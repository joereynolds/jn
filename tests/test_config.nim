import std/[os, parsecfg, paths, unittest, sequtils]
import ../src/config
from ../src/templates import Template


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

  test "It uses fzf as the default fuzzy provider":
    let c = newConfig()
    let expected = "fzf"
    let actual = getFuzzyProvider(c)

    check(expected == actual)

  test "It uses the specified fuzzy provider if set":
    var c = newConfig()
    c.setSectionKey("", "fuzzy_provider", "test-fuzzy")
    let expected = "test-fuzzy"
    let actual = getFuzzyProvider(c)

    check(expected == actual)

  test "It gets note locations from the config":
    var c = newConfig()

    c.setSectionKey("", "notes_location", "this/is/my/dir/")

    let expected = "this/is/my/dir/"
    let actual = getNotesPath(c)

    check(expected == actual)

  test "It gets the note prefix from the config":
    var c = newConfig()

    c.setSectionKey("", "notes_prefix", "does-not-matter")

    let expected = "does-not-matter"
    let actual = getNotesPrefix(c)

    check(expected == actual)

  test "It falls back to YYYY-MM-dd if notes_prefix not set":
    var c = newConfig()

    let expected = "YYYY-MM-dd"
    let actual = getNotesPrefix(c)

    check(expected == actual)

  test "It gets the note suffix from the config":
    var c = newConfig()

    c.setSectionKey("", "notes_suffix", ".markdown")

    let expected = ".markdown"
    let actual = getNotesSuffix(c)

    check(expected == actual)

  test "It falls back to XDG_DOCUMENTS_DIR if note location not specified in config":
    putEnv("XDG_DOCUMENTS_DIR", "my-test-documents-dir")
    var c = newConfig()

    let expected = "my-test-documents-dir/jn/"
    let actual = getNotesPath(c)

    check(expected == actual)

  test "It adds trailing slashes to note locations if not present":
    var c = newConfig()

    c.setSectionKey("", "notes_location", "this/directory")

    let expected = "this/directory/"
    let actual = getNotesPath(c)

    check(expected == actual)

  test "It brings back validation errors if the prefix is an invalid value":
    delEnv("XDG_DOCUMENTS_DIR")

    var c = newConfig()

    c.setSectionKey("", "notes_location", "/home")
    c.setSectionKey("", "notes_prefix", "will-error")

    let expected = "The notes_prefix of will-error in your config is an invalid date format"
    let actual: seq[string] = validate(c)

    check(expected in actual)

  test "It brings back validation errors if the notes_location doesn't exist":
    var c = newConfig()

    c.setSectionKey("", "notes_location", "a/non/existent/path")

    let expected = "The notes_location of a/non/existent/path/ in your config does not exist"
    let actual: seq[string] = validate(c)

    check(expected in actual)
