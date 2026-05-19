version = "1.1.2"

author        = "Joe Reynolds"
description   = "jn - A filebased CLI notetaker"
license       = "MIT"
bin           = @["jn"]
srcDir        = "src"

requires "nim >= 2.0.0"
requires "cligen >= 1.0.0"

task release, "Builds the project for production":
  exec "nimble build -d:ssl -d:danger --passL:-s --mm:arc --opt:size"
