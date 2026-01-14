import std/[os, paths, parsecfg, unittest]
import ../src/templates


suite "Template tests":

  test "It returns an empty string if the template is non-existent":
    let expected = ""
    let actual = getContent(Path("blah"))

    check(expected == actual)

  test "It returns the content of a template if it exists":
    let expected = "This is a test template\n"
    let actual = getContent(Path("./tests/data/templates/test-template.md"))

    check(expected == actual)

  test "It uses template_location from config if present":
    var config = newConfig()
    config.setSectionKey("", "template_location", "/custom/template/path")
    
    let expected = Path("/custom/template/path")
    let actual = getTemplateLocation(config)
    
    check(expected == actual)

  test "It falls back to default location if template_location not in config":
    let config = newConfig()
    
    let expected = Path(getDataDir() / "jn")
    let actual = getTemplateLocation(config)
    
    check(expected == actual)

