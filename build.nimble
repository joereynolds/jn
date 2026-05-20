version = "1.2.0"

author        = "Joe Reynolds"
description   = "jn - A filebased CLI notetaker"
license       = "MIT"
bin           = @["jn"]
srcDir        = "src"

task release, "Builds the project for production":
  exec "nimble build -d:ssl -d:danger --passL:-s --mm:arc --opt:size"
