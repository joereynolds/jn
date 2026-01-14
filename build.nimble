version = "0.2"

author        = "Joe Reynolds"
description   = "jn - A filebased CLI notetaker"
license       = "MIT"
bin           = @["jn"]
srcDir        = "src"

task release, "Builds the project for production":
  exec "nimble build -d:release --opt:speed"
