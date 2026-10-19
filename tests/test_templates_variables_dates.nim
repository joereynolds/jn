import std/[paths, times, unittest]
import ../src/templates/variables/[today, tomorrow, yesterday]


suite "Template variable date tests":

  # TODO
  # For all of these date functions we should be able to pass in a date
  # rather than it rely on now()
  # this will make testing easier and probably give more functionality too
  test "It returns today's date formatted as YYYY-MM-dd":
    let expected = now().format("YYYY-MM-dd")
    let actual = today.process(Path("does-not-matter"))
    check(expected == actual)

  test "It returns yesterday's date formatted as YYYY-MM-dd":
    let yday = now() - 1.days
    let expected = yday.format("YYYY-MM-dd")
    let actual = yesterday.process(Path("does-not-matter"))
    check(expected == actual)

  test "It returns tomorrows's date formatted as YYYY-MM-dd":
    let tmrw = now() + 1.days
    let expected = tmrw.format("YYYY-MM-dd")
    let actual = tomorrow.process(Path("does-not-matter"))
    check(expected == actual)
