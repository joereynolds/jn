import std/os
import std/parsecfg
import ../config

const aliases* = @["conf", "config"]

proc process*(config: Config) =
  discard os.execShellCmd(getEditor() & " " & getConfigLocation())
