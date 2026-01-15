import std/[parsecfg, paths, unittest]
import ../src/categories


suite "Category tests":

  test "It returns all of our categories":
    var c = newConfig()

    c.setSectionKey("category.test-1", "title_contains", "gym")
    c.setSectionKey("category.test-1", "move_to", "exercise")

    let section = Category(
        configKey: "category.test-1",
        titleContains: "gym",
        moveto: Path("exercise")
    )

    let expected: seq[Category] = @[section]
    let actual = getCategories(c)

    check(expected == actual)

  test "It returns nothing if sections don't start with category":
    var c = newConfig()

    c.setSectionKey("invalid.test-1", "title_contains", "gym")

    let expected: seq[Category] = @[]
    let actual = getCategories(c)

    check(expected == actual)
