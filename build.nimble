bin = @["jn"]
srcDir = "src"

task test, "Run tests duh":
  exec "testament pat tests/category"
