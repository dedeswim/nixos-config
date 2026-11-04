{ secrets, user, ... }:

{
  age.identityPaths = [
    "/Users/${user}/.ssh/id_ed25519"
  ];

  age.secrets."github-signing-key" = {
    symlink = false;
    path = "/Users/${user}/.ssh/pgp_github.key";
    file = "${secrets}/github-signing-key.age";
    mode = "600";
    owner = user;
  };
}
