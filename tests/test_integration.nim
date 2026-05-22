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
    let (output, _) = execCmdEx(jnBin & " ls --recent 15", env = env)

    check output.strip().splitLines().len == 15

  test "Calling jn recent --limit respects the limit":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " ls --recent 5", env = env)

    check output.strip().splitLines().len == 5

suite "Integration tests - date filtering":
  var tmpDir = ""
  var notesDir = ""
  var configDir = ""

  setup:
    tmpDir = getTempDir() / "jn-date-filter-test"
    notesDir = tmpDir / "notes"
    configDir = tmpDir / "config"
    createDir(notesDir)
    createDir(configDir / "jn")
    writeFile(configDir / "jn" / "config.ini",
      "notes_location=\"" & notesDir & "\"\n")

    let earlyPath = notesDir / "early.md"
    writeFile(earlyPath, "")
    setLastModificationTime(earlyPath, fromUnix(777_600))    # 1970-01-10

    let latePath = notesDir / "late.md"
    writeFile(latePath, "")
    setLastModificationTime(latePath, fromUnix(1_209_600))   # 1970-01-15

  teardown:
    removeDir(tmpDir)

  test "jn ls --after excludes notes older than the given date":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " ls --after 1970-01-12", env = env)

    check "late.md" in output
    check "early.md" notin output

  test "jn ls --before excludes notes newer than the given date":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " ls --before 1970-01-12", env = env)

    check "early.md" in output
    check "late.md" notin output

  test "jn ls --after is inclusive of the boundary date":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " ls --after 1970-01-10", env = env)

    check "early.md" in output

  test "jn ls --before is inclusive of the boundary date":
    let env = makeEnv([("XDG_CONFIG_HOME", configDir), ("EDITOR", "true")])
    let (output, _) = execCmdEx(jnBin & " ls --before 1970-01-15", env = env)

    check "late.md" in output
