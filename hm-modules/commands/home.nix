rec {
  on = "echo 'Morning!'";
  off = "echo 'Night!'";
  args = "echo $@";
  a = args;

  # not implemented :(
  _def = "echo 'Default'";
}
