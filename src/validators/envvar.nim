import std/envvars


proc validateEnvValue*(envValue: string): string =
  if not existsEnv(envValue):
    return "You don't have the " & envValue & " env set. jn may not work without it."
