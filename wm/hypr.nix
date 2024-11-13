{ config, pkgs, lib, inputs, ... }: {
  home-manager.users.phoef = {
    wayland.windowManager.hyprland = {
      enable = true;
			package = inputs.hy3.inputs.hyprland.packages.${pkgs.system}.hyprland;
			plugins = [ inputs.hy3.packages.${pkgs.system}.hy3 ];
      settings = {

      };
      extraConfig = ''
        monitor = HDMI-A-1, 1920x1080@74.97, 0x0, 1
        monitor = Unknown-1, disable

        env = LIBVA_DRIVER_NAME,nvidia
        env = XDG_SESSION_TYPE,wayland
        env = GBM_BACKEND,nvidia-drm
        env = __GLX_VENDOR_LIBRARY_NAME,nvidia

        exec = swww kill ; swww-daemon --format xrgb
				exec = hyprctl setcursor ${pkgs.bibata-cursors}/share/icons/Bibata-Modern-Ice 22

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

        general {
          gaps_in = 0
          gaps_out = 0
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = hy3
        }

        decoration {
          rounding = 0
          blur {
            enabled = false
            size = 3
            passes = 1
            new_optimizations = true
          }
          
          active_opacity = 1
          inactive_opacity = 1
          fullscreen_opacity = 1

          drop_shadow = false
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

				cursor {
					enable_hyprcursor = false
				}

				plugin {
					hy3 {
						tabs {
							height = 3
							padding = 0
							rounding = 0
							render_text = false
						}
						autotile {
							enable = true
							trigger_width = 800
							trigger_height = 500
						}
					}
				}

        bind = SUPER, RETURN, exec, kitty
        bind = SUPER, D, exec, killall rofi || rofi -show drun -normal-window
        bind = SUPER, W, exec, firefox
				bind = SUPER SHIFT, S, exec, tesseract_screen

        bind = SUPER, Q, hy3:killactive,

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

        bind = SUPER SHIFT, 1, hy3:movetoworkspace, 1
        bind = SUPER SHIFT, 2, hy3:movetoworkspace, 2
        bind = SUPER SHIFT, 3, hy3:movetoworkspace, 3
        bind = SUPER SHIFT, 4, hy3:movetoworkspace, 4
        bind = SUPER SHIFT, 5, hy3:movetoworkspace, 5
        bind = SUPER SHIFT, 6, hy3:movetoworkspace, 6
        bind = SUPER SHIFT, 7, hy3:movetoworkspace, 7
        bind = SUPER SHIFT, 8, hy3:movetoworkspace, 8
        bind = SUPER SHIFT, 9, hy3:movetoworkspace, 9
        bind = SUPER SHIFT, 0, hy3:movetoworkspace, 10

        bind = SUPER, mouse_up, workspace, +1
        bind = SUPER, mouse_down, workspace, -1

        bind = SUPER SHIFT, mouse_up, hy3:movetoworkspace, +1
        bind = SUPER SHIFT, mouse_down, hy3:movetoworkspace, -1

				bindn = , mouse:272, hy3:focustab, mouse
				bind = SUPER SHIFT, M, hy3:changefocus, raise
				bind = SUPER, M, hy3:changefocus, lower
				bind = SUPER, H, hy3:makegroup, v
				bind = SUPER, N, hy3:makegroup, h
				bind = SUPER, U, hy3:makegroup, tab

				bind = SUPER, J, hy3:movefocus, l
				bind = SUPER, K, hy3:movefocus, d
				bind = SUPER, L, hy3:movefocus, u
				bind = SUPER, code:47, hy3:movefocus, r

				bind = SUPER SHIFT, J, hy3:movewindow, l, once
				bind = SUPER SHIFT, K, hy3:movewindow, d, once
				bind = SUPER SHIFT, L, hy3:movewindow, u, once
				bind = SUPER SHIFT, code:47, hy3:movewindow, r, once

        bind = SUPER, mouse:275, togglefloating
        bind = SUPER, mouse:276, killactive
        bind = SUPER, mouse:274, fullscreen

        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow 1
        bindm = SUPER SHIFT, mouse:273, resizewindow 2

				windowrulev2 = float,class:^(Waydroid|waydroid)
      '';
    };
  };
}
