import std/[parsecfg, strutils, httpclient]
import ../config
import ../fuzzy

const aliases* = @["share"]

proc process*(config: Config, query: string = "") =
  var query = query

  var choice = selectFromDir(
    getNotesPath(config),
    config,
    query
  )

  choice.stripLineEnd()

  if choice == "":
    quit()

  let url = "https://paste.rs"
  let content = readFile(choice)
  let client = newHttpClient()

  try:
    let response = client.postContent(url, body=content)
    echo response
  finally:
    client.close()
