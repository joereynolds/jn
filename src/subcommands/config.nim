import std/os
import std/parsecfg
import ../config

const name = "config"

proc process*(config: Config) =
  discard os.execShellCmd(getEditor() & " " & getConfigLocation())
