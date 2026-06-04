{
  buildNimPackage,
  cacert,
  openssl,
}:
buildNimPackage {
  pname = "jn";
  version = "1.3.1";

  src = ./.;
  buildInputs = [cacert openssl];

  nimFlags = ["-d:ssl" "-d:danger" "--passL:-s" "--mm:arc" "--opt:size"];
}
