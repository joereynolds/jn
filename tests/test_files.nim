import std/[os, parsecfg, paths, strutils, times, unittest]
import ../src/files
import ../src/config


suite "Files tests":

  test "It gets the full note name for a note":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".md")

    let actual = getFullNotePath("test-note", c)
    let today = now().format("YYYY-MM-dd")
    let expected = Path("/tmp/test-notes/" & today & "-test-note.md")

    check(expected == actual)

  test "It gets the full note name for a note and book":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".md")

    let actual = getFullNotePath("test-note", c, "my-book")
    let today = now().format("YYYY-MM-dd")
    let expected = Path("/tmp/test-notes/my-book/" & today & "-test-note.md")

    check(expected == actual)

  test "The correct prefix is in the fullname":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd-HH")
    c.setSectionKey("", "notes_suffix", ".md")

    let actual = $getFullNotePath("test-note", c)
    let today = now().format("YYYY-MM-dd-HH")
    
    check(actual.contains(today))

  test "The correct suffix is in the fullname":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".markdown")

    let actual = $getFullNotePath("test-note", c)
    
    check(actual.endsWith(".markdown"))

  test "It uses the category path when note name matches category":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".md")
    c.setSectionKey("category:work", "title_contains", "work")
    c.setSectionKey("category:work", "move_to", "work-notes")

    let actual = getFullNotePath("work-meeting", c)
    let today = now().format("YYYY-MM-dd")
    let expected = Path("/tmp/test-notes/work-notes/" & today & "-work-meeting.md")

    check(expected == actual)

  test "It uses the category path when note name matches category with a list of titles":
    var c = newConfig()
    c.setSectionKey("", "notes_location", "/tmp/test-notes/")
    c.setSectionKey("", "notes_prefix", "YYYY-MM-dd")
    c.setSectionKey("", "notes_suffix", ".md")
    c.setSectionKey("category:work", "title_contains", "work,thiswillmatch")
    c.setSectionKey("category:work", "move_to", "work-notes")

    let actual = getFullNotePath("thiswillmatch", c)
    let today = now().format("YYYY-MM-dd")
    let expected = Path("/tmp/test-notes/work-notes/" & today & "-thiswillmatch.md")

    check(expected == actual)
