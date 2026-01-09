version       = "0.0.1"
author        = "Joe Reynolds"
description   = "jn - A filebased CLI notetaker"
license       = "MIT"
bin           = @["jn"]
srcDir        = "src"

task test, "Run tests duh":
  exec "testament pat tests/category"
