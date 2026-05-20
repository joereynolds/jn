import std/[envvars, os, osproc, strtabs, strutils, times, unittest]

const jnBin = "./jn"

proc makeEnv(overrides: openArray[(string, string)]): StringTableRef =
  result = newStringTable(modeCaseSensitive)
  for key, val in envPairs():
    result[key] = val
  for (key, val) in overrides:
    result[key] = val

suite "Integration tests":
  var tmpDir = ""
  var notesDir = ""
  var configDir = ""

  setup:
    tmpDir = getTempDir() / "jn-integration-test"
    notesDir = tmpDir / "notes"
    configDir = tmpDir / "config"
    createDir(notesDir)
    createDir(configDir / "jn")
    writeFile(configDir / "jn" / "config.ini",
      "notes_location=\"" & notesDir & "\"\n")

    createDir(notesDir / "work")
    createDir(notesDir / "personal")

    for i in 1..16:
      let path = notesDir / "note-" & $i & ".md"
      writeFile(path, "")
      setLastModificationTime(path, fromUnix(1_000_000 + i * 60))

  teardown:
    removeDir(tmpDir)

  test "Calling jn on its own lists all the books":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin, env = env)

    check "work" in output
    check "personal" in output

  test "Calling jn ls lists the contents of notes_location":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " ls", env = env)

    check "note-1.md" in output
    check "note-2.md" in output

  test "Calling jn recent lists the 15 most recent files":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " recent", env = env)

    check output.strip().splitLines().len == 15

  test "Calling jn recent --limit respects the limit":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " recent --limit=5", env = env)

    check output.strip().splitLines().len == 5
