import std/[os, parsecfg, strutils, times, unittest]
import ../src/files
import ../src/config


suite "Files tests":

  test "It gets the full note name for a note":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".md")

    let actual = getFullNoteName("test-note", c)
    let today = now().format("YYYY-MM-dd")
    let expected = "/tmp/test-notes/" & today & "-test-note.md"

    check(expected == actual)

  test "It gets the full note name for a note and book":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".md")

    let actual = getFullNoteName("test-note", c, "my-book")
    let today = now().format("YYYY-MM-dd")
    let expected = "/tmp/test-notes/my-book/" & today & "-test-note.md"

    check(expected == actual)

  test "The correct prefix is in the fullname":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd-HH")
    c.setSectionKey("", "notes_suffix", ".md")

    let actual = getFullNoteName("test-note", c)
    let today = now().format("YYYY-MM-dd-HH")
    
    check(actual.contains(today))

  test "The correct suffix is in the fullname":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".markdown")

    let actual = getFullNoteName("test-note", c)
    
    check(actual.endsWith(".markdown"))
