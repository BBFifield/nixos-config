{
  pkgs,
  config,
  lib,
  ...
}: let
  profilesPath = ".mozilla/firefox";
  cfg = config.hm.browsers.firefox;
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
      (mkExtension "dynamic-base16" "dynamic_base16@gnrl_leclerc.org")
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
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "widget.gtk.non-native-titlebar-buttons.enabled" = lib.mkDefault false;
    # Automatically enable extensions
    "extensions.autoDisableScopes" = 0;
    # For vaapi support
    "media.ffmpeg.vaapi.enabled" = true;
    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;
  };
in
  with lib; {
    imports = [./firefox-base16.nix];

    options.hm.browsers.firefox = {
      enable = lib.mkEnableOption "Enable home-manager firefox configuration";
      style = lib.mkOption {
        type = with types; nullOr (enum ["plasma" "gnome" "hyprland"]);
        default = null;
        description = "Choose which settings style to use";
      };
      live = lib.mkOption {
        type = (import ../../../submodules {inherit lib;}).live;
      };
    };

    config = let
      wavefoxSettings = {
        "userChrome.DarkTheme.Tabs.Borders.Saturation.Medium.Enabled" = true;
        "userChrome.DarkTheme.Tabs.Shadows.Saturation.Medium.Enabled" = false;
        "userChrome.DragSpace.Left.Disabled" = true;
        "userChrome.Menu.Icons.Regular.Enabled" = true;
        "userChrome.Menu.Size.Compact.Enabled" = false;
        "userChrome.Tabs.Option5.Enabled" = true;
        "userChrome.Tabs.Option6.Enabled" = false;
        "userChrome.Tabs.Option7.Enabled" = false;
        "userChrome.Tabs.SelectedTabIndicator.Enabled" = false;
        "userChrome.TabSeparators.Saturation.Low.Enabled" = true;
        "userChrome.Tabs.TabsOnBottom.Enabled" = true;
      };
    in
      lib.mkIf cfg.enable (lib.mkMerge [
        {
          home.file."${profilesPath}/default/chrome" = lib.mkMerge [
            {
              recursive = true;
              force = true;
            }
            (lib.mkIf (cfg.style == "plasma" || cfg.style == "hyprland") {
              source = pkgs.nur.repos.slaier.wavefox;
            })
            (lib.mkIf (cfg.style == "gnome") {
              source = pkgs.firefox-gnome-theme;
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
                ExtensionSettings =
                  ExtensionSettings
                  // {
                    "{4e507435-d65f-4467-a2c0-16dbae24f288}" = {
                      install_url = "https://addons.mozilla.org/firefox/downloads/latest/breezedarktheme/latest.xpi";
                      installation_mode =
                        if (cfg.style == "plasma")
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

              profiles = {
                default = {
                  id = 0; # 0 is the default profile; see also option "isDefault"
                  inherit extensions;
                  settings = lib.mkMerge [
                    settings

                    (lib.mkIf (cfg.style == "hyprland") wavefoxSettings)

                    (lib.mkIf (cfg.style == "plasma") (lib.mkMerge [
                      {
                        # Appearance
                        "extensions.activeThemeID" = lib.mkForce "{4e507435-d65f-4467-a2c0-16dbae24f288}"; #breezedarktheme
                      }
                      wavefoxSettings
                    ]))

                    (lib.mkIf (cfg.style == "gnome") {
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
                    default = "DuckDuckGo";
                    order = ["DuckDuckGo" "Google"];
                    engines = (import ./search-engines.nix {inherit pkgs;}).engines;
                  };
                };
              };
            };
          };
        }
      ]);
  }
