{
  buildNimPackage,
  cacert,
  openssl,
}:
buildNimPackage {
  pname = "jn";
  version = "1.2.0";

  src = ./.;
  buildInputs = [cacert openssl];

  nimFlags = ["-d:ssl" "-d:danger" "--passL:-s" "--mm:arc" "--opt:size"];
}
