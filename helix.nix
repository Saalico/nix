{ lib, pkgs, config, inputs, ... }: {
  programs = {
    helix = {
      enable = true;

      languages = {
        language-server = { roc-ls = { command = "roc_language_server"; }; };
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
          }
          {
            name = "roc";
            language-servers = [ "roc-ls" ];
            scope = "source.roc";
            injection-regex = "roc";
            file-types = [ "roc" ];
            shebangs = [ "roc" ];
            roots = [ ];
            comment-token = "#";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            auto-format = true;
            formatter = {
              command = "roc";
              args = [ "format" "--stdin" "--stdout" ];
            };
          }
        ];
        grammar = [{
          name = "roc";
          source = {
            git = "https://github.com/faldor20/tree-sitter-roc.git";
            rev = "master";
          };

        }];
      };
      settings = {
        editor = {
          middle-click-paste = true;
          line-number = "relative";
          auto-format = true;
          auto-completion = true;
        };
      };
    };
  };
}
