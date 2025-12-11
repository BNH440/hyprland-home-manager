{ inputs, config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "blakeh";
  home.homeDirectory = "/home/b/bl/blakeh";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    hyprshot
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    #".ssh".source = "${toString config.home.homeDirectory}/remote/.ssh";
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jaysa/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.

  #systemwide dark mode, including firefox
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };


  gtk.font.size = 32;

  programs = {
    firefox = {
      enable = true;
      policies = {
        # got this from https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
        DisableTelemetry = true;
	DisableFirefoxStudies = true;
	EnableTrackingProtection = {
	  Value = true;
	  Locked = true;
	  Cryptomining = true;
	  Fingerprinting = true;
	};
	DisablePocket = true;
#	ExtensionSettings = {
#	 "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
#         # uBlock Origin:
#          "uBlock0@raymondhill.net" = {
#            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
#            installation_mode = "force_installed";
#          };
#	  "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
#	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
#	    installation_mode = "force_installed";
#	  };
#	};
      };
      profiles = {
       "blakeh" = {
         id = 0;
         isDefault = true;

         search.engines = {
           "Nix Packages" = {
             icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
             definedAliases = [ "@np" ];
             urls = [{
               template = "https://search.nixos.org/packages";
               params = [
                 { name = "query"; value = "{searchTerms}"; }
               ];
             }];
           };
           "Nix Options" = {
             icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
             definedAliases = [ "@no" ];
             urls = [{
               template = "https://search.nixos.org/options";
               params = [
                 { name = "query"; value = "{searchTerms}"; }
               ];
             }];
           };
           "Home Manager Options" = {
             icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
             definedAliases = [ "@hm" ];
             urls = [{
               template = "https://home-manager-options.extranix.com/";
               params = [
                 { name = "query"; value = "{searchTerms}"; }
               ];
             }];
           };
	 };

         settings = {
           "browser.startup.homepage" = "http://printhost.ocf.berkeley.edu/jobs/|http://logjam/|http://papercut/|http://pagefault/|http://169.229.226.96";
         };

	 extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
	   ublock-origin
	   bitwarden
		 darkreader
	   gruvbox-dark-theme
	 ];

         extraConfig = ''
	   user_pref("extensions.autoDisableScopes", 0);
	   user_pref("extensions.enabledScopes", 15);
	 '';

        };
      };
    };
    fuzzel = {
      enable = true;
      settings.main.anchor = "bottom-left";
    };
    waybar = {
      # stole from https://github.com/TheFrankyDoll/win10-style-waybar
      enable = true;
      style = ''
        /*base background color*/
        @define-color bg_main rgba(25, 25, 25, 0.65);
        @define-color bg_main_tooltip rgba(0, 0, 0, 0.7);


        /*base background color of selections */
        @define-color bg_hover rgba(200, 200, 200, 0.3);
        /*base background color of active elements */
        @define-color bg_active rgba(100, 100, 100, 0.5);

        /*base border color*/
        @define-color border_main rgba(255, 255, 255, 0.2);

        /*text color for entries, views and content in general */
        @define-color content_main white;
        /*text color for entries that are unselected */
        @define-color content_inactive rgba(255, 255, 255, 0.25);

        * {
          text-shadow: none;
          box-shadow: none;
          border: none;
          border-radius: 0;
          font-family: "Segoe UI", "Ubuntu";
          font-weight: 600;
          font-size: 12.7px;
        }

        window#waybar {
          background:  @bg_main;
          border-top: 1px solid @border_main;
          color: @content_main;
        }

        tooltip {
          background: @bg_main_tooltip;
          border-radius: 5px;
          border-width: 1px;
          border-style: solid;
          border-color: @border_main;
        }
        tooltip label{
          color: @content_main;
        }
	#custom-menu{
	  font-family: "JetBrainsMono Nerd Font";
          font-size: 24px;
          padding-left: 12px;
       	  padding-right: 20px;
       	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
	#custom-logout {
	  font-family: "JetBrainsMono Nerd Font";
          font-size: 24px;
          padding-left: 12px;
       	  padding-right: 20px;
       	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
	}
        #custom-menu:hover {
          background:  @bg_hover;
	  color: @content_main;
        }
	#workspaces {
          color: transparent;
  	  margin-right: 1.5px;
  	  margin-left: 1.5px;
        }
	#workspaces button {
          padding: 3px;
	  padding-left: 6px;
          color: @content_inactive;
	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
	#workspaces button.active {
	  color: @content_main;
	  border-bottom: 3px solid white;
        }
	#workspaces button.focused {
          color: @bg_active;
        }
	#workspaces button.urgent {
	  background:  rgba(255, 200, 0, 0.35);
	  border-bottom: 3px dashed @warning_color;
	  color: @warning_color;
        }
	#workspaces button:hover {
          background: @bg_hover;
	  color: @content_main;
        }
	#taskbar {
	}
	#taskbar button {
	  min-width: 130px;
	  border-bottom: 3px solid rgba(255, 255, 255, 0.3);
	  margin-left: 2px;
	  margin-right: 2px;
          padding-left: 8px;
          padding-right: 8px;
          color: white;
	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
	#taskbar button.active {
	  border-bottom: 3px solid white;
          background: @bg_active;
        }
	#taskbar button:hover {
	  border-bottom: 3px solid white;
          background: @bg_hover;
	  color: @content_main;
        }
	#cpu, #disk {
	  padding: 6px;
          font-size: 20px;
        }
	#window {
          border-radius: 10px;
          margin-left: 20px;
          margin-right: 20px;
        }
	#tray {
	  margin-left: 5px;
	  margin-right: 5px;
	}
	#tray > .passive {
	  border-bottom: none;
        }
	#tray > .active {
	  border-bottom: 3px solid white;
        }
	#tray > .needs-attention {
	  border-bottom: 3px solid @warning_color;
        }
	#tray > widget {
	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
	#tray > widget:hover {
	  background: @bg_hover;
        }
	#pulseaudio {
          font-size: 24px;
          font-family: "JetBrainsMono Nerd Font";
  	  padding-left: 3px;
          padding-right: 3px;
  	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
        }
        #pulseaudio:hover {
   	  background: @bg_hover;
        }
	#custom-paper {
	  padding-right: 15px;
	}
	#language {
          font-size: 20px;
	  padding-left: 5px;
	  padding-right: 5px;
	}
	#clock {
          font-size: 20px;
	  padding-right: 5px;
          padding-left: 5px;
     	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
	}
	#clock:hover {
	  background: @bg_hover;
	}
	#image {
     	  transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1);
	  padding: 2px;
	}
	#image:hover {
	  background:@bg_hover;
	}
	#image.chrome-icon {
	  padding: 6px;
	}
      '';
      settings = {
        mainBar = {
          position = "bottom";
	  modules-left = [
	    "custom/menu"
	    "image#nautilus-icon"
	    "image#kitty-icon"
	    "image#firefox-icon"
	    "image#chrome-icon"
	    "hyprland/workspaces"
	    "wlr/taskbar"
	  ];
	  modules-right = [
	    "tray"
	    "custom/paper"
	    "pulseaudio"
	    "hyprland/language"
	    "clock"
	    "custom/logout"
	  ];
	  "hyprland/workspaces" = {
	    "icon-size" = 32;
            "spacing" = 16;
            "on-scroll-up" = "hyprctl dispatch workspace r+1";
            "on-scroll-down" = "hyprctl dispatch workspace r-1";
	    "persistent-workspaces" = {
	      "1" = [];
	      "2" = [];
	      "3" = [];
	      "4" = [];
	      "5" = [];
	    };
	  };
	  #"cpu" = {
	  #  "interval" = 5;
	  #  "format" = "  {usage}%";
	  #  "max-length" = 10;
	  #};
	  #"disk" = {
	  #  "interval" = 30;
	  #  "format" = "󰋊 {percentage_used}%";
	  #  "path" = "/";
	  #  "tooltip" = true;
	  #  "unit" = "GB";
	  #  "tooltip-format" = "Available {free} of {total}";
	  #};
          "hyprland/language" = {
            "format" = "{}";
            "format-en" = "⌨ ENG";
            "format-ru" = "⌨ РУС";
          };
	  "wlr/taskbar" = {
	    "format" = "{icon} {title:.17}";
	    "icon-size" = 32;
	    "spacing" = 3;
	    "on-click-middle" = "close";
	    "tootltip-format" = "{title}";
	    "ignore-list" = [];
	    "on-click" = "activate";
	  };
	  "tray" = {
	    "icon-size" = 18;
	    "spacing" = 3;
	  };
	  "clock" = {
            "format" = "      {:%I:%M %p\n %a, %b %d %Y}";
	    "tooltip-format" = "<tt><small>{calendar}</small></tt>";
	  };
	  "custom/paper" = {
	    "exec" = "paper-genmon";
	  };
	  "custom/menu" = {
	    "format" = " menu";
	    "icon-size" = 48;
	    "tootltip-format" = "{title}";
	    "on-click" = "fuzzel";
	  };
	  "custom/logout" = {
	    "format" = "⇒ Sign out";
	    "icon-size" = 48;
	    "on-click" = "hyprctl dispatch exit";
	  };
	  "image#nautilus-icon" = {
	    "path" = "/run/current-system/sw/share/icons/hicolor/scalable/apps/org.gnome.Nautilus.svg";
	    "size" = 36;
	    "on-click" = "nautilus";
	  };
	  "image#kitty-icon" = {
	    "path" = "/run/current-system/sw/share/icons/hicolor/256x256/apps/kitty.png";
	    "size" = 36;
	    "on-click" = "kitty";
	  };
	  "image#chrome-icon" = {
	    "path" = "/run/current-system/sw/share/icons/hicolor/128x128/apps/google-chrome.png";
	    "size" = 32;
	    "on-click" = "google-chrome-stable";
	  };
	  "image#firefox-icon" = {
	    "path" = "/run/current-system/sw/share/icons/hicolor/128x128/apps/firefox.png";
	    "size" = 36;
	    "on-click" = "firefox";
	  };
	  "pulseaudio" = {
            "max-volume" = 150;
            "scroll-step" = 10;
            "format" = "{icon}";
            "tooltip-format" = "{volume}%";
            "format-muted" = " ";
            "format-icons" = {
              "default" = [
                  " "
                  " "
                  " "
              ];
            };
            "on-click" = "pavucontrol";
	  };
        };
      };
    };
    git = {
      enable = true;
      settings = {
	user = {
	  name = "Blake Haug";
	  email = "blake@blakehaug.com";
	};
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedsignersfile = "${toString config.home.homeDirectory}/.ssh/allowed_signers";
        user.signingkey = "${toString config.home.homeDirectory}/.ssh/id_ed25519_sk.pub";
        init.defaultbranch = "main";
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      extraConfig = ''
        set background=dark
	colorscheme gruvbox
	set number
      '';
      plugins = with pkgs.vimPlugins; [
        gruvbox
	#everforest
        neo-tree-nvim
        nvim-web-devicons #neotree optional
        nvim-window-picker #neotree optional
        plenary-nvim #neotree dependency
        nui-nvim #neotree dependency
        nvim-treesitter
        nvim-treesitter-parsers.yaml
        nvim-treesitter-parsers.rust
        nvim-treesitter-parsers.python
        nvim-treesitter-parsers.puppet
        nvim-treesitter-parsers.nix
        nvim-treesitter-parsers.javascript
        nvim-treesitter-parsers.java
        nvim-treesitter-parsers.c
        nvim-treesitter-parsers.markdown
        nvim-treesitter-parsers.markdown_inline
        nvim-treesitter-parsers.markdown_inline
        nvim-treesitter-parsers.html
        nvim-treesitter-parsers.css
      ];
      viAlias = true;
      vimAlias = true;
    };
    starship = {
      enable = true;
    };
    kitty = {
      enable = true;
      enableGitIntegration = true;

      #https://github.com/kovidgoyal/kitty-themes/tree/master/themes for more themes
      #themeFile = "everforest_dark_medium";
      themeFile = "gruvbox-dark-hard";

      font = {
        name = "hack";
        #size = 20.0;
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "/home/b/bl/blakeh/remote/hyprland-home-manager/night_sky-Blake_Haug.png"
      ];
      wallpaper = [
        ", /home/b/bl/blakeh/remote/hyprland-home-manager/night_sky-Blake_Haug.png"
      ];
    };
  };

  wayland.windowManager.hyprland = {

    enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
      pkgs.hyprlandPlugins.borders-plus-plus
    ];

    settings = {
      "$mod" = "SUPER";
      exec-once = "waybar";
      monitor = [
        "HDMI-A-3, 3840x2160, 0x0, 1.5"
      ];
      general = {
        border_size = 2;
	gaps_in = 5;
        gaps_out = 20;
	"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
	rounding_power = 2;
	active_opacity = 1.0;
	inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 8;
          passes = 3;
	  noise = 0.01;
	  brightness = 0.8;
        };
        shadow = {
          enabled = true;
          range = 8;
          render_power = 3;
          color = "rgba(00000044)";
        };
      };
      animations = {
        enabled = "yes, please :)";
      };
      misc = {
        disable_hyprland_logo = false;
        force_default_wallpaper = "-1";
      };

      bind = [

      # basics
      "$mod, C, killactive"
      "$mod, C, killactive"
      ", F11, fullscreen"
      "$mod, F, togglefloating"

      # application shortcuts
      "$mod, Q, exec, kitty"
      "$mod, G, exec, firefox"

      # workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "SUPER_SHIFT, 1, movetoworkspace, 1"
      "SUPER_SHIFT, 2, movetoworkspace, 2"
      "SUPER_SHIFT, 3, movetoworkspace, 3"
      "SUPER_SHIFT, 4, movetoworkspace, 4"
      "SUPER_SHIFT, 5, movetoworkspace, 5"

      # screenshots (windows keybinds)
      ", Print, exec, hyprshot -m window -m active --clipboard-only" # entire screen
      "Alt, Print, exec, hyprshot -m window --clipboard-only" # active window
      "SUPER_SHIFT, S, exec, hyprshot -m region --clipboard-only" # select a region
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      plugin.hyprbars = {
	bar_color = "rgb(2a2a2a)";
        bar_height = 0;
	col_text = "rgba(ffffffdd)";
	bar_text_size = 11;
	bar_text_font = "Ubuntu Nerd Font";

        bar_button_padding = 12;
	bar_padding = 10;
	hyprbars-button = [
	  "rgb(2a2a2a), 20, , hyprctl dispatch killactive"
          "rgb(2a2a2a), 20, , hyprctl dispatch fullscreen 2"
          #"rgb(2a2a2a), 20, ━, xdotool windowunmap $(xdotool getactivewindow)"
	];
      };
    };
  };

}
