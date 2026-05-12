import std/[os, unittest]
import ../src/validators/envvar
import ../src/validators/location
import ../src/validators/prefix


suite "Validator tests":

  test "validateEnvValue returns empty string if the env var exists":
    putEnv("JN_TEST_VAR", "test-value")
    let actual = validateEnvValue("JN_TEST_VAR")
    check(actual == "")

  test "validateEnvValue returns an error if the env var is not set":
    delEnv("JN_TEST_NON_EXISTENT")
    let expected = "You don't have the JN_TEST_NON_EXISTENT env set. jn may not work without it."
    let actual = validateEnvValue("JN_TEST_NON_EXISTENT")
    check(expected == actual)

  test "validateLocation returns empty string if the directory exists":
    let actual = validateLocation("/tmp")
    check(actual == "")

  test "validateLocation returns an error if the directory does not exist":
    let expected = "The notes_location of /does/not/exist in your config does not exist"
    let actual = validateLocation("/does/not/exist")
    check(expected == actual)

  test "validatePrefix returns empty string for a valid prefix":
    let actual = validatePrefix("YYYY-MM-dd")
    check(actual == "")

  test "validatePrefix returns an error for an invalid prefix":
    let expected = "The notes_prefix of will-error in your config is an invalid date format"
    let actual = validatePrefix("will-error")
    check(expected == actual)
