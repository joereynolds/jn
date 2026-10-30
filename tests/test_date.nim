import std/[os, unittest]
import std/[times]
import ../src/date


suite "Date tests":

  test "It parses 'today' into a date":
    let actual = getRelativeDate("today", parse("2002-02-02", "YYYY-MM-dd"))
    let expected = "2002-02-02"
    check(expected == actual)

  test "It parses 'yesterday' into a date":
    let actual = getRelativeDate("yesterday", parse("2006-04-02", "YYYY-MM-dd"))
    let expected = "2006-04-01"
    check(expected == actual)

  test "It parses 'tomorrow' into a date":
    let actual = getRelativeDate("tomorrow", parse("2001-01-01", "YYYY-MM-dd"))
    let expected = "2001-01-02"
    check(expected == actual)

  test "It parses 'eom' into the end of the month":
    let actual = getRelativeDate("eom", parse("2005-01-01", "YYYY-MM-dd"))
    let expected = "2005-01-31"
    check(expected == actual)
