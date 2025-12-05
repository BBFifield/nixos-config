{
  pkgs,
  config,
  lib,
  ...
}: let
  profilesPath = ".mozilla/firefox";
  cfg = config.hm.browsers.firefox;

  #Profile specific extensions
  extensions = {
    force = true;
    packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      reddit-enhancement-suite
      betterttv
      darkreader
      istilldontcareaboutcookies
      privacy-badger
      unpaywall
      vimium
      # tridactyl
    ];

    # Will need to wait for this to be implemented: https://github.com/nix-community/home-manager/issues/8094
    # settings = {
    #   "{d7742d87-e61d-4b78-b8a1-b469842139fa}".settings = {
    #     searchEngine = let
    #       seAttrs = import ../searchEngines.nix {inherit pkgs;};
    #
    #       seComposedList = builtins.attrValues (builtins.mapAttrs (name: value: let
    #         engineName = name;
    #         url = builtins.head value.urls;
    #         alias = lib.removePrefix "@" (builtins.head value.definedAliases);
    #       in
    #         lib.foldr (nextParam: accu: let
    #           nextParamVal =
    #             if (nextParam.value == "{searchTerms}")
    #             then "%s"
    #             else nextParam.value;
    #         in
    #           accu + "?" + nextParam.name + "=" + nextParamVal + " ${engineName}") "${alias}: ${url.template}"
    #         url.params)
    #       seAttrs.custom);
    #
    #       searchEngines = lib.concatStringsSep "\n" seComposedList;
    #     in
    #       "g: https://www.google.com/search?q=%s Google\n" + searchEngines;
    #   };
    # };
  };

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

  pinnedShortcuts = builtins.concatStringsSep "," (map (i: ''{"url": "${i.url}", "label": "${i.label}"}'') config.hm.browsers.firefox.pinnedShortcuts);

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
    "media.hardware-video-decoding.force-enabled" = true; #https://github.com/elFarto/nvidia-vaapi-driver#firefox #nvidia-smi pmon
    # "gfx.x11-egl.force-enabled" = true; #not required cuz we use wayland
    # "widget.dmabuf.force-enabled" = true; #only required on 470 series drivers
  };
in
  with lib; {
    imports = [./dynamic-base16 ./theme];

    options.hm.browsers.firefox = {
      enable = lib.mkEnableOption "Enable home-manager firefox configuration";
      pinnedShortcuts = lib.mkOption {
        type = with types;
          listOf (submodule {
            options.url = lib.mkOption {
              type = types.str;
              description = "Target URL";
            };
            options.label = lib.mkOption {
              type = types.str;
              description = "Label shown in UI";
            };
          });
        default = [];
        description = ''A list of attrs each consisting of a url and label pair.'';
      };
    };

    config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [ffmpeg]; #for hardware acceleration apparently
      programs = {
        firefox = {
          enable = true;
          policies = {
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

            inherit ExtensionSettings;
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
              inherit extensions settings;
              search = {
                force = true;
                default = "ddg";
                order = ["ddg" "google"];
                engines = let
                  searchEngines = import ../searchEngines.nix {inherit pkgs;};
                in
                  lib.mkMerge [searchEngines.predefined searchEngines.custom];
              };
            };
          };
        };
      };
    };
  }
