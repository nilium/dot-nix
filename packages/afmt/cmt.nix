self: {
  pkgs,
  name ? "cmt",
  widths ? [72 80 100 120],
  ...
}: let
  afmt = "${self.packages.${pkgs.system}.afmt}/bin/afmt";
  cmtWithWidth = width: let
    width' = toString width;
    goal = toString (width - 2);
  in
    pkgs.writeShellApplication {
      name = "${name}${width'}";
      text = ''exec ${afmt} -w${width'} -g${goal} "''$@"'';
    };
in
  map cmtWithWidth widths
