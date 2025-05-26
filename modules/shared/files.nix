{ pkgs, config, ... }:

let
 githubPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2x10Do7eeY6qTKvbp6ws2ZQrw5tXIIPXMvQztjdQ8v edoardo@edoardos-macbook-pro";
 githubPublicSigningKey = ''
   -----BEGIN PGP PUBLIC KEY BLOCK-----

   mDMEaDQINxYJKwYBBAHaRw8BAQdA0Ohf1XFJB8p241OiHh5MjSIrjcpQIy/wKqgx
   n+e2D8K0NUVkb2FyZG8gRGViZW5lZGV0dGkgPGVkb2FyZG8ubS5kZWJlbmVkZXR0
   aUBnbWFpbC5jb20+iJMEExYKADsWIQQHmmVzHru8KrunGKdTGy/XOhTtkgUCaDQI
   NwIbAwULCQgHAgIiAgYVCgkICwIEFgIDAQIeBwIXgAAKCRBTGy/XOhTtknvoAPwJ
   2rHUMFiGp6HROeKPLoZs3ekJVpOoDMJ9stlEbXaruwD/dUWjvrvlR1QV8JfHQUKa
   7la0LAeOr6OgX1Uhjjt/3QK4OARoNAg3EgorBgEEAZdVAQUBAQdA7hDZDMOyqSs/
   zDVZIAt6GMZTsAam2CAj9LoT6LNu3lwDAQgHiHgEGBYKACAWIQQHmmVzHru8Krun
   GKdTGy/XOhTtkgUCaDQINwIbDAAKCRBTGy/XOhTtkjxIAQCXtaHxdSS7NyBCmZ8N
   OYb8+LOnm3i2wR5Xvi+PYKvjRQEA7Jsg9tt5Azhh4941sj94V9MNXyNiUZ3uj+Z0
   RC6d5ws=
   =ojr9
   -----END PGP PUBLIC KEY BLOCK-----

'';
in
{
  ".ssh/id_github.pub" = {
    text = githubPublicKey;
  };
  ".ssh/pgp_github.pub" = {
      text = githubPublicSigningKey;
  };
}
