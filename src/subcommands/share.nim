import std/[cmdline, os, parsecfg, strutils, httpclient]
import ../config
import ../fuzzy

const name = "share"

proc process*(config: Config) =
  var query = commandLineParams()[1..^1].join(" ")

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
