{pkgs}: {
  engines = {
    "Bing".metaData.hidden = true;
    "eBay".metaData.hidden = true;
    "Google".metaData.alias = "@g";
    "Wikipedia (en)".metaData.alias = "@w";

    "GitHub" = {
      urls = [
        {
          template = "https://github.com/search";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.fetchurl {
        url = "https://github.githubassets.com/favicons/favicon-dark.svg";
        sha256 = "1b474jhw71ppqpx9d0znsqinkh1g8pac7cavjilppckgzgsxvvxa";
      }}";
      definedAliases = ["@gh"];
    };

    "Neovim Plugins" = {
      urls = [
        {
          template = "https://dotfyle.com/neovim/plugins/trending";
          params = [
            {
              name = "page";
              value = 1;
            }
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.fetchurl {
        url = " https://dotfyle.com/favicon.ico";
        sha256 = "sha256-8kjAFQ/tGX0JObywRtXF3nXj7Gbra6efbIzKeMrplNA=";
      }}";
      definedAliases = ["@df"];
    };

    "Nix Packages" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@np"];
    };

    "NixOS Wiki" = {
      urls = [
        {
          template = "https://nixos.wiki/index.php";
          params = [
            {
              name = "search";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
      definedAliases = ["@nw"];
    };

    "Home Manager Options" = {
      urls = [
        {
          template = "https://home-manager-options.extranix.com";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
            {
              name = "release";
              value = "master";
            }
          ];
        }
      ];
      icon = "${pkgs.fetchurl {
        url = "https://home-manager-options.extranix.com/images/favicon.png";
        sha256 = "sha256-oFp+eoTLXd0GAK/VrYRUeoXntJDfTu6VnzisEt+bW74=";
      }}";
      definedAliases = ["@hm"];
    };

    "Noogle" = {
      urls = [
        {
          template = "https://noogle.dev/q";
          params = [
            {
              name = "term";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.fetchurl {
        url = "https://cdn-icons-png.freepik.com/256/9941/9941475.png";
        sha256 = "sha256-W+EKDxizCQEKejg+K4NnQmKrDiZVusJYDzQ3WlneVLA=";
      }}";
      definedAliases = ["@ng"];
    };

    "Reddit" = {
      urls = [
        {
          template = "https://www.reddit.com/search";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.fetchurl {
        url = "https://www.redditstatic.com/accountmanager/favicon/favicon-512x512.png";
        sha256 = "0a173np89imayid67vfwi8rxp0r91rdm9cn2jc523mcbgdq96dg3";
      }}";
      definedAliases = ["@r"];
    };

    "Youtube" = {
      urls = [
        {
          template = "https://www.youtube.com/results";
          params = [
            {
              name = "search_query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.fetchurl {
        url = "www.youtube.com/s/desktop/8498231a/img/favicon_144x144.png";
        sha256 = "1wpnxfch3fs1rwbizh7icqff6l4ljqpp660afbxj2n58pin603lm";
      }}";
      definedAliases = ["@y"];
    };
  };
}
