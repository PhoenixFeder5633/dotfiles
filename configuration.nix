# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${inputs.home-manager}/nixos"
    ];
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    #extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.phoef = {
    isNormalUser = true;
    description = "PhoenixFeder";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  home-manager.users.phoef = {
    programs.git = {
      enable = true;
      userName = "PhoenixFeder";
      userEmail = "phoenixfeder5633@gmail.com";
      extraConfig.init.defaultBranch = "main";
    };
    home.stateVersion = "24.05";
    home.username = "phoef";
    home.homeDirectory = "/home/phoef";
    home.packages = [
      inputs.fabricbar.packages.x86_64-linux.default
    ];
    programs.home-manager.enable = true;
    programs.waybar = {
      enable = true;
      settings = [{
        layer = "bottom";
        position = "top";
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
          "interval" = 1;
          "format" = "{:%T  %a %d.%m.%Y}";
          "tooltip" = true;
          "tooltip-format" = "{=%A; %d %B %Y}\n<tt>{calendar}</tt>";
        };
        "tray" = {
          spacing = 12;
        };
      }];
    };
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
        monitor = HDMI-A-1, 1920x1080@74.97, 0x0, 1
        monitor = Unknown-1, disable

        env = LIBVA_DRIVER_NAME,nvidia
        env = XDG_SESSION_TYPE,wayland
        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia

        exec = swww kill ; swww-daemon --format xrgb
        exec = swww img ~/Pictures/Frieren.jpg

        exec = pkill fabricbar ; fabricbar

        cursor {
          no_hardware_cursors = true
        }

        input {
          kb_layout = de
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          touchpad {
            natural_scroll = false
          }

          sensitivity = 0
        }

        windowrule = opacity 1.0, class:^(mpv)$

        general {
          gaps_in = 5
          gaps_out = 10
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = dwindle
        }

        decoration {
          rounding = 10
          blur {
            enabled = true
            size = 3
            passes = 1
            new_optimizations = true
          }
          
          active_opacity = 0.95
          inactive_opacity = 0.9
          fullscreen_opacity = 1

          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
        }

        animations {
          enabled = yes

          bezier = ease, 0.4, 0.02, 0.21, 1

          animation = windows, 1, 3.5, ease, slide
          animation = windowsOut, 1, 3.5, ease, slide
          animation = border, 1, 6, default
          animation = fade, 1, 3, ease
        }

        dwindle {
          pseudotile = yes
          preserve_split = yes
        }

        gestures {
          workspace_swipe = false
        }

        misc { 
          force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
        }


        binds {
          scroll_event_delay = 1
        }

        bind = SUPER, RETURN, exec, kitty
        bind = SUPER, D, exec, killall rofi || rofi -show drun -normal-window
        bind = SUPER, W, exec, firefox

        bind = SUPER, Q, killactive,

        bind = SUPER, 1, workspace, 1
        bind = SUPER, 2, workspace, 2
        bind = SUPER, 3, workspace, 3
        bind = SUPER, 4, workspace, 4
        bind = SUPER, 5, workspace, 5
        bind = SUPER, 6, workspace, 6
        bind = SUPER, 7, workspace, 7
        bind = SUPER, 8, workspace, 8
        bind = SUPER, 9, workspace, 9
        bind = SUPER, 0, workspace, 10

        bind = SUPER SHIFT, 1, movetoworkspace, 1
        bind = SUPER SHIFT, 2, movetoworkspace, 2
        bind = SUPER SHIFT, 3, movetoworkspace, 3
        bind = SUPER SHIFT, 4, movetoworkspace, 4
        bind = SUPER SHIFT, 5, movetoworkspace, 5
        bind = SUPER SHIFT, 6, movetoworkspace, 6
        bind = SUPER SHIFT, 7, movetoworkspace, 7
        bind = SUPER SHIFT, 8, movetoworkspace, 8
        bind = SUPER SHIFT, 9, movetoworkspace, 9
        bind = SUPER SHIFT, 0, movetoworkspace, 10

        bind = SUPER, mouse_up, workspace, e+1
        bind = SUPER, mouse_down, workspace, e-1

        bind = SUPER SHIFT, mouse_up, movetoworkspace, e+1
        bind = SUPER SHIFT, mouse_down, movetoworkspace, e-1

        bind = SUPER, mouse:275, togglefloating
        bind = SUPER, mouse:276, killactive
        bind = SUPER, mouse:274, fullscreen

        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow 1
        bindm = SUPER SHIFT, mouse:273, resizewindow 2
      '';
    };
  };

  #fileSystems."/mnt/A" = {
  #  device = "/dev/sdb1";
  #  fsType = "ntfs-3g";
  #  options = [ "defaults" ];
  #};


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #dev
    vim
    git
    jdk
    python313
    qemu
    quickemu
    rpm-ostree
    inputs.nix-autobahn.packages.x86_64-linux.nix-autobahn
    #files
    mpv
    wget
    zip
    unzip
    gzip
    gnutar
    ntfs3g
    #gaming
    mangohud
    gamemode
    libnvidia-container
    vulkan-tools
    mesa
    mesa_drivers
    vulkan-loader
    glfw
    #hyprland
    kitty
    rofi-wayland
    waybar
    wev
    swww
    swaynotificationcenter
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  #stylix = {
  #  enable = true;
  #  image = /home/phoef/Pictures/Frieren.jpg;
  #};

  services.flatpak = {
    enable = true;

    remotes = lib.mkOptionDefault [{
      name = "flathub-beta";
      location = "https://flathub.org/beta-repo/flathub-beta.flatpakrepo";
    }];

    packages = [
      { appId = "com.valvesoftware.Steam"; origin = "flathub"; }
      { appId = "net.davidotek.pupgui2"; origin = "flathub"; }
      { appId = "net.lutris.Lutris"; origin = "flathub"; }
      { appId = "com.usebottles.bottles"; origin = "flathub"; }
      { appId = "com.heroicgameslauncher.hgl"; origin = "flathub"; }
      { appId = "org.ryujinx.Ryujinx"; origin = "flathub"; }
      { appId = "com.visualstudio.code"; origin = "flathub"; }
      { appId = "dev.vencord.Vesktop"; origin = "flathub"; }
      { appId = "com.atlauncher.ATLauncher"; origin = "flathub"; }
      { appId = "com.lunarclient.LunarClient"; origin = "flathub"; }
    ];
  };

  virtualisation.waydroid.enable = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
