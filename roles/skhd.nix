{ config, pkgs, ... }:

let
  system = pkgs.system;
in {
  services.skhd.enable = true;
  services.skhd.package =  pkgs.skhd;
  services.skhd.skhdConfig = ''
    # open terminal
    cmd - return : /run/current-system/sw/bin/kitty --single-instance -d ~ &> /dev/null
    
    # open mpv with url from clipboard
    shift + cmd - m : mpv $(pbpaste)
    
    # focus window
    ctrl - x : yabai -m window --focus recent
    ctrl - left  : yabai -m window --focus west
    ctrl - down  : yabai -m window --focus south
    ctrl - up  : yabai -m window --focus north
    ctrl - right  : yabai -m window --focus east
    shift + ctrl - z : yabai -m window --focus stack.prev
    shift + ctrl - c : yabai -m window --focus stack.next
    
    # swap window
    shift + alt - x : yabai -m window --swap recent
    shift + alt - left  : yabai -m window --swap west
    shift + alt - down  : yabai -m window --swap south
    shift + alt - up  : yabai -m window --swap north
    shift + alt - right  : yabai -m window --swap east
    
    # move window
    shift + cmd - left  : yabai -m window --warp west
    shift + cmd - down  : yabai -m window --warp south
    shift + cmd - up  : yabai -m window --warp north
    shift + cmd - right  : yabai -m window --warp east
    
    # balance size of windows
    shift + alt - 0 : yabai -m space --balance
    
    # make floating window fill screen
    shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1
    
    # make floating window fill left-half of screen
    shift + alt - left   : yabai -m window --grid 1:2:0:0:1:1
    
    # make floating window fill right-half of screen
    shift + alt - right  : yabai -m window --grid 1:2:1:0:1:1
    
    # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
    shift + cmd - n : yabai -m space --create && \
                      index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" | not))[-1].index')" && \
                      yabai -m window --space "''${index}" && \
                      yabai -m space --focus "''${index}"
    
    # create desktop and follow focus - uses jq for parsing json (brew install jq)
    cmd + alt - n : yabai -m space --create && \
                    index="$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" | not))[-1].index')" && \
                    yabai -m space --focus "''${index}"
    
    # destroy desktop
    # cmd + alt - w : yabai -m space --destroy
    cmd + alt - w : yabai -m space --focus prev && yabai -m space recent --destroy
    
    # fast focus desktop
    cmd + alt - x : yabai -m space --focus recent
    cmd + alt - z : yabai -m space --focus prev || skhd -k "ctrl + alt + cmd - z"
    cmd + alt - c : yabai -m space --focus next || skhd -k "ctrl + alt + cmd - c"
    cmd + alt - 1 : yabai -m space --focus  1 || skhd -k "ctrl + alt + cmd - 1"
    cmd + alt - 2 : yabai -m space --focus  2 || skhd -k "ctrl + alt + cmd - 2"
    cmd + alt - 3 : yabai -m space --focus  3 || skhd -k "ctrl + alt + cmd - 3"
    cmd + alt - 4 : yabai -m space --focus  4 || skhd -k "ctrl + alt + cmd - 4"
    cmd + alt - 5 : yabai -m space --focus  5 || skhd -k "ctrl + alt + cmd - 5"
    cmd + alt - 6 : yabai -m space --focus  6 || skhd -k "ctrl + alt + cmd - 6"
    cmd + alt - 7 : yabai -m space --focus  7 || skhd -k "ctrl + alt + cmd - 7"
    cmd + alt - 8 : yabai -m space --focus  8 || skhd -k "ctrl + alt + cmd - 8"
    cmd + alt - 9 : yabai -m space --focus  9 || skhd -k "ctrl + alt + cmd - 9"
    cmd + alt - 0 : yabai -m space --focus 10 || skhd -k "ctrl + alt + cmd - 0"
    
    # send window to desktop and follow focus
    # shift + cmd - x : yabai -m window --space recent && yabai -m space --focus recent
    # shift + cmd - z : yabai -m window --space prev && yabai -m space --focus prev
    # shift + cmd - c : yabai -m window --space next && yabai -m space --focus next
    # shift + cmd - 1 : yabai -m window --space  1 && yabai -m space --focus 1
    # shift + cmd - 2 : yabai -m window --space  2 && yabai -m space --focus 2
    # shift + cmd - 3 : yabai -m window --space  3 && yabai -m space --focus 3
    # shift + cmd - 4 : yabai -m window --space  4 && yabai -m space --focus 4
    # shift + cmd - 5 : yabai -m window --space  5 && yabai -m space --focus 5
    # shift + cmd - 6 : yabai -m window --space  6 && yabai -m space --focus 6
    # shift + cmd - 7 : yabai -m window --space  7 && yabai -m space --focus 7
    # shift + cmd - 8 : yabai -m window --space  8 && yabai -m space --focus 8
    # shift + cmd - 9 : yabai -m window --space  9 && yabai -m space --focus 9
    # shift + cmd - 0 : yabai -m window --space 10 && yabai -m space --focus 10
    
    # focus monitor
    ctrl + alt - x  : yabai -m display --focus recent
    ctrl + alt - z  : yabai -m display --focus prev
    ctrl + alt - c  : yabai -m display --focus next
    ctrl + alt - 1  : yabai -m display --focus 1
    ctrl + alt - 2  : yabai -m display --focus 2
    ctrl + alt - 3  : yabai -m display --focus 3
    
    # send window to monitor and follow focus
    ctrl + cmd - x  : yabai -m window --display recent && yabai -m display --focus recent
    ctrl + cmd - z  : yabai -m window --display prev && yabai -m display --focus prev
    ctrl + cmd - c  : yabai -m window --display next && yabai -m display --focus next
    ctrl + cmd - 1  : yabai -m window --display 1 && yabai -m display --focus 1
    ctrl + cmd - 2  : yabai -m window --display 2 && yabai -m display --focus 2
    ctrl + cmd - 3  : yabai -m window --display 3 && yabai -m display --focus 3
    
    # move window
    shift + ctrl - a : yabai -m window --move rel:-20:0
    shift + ctrl - s : yabai -m window --move rel:0:20
    shift + ctrl - w : yabai -m window --move rel:0:-20
    shift + ctrl - d : yabai -m window --move rel:20:0
    
    # increase window size
    shift + alt - a : yabai -m window --resize left:-20:0
    shift + alt - s : yabai -m window --resize bottom:0:20
    shift + alt - w : yabai -m window --resize top:0:-20
    shift + alt - d : yabai -m window --resize right:20:0
    
    # decrease window size
    shift + cmd - a : yabai -m window --resize left:20:0
    shift + cmd - s : yabai -m window --resize bottom:0:-20
    shift + cmd - w : yabai -m window --resize top:0:20
    shift + cmd - d : yabai -m window --resize right:-20:0
    
    # set insertion point in focused container
    ctrl + alt - left  : yabai -m window --insert west
    ctrl + alt - down  : yabai -m window --insert south
    ctrl + alt - up  : yabai -m window --insert north
    ctrl + alt - right  : yabai -m window --insert east
    ctrl + alt - i : yabai -m window --insert stack
    
    # rotate tree
    alt - r : yabai -m space --rotate 90
    
    # mirror tree y-axis
    alt - y : yabai -m space --mirror y-axis
    
    # mirror tree x-axis
    alt - x : yabai -m space --mirror x-axis
    
    # toggle desktop offset
    alt - a : yabai -m space --toggle padding --toggle gap
    
    # toggle window parent zoom
    alt - d : yabai -m window --toggle zoom-parent
    
    # toggle window fullscreen zoom
    alt - f : yabai -m window --toggle zoom-fullscreen
    
    # toggle window native fullscreen
    shift + alt - f : yabai -m window --toggle native-fullscreen
    
    # toggle window split type
    alt - e : yabai -m window --toggle split
    
    # float / unfloat window and restore position
    # alt - t : yabai -m window --toggle float && /tmp/yabai-restore/$(yabai -m query --windows --window | jq -re '.id').restore 2>/dev/null || true
    alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2
    
    # toggle sticky (show on all spaces)
    alt - s : yabai -m window --toggle sticky
    
    # toggle topmost (keep above other windows)
    alt - o : yabai -m window --toggle topmost
    
    # toggle picture-in-picture
    alt - p : yabai -m window --toggle border --toggle pip
    
    # change layout of desktop
    ctrl + alt - a : yabai -m space --layout bsp
    ctrl + alt - d : yabai -m space --layout float
    ctrl + alt - s : yabai -m space --layout $(yabai -m query --spaces --space | jq -r 'if .type == "bsp" then "float" else "bsp" end')
    
    #.blacklist [
    #    "kitty"
    #]
  '';
}
