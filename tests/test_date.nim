import std/[os, unittest]
import std/[times]
import ../src/date


suite "Date tests":

  # Don't love the logic in these tests but I'm not sure if we can mock datetime :(
  test "It parses 'today' into a date":
    let actual = getRelativeDate("today")
    let expected = now().format("YYYY-MM-dd")
    check(expected == actual)

  test "It parses 'yesterday' into a date":
    let actual = getRelativeDate("yesterday")

    let yesterday = now() - 1.days
    let expected = yesterday.format("YYYY-MM-dd")
    check(expected == actual)

  test "It parses 'tomorrow' into a date":
    let actual = getRelativeDate("tomorrow")

    let tomorrow = now() + 1.days
    let expected = tomorrow.format("YYYY-MM-dd")
    check(expected == actual)
