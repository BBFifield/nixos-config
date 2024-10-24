{
  pkgs,
  config,
  lib,
  ...
}: let
  profilesPath = ".mozilla/firefox";

  colorschemes = [
    {
      name = "catppuccin_frappe";
      shortID = "catppuccin-frappe-blue";
      uuid = "{0f28d17a-46f0-4fe1-8696-1676de0a87f2}";
    }
    {
      name = "catppuccin_latte";
      shortID = "catppuccin-latte-blue-git";
      uuid = "{68f3538d-3881-45f4-aa73-288b010b39a1}";
    }
    {
      name = "catppuccin_macchiato";
      shortID = "catppuccin-macchiato-blue";
      uuid = "{d49033ac-8969-488c-afb0-5cdb73957f41}";
    }
    {
      name = "catppuccin_mocha";
      shortID = "catppuccin-mocha-blue-git";
      uuid = "{2adf0361-e6d8-4b74-b3bc-3f450e8ebb69}";
    }
    {
      name = "dracula_standard";
      shortID = "dracula-dark-colorscheme";
      uuid = "{b743f56d-1cc1-4048-8ba6-f9c2ab7aa54d}";
    }
    {
      name = "dracula_alucard";
      shortID = "dracula-dark-colorscheme";
      uuid = "{b743f56d-1cc1-4048-8ba6-f9c2ab7aa54d}";
    }
    {
      name = "gruvbox_dark";
      shortID = "gruvbox-dark-theme";
      uuid = "{eb8c4a94-e603-49ef-8e81-73d3c4cc04ff}";
    }
  ];

  #Profile specific extensions
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    reddit-enhancement-suite
    betterttv
    darkreader
    istilldontcareaboutcookies
    privacy-badger
    unpaywall
    vimium
  ];

  #System-wide extensions. Will probably update to a list to concatenate with ${extensions} if I can figure out a way.
  mkExtension = shortID: uuid: {
    name = uuid;
    value = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${shortID}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  ExtensionSettings =
    builtins.listToAttrs
    [
      (mkExtension "better-youtube-shorts" "{ac34afe8-3a2e-4201-b745-346c0cf6ec7d}")
    ];

  # Couldn't use builtins.toJSON by itself to convert because it would put label before url
  pinnedShortcuts = with builtins; let
    shortcut = url: label:
      concatStringsSep ","
      [
        (lib.strings.removeSuffix "}" (builtins.toJSON {"url" = url;}))
        (lib.strings.removePrefix "{" (builtins.toJSON {"label" = label;}))
      ];
  in
    concatStringsSep ","
    [
      # Each element in the list is the returned string of the function "shortcut",
      # defined in the let block above, when given the url and label in that order.
      (shortcut "https://www.youtube.com/" "Youtube")
      (shortcut "https://github.com/BBFifield" "Github")
      (shortcut "https://mapleleafshotstove.com" "MLHS")
      (shortcut "https://yaleclimateconnections.org/topic/eye-on-the-storm" "YCC")
      (shortcut "https://www.reddit.com/r/leafs/" "/r/leafs")
    ];

  settings = {
    # Functionality
    "general.autoScroll" = true;
    "browser.newtabpage.pinned" = "[${pinnedShortcuts}]";
    # Appearance
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.tabs.inTitlebar" = lib.mkDefault 0;
    "browser.uiCustomization.state" =
      lib.mkDefault ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","addon_darkreader_org-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","unified-extensions-button","ublock0_raymondhill_net-browser-action","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action"],"dirtyAreaCache":["nav-bar","unified-extensions-area","PersonalToolbar","toolbar-menubar","TabsToolbar"],"currentVersion":20,"newElementCount":5}'';
    "extensions.activeThemeID" = lib.mkDefault "default-theme@mozilla.org";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.gtk.non-native-titlebar-buttons.enabled" = lib.mkDefault false;
    # Automatically enable extensions
    "extensions.autoDisableScopes" = 0;
    # For vaapi support
    "media.ffmpeg.vaapi.enabled" = true;
    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;
  };

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
in
  with lib; {
    options.hm.firefox = {
      enable = lib.mkEnableOption "Enable home-manager firefox configuration";
      style = lib.mkOption {
        type = with types; nullOr (enum ["plasma" "gnome"]);
        default = null;
        description = "Choose which settings style to use";
      };
      hotload = lib.mkOption {
        type = (import ../../../submodules {inherit lib;}).hotload;
      };
    };

    config = let
      wavefoxSettings = {
        "userChrome.DarkTheme.Tabs.Borders.Saturation.Medium.Enabled" = true;
        "userChrome.DarkTheme.Tabs.Shadows.Saturation.Medium.Enabled" = false;
        "userChrome.DragSpace.Left.Disabled" = true;
        "userChrome.Menu.Icons.Regular.Enabled" = true;
        "userChrome.Menu.Size.Compact.Enabled" = true;
        "userChrome.Tabs.Option6.Enabled" = false;
        "userChrome.Tabs.Option7.Enabled" = true;
        "userChrome.Tabs.SelectedTabIndicator.Enabled" = true;
        "userChrome.Tabs.TabsOnBottom.Enabled" = true;
      };
    in
      lib.mkIf config.hm.firefox.enable (lib.mkMerge [
        (let
          directory = "${config.home.homeDirectory}/${profilesPath}/test";
          userPrefValue = pref:
            builtins.toJSON (
              if lib.isBool pref || lib.isInt pref || lib.isString pref
              then pref
              else builtins.toJSON pref
            );

          mkUserJs = prefs: ''
            // Generated by Home Manager.

            ${lib.concatStrings (lib.mapAttrsToList (name: value: ''
                user_pref("${name}", ${userPrefValue value});
              '')
              prefs)}
          '';

          mkUserJsFile = name: value: {
            home.file."${profilesPath}/test/userjs/${name}.js".text = let
              prefs = {"extensions.activeThemeID" = value;} // wavefoxSettings;
            in
              mkUserJs prefs;
          };

          userJsFiles = lib.foldl' (acc: item: {home.file = acc.home.file // item.home.file;}) {home.file = {};} (lib.map (colorscheme: mkUserJsFile colorscheme.name colorscheme.uuid) colorschemes);
        in
          lib.mkIf (config.hm.firefox.hotload.enable) (lib.mkMerge [
            {
              hm.hotload.scriptParts = {
                "6" = ''
                  rm "${directory}/user.js"
                  cp -rf "${directory}/userjs/$1.js" "${directory}/user.js"
                '';
              };
            }
            userJsFiles
          ]))
        {
          home.file."${profilesPath}/test/chrome" = lib.mkMerge [
            {
              recursive = true;
              force = true;
            }
            (lib.mkIf (config.hm.firefox.style == "plasma") {
              source = pkgs.nur.repos.slaier.wavefox;
            })
            (lib.mkIf (config.hm.firefox.style == "gnome") {
              source = pkgs.firefox-gnome-theme;
            })
            (lib.mkIf (config.hm.firefox.hotload.enable) {
              source = pkgs.nur.repos.slaier.wavefox;
            })
          ];
          programs = {
            firefox = {
              enable = true;
              policies = {
                # Default download directory
                DefaultDownloadDirectory = "./Downloads";
                DisableAppUpdate = true;
                DisableTelemetry = true;
                DisableFirefoxStudies = true;
                EnableTrackingProtection = {
                  Value = true;
                  Locked = true;
                  Cryptomining = true;
                  Fingerprinting = true;
                };
                DontCheckDefaultBrowser = true;
                SearchBar = "unified";

                /*
                ---- EXTENSIONS ----
                */

                /*
                https://discourse.nixos.org/t/optionalattrs-in-module-infinite-recursion-with-config/27876
                I think mkIf and mkMerge don't work inside ExtensionSettings because it's not part of the module system, but merely
                nix syntax which is converted to json. That's what I gathered from the above discussion.
                */
                ExtensionSettings = let
                  colorschemes' = lib.listToAttrs (lib.map (colorscheme: (mkExtension colorscheme.shortID colorscheme.uuid)) colorschemes);
                in
                  colorschemes'
                  // ExtensionSettings
                  // {
                    "{4e507435-d65f-4467-a2c0-16dbae24f288}" = {
                      install_url = "https://addons.mozilla.org/firefox/downloads/latest/breezedarktheme/latest.xpi";
                      installation_mode =
                        if (config.hm.firefox.style == "plasma")
                        then "normal_installed"
                        else "blocked";
                    };
                  };

                /*
                ---- PREFERENCES ----
                */
                # Set preferences shared by all profiles.
                Preferences = {
                  # Pointless on nix
                  "browser.aboutConfig.showWarning" = false;
                  "browser.contentblocking.category" = {
                    Value = "standard";
                    Status = "locked";
                  };
                  "browser.startup.homepage" = "about:home";
                  # New tab page
                  "browser.newtabpage.activity-stream.default.sites" = "";
                  "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
                  "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
                  "browser.newtabpage.activity-stream.showSponsored" = false;
                  "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                  "browser.newtabpage.activity-stream.system.showSponsored" = false;
                  "browser.newtabpage.activity-stream.telemetry" = false;
                  "browser.newtabpage.activity-stream.topSitesRows" = 2;
                  # File-picker
                  "widget.use-xdg-desktop-portal.file-picker" = 1;
                };
              };

              /*
              package =
              pkgs.wrapFirefox pkgs.firefox-unwrapped {
              };
              */

              profiles = {
                test = {
                  id = 0; # 0 is the default profile; see also option "isDefault"
                  inherit extensions;
                  settings = lib.mkMerge [
                    settings

                    (lib.mkIf (config.hm.hyprland.enable) (lib.mkMerge [
                      {
                        "extensions.activeThemeID" = let
                          name = "${config.hm.theme.colorscheme.name}_${config.hm.theme.colorscheme.variant}";
                          colorscheme = lib.head (lib.filter (colorscheme': colorscheme'.name == name) colorschemes);
                        in
                          lib.mkForce colorscheme.uuid;
                      }
                      wavefoxSettings
                    ]))
                    #// wavefoxSettings)

                    (lib.mkIf (config.hm.firefox.style == "plasma") (lib.mkMerge [
                      {
                        # Appearance
                        "extensions.activeThemeID" = lib.mkForce "{4e507435-d65f-4467-a2c0-16dbae24f288}"; #breezedarktheme
                      }
                      wavefoxSettings
                    ]))

                    (lib.mkIf (config.hm.firefox.style == "gnome") {
                      # Appearance settings
                      "browser.tabs.inTitlebar" = lib.mkForce 1;
                      "browser.uiCustomization.state" =
                        lib.mkForce ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["jid1-mnnxcxisbpnsxq_jetpack-browser-action","ublock0_raymondhill_net-browser-action","_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","addon_darkreader_org-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","idcac-pub_guus_ninja-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","new-tab-button","urlbar-container","downloads-button","unified-extensions-button","fxa-toolbar-menu-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","_ac34afe8-3a2e-4201-b745-346c0cf6ec7d_-browser-action","ublock0_raymondhill_net-browser-action","addon_darkreader_org-browser-action","_f209234a-76f0-4735-9920-eb62507a54cd_-browser-action","idcac-pub_guus_ninja-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action"],"dirtyAreaCache":["nav-bar","unified-extensions-area","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":20,"newElementCount":6}'';
                      "widget.gtk.non-native-titlebar-buttons.enabled" = lib.mkForce true;
                      # Firefox gnome theme settings
                      "gnomeTheme.hideSingleTab" = true;
                      "gnomeTheme.bookmarksToolbarUnderTabs" = true;
                      "gnomeTheme.normalWidthTabs" = false;
                      "gnomeTheme.tabsAsHeaderbar" = false;
                      "svg.context-properties.content.enabled" = true;
                    })
                  ];
                  search = {
                    force = true;
                    default = "Google";
                    order = ["DuckDuckGo" "Google"];
                    inherit engines;
                  };
                };
              };
            };
          };
        }
      ]);
  }
