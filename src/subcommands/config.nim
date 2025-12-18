import std/os
import ../config


proc process*() = 
    discard os.execShellCmd(getEditor() & " " & getConfigLocation())
