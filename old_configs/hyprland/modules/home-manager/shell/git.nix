{ config, ... }:

{
  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
    userName = "m-wilpert";
    userEmail = "mika.wilpert@gmail.com";
  };
}
