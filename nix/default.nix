{
  buildNimPackage,
  cacert,
  openssl,
}:
buildNimPackage {
  pname = "jn";
  version = "1.5.0";

  src = ../.;
  lockFile = ./lock.json;
  buildInputs = [cacert openssl];

  nimFlags = ["-d:ssl" "-d:danger" "--passL:-s" "--mm:arc" "--opt:size"];
}
