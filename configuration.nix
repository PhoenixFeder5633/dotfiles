# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./wm/hypr.nix
    ];
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  
  # Bootloader.
	boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.efi.efiSysMountPoint = "/boot";
	boot.loader.grub = {
		enable = true;
		useOSProber = true;
		device = "nodev";
		efiSupport = true;
	};

	boot.kernelPackages = pkgs.linuxPackages_zen;

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

  services.xserver.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

	services.usbmuxd.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
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

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
		dancing-script
		corefonts
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.phoef = {
    isNormalUser = true;
    description = "PhoenixFeder";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
    ];
  };

  home-manager.users.phoef = {
    imports = [
    ];
    programs.git = {
      enable = true;
      userName = "PhoenixFeder";
      userEmail = "phoenixfeder5633@gmail.com";
      extraConfig.init.defaultBranch = "main";
    };
    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.obs-websocket
      ];
    };
    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font Mono";
      };
      settings = {
        confirm_os_window_close = "0";
        disable_ligatures = "cursor";
				cursor_blink_interval = "0";
				copy_on_select = "no";
				open_url_with = "xdg-open";
				enable_audio_bell = "no";
				font_size = "11.5";
				background_opacity = "0.5";
      };
    };
		home.pointerCursor = {
			gtk.enable = true;
			x11.enable = true;
			package = pkgs.bibata-cursors;
			name = "Bibata-Modern-Ice";
			size = 22;
		};
		dconf.settings = {
			"org/virt-manager/virt-manager/connections" = {
				autoconnect = ["qemu:///system"];
				uris = ["qemu:///system"];
			};
		};
    home.stateVersion = "24.05";
    home.username = "phoef";
    home.homeDirectory = "/home/phoef";
    home.packages = [
    ];
    programs.home-manager.enable = true;
  };

  security.polkit.extraConfig = /* js */ ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
        subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #dev
    vim
    #files
    mpv
		nemo
		libreoffice
    #gaming
    gamemode
    gamescope
    libnvidia-container
    vulkan-tools
    mesa
    vulkan-loader
    glfw
		vesktop
		atlauncher
    #screen
    wl-clipboard
    pulseaudio
    wireplumber
    playerctl
    #hyprland
		firefox
    rofi-wayland
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
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
	};

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
  system.stateVersion = "unstable"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
