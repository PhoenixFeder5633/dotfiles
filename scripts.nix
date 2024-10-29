{ pkgs }:
let
in [
  (pkgs.writeShellScriptBin "clipr" ''
    gpu-screen-recorder \
      -w screen -f 60 \
      -a "$(pactl get-default-sink).monitor" -a "$(pactl get-default-source)" \
      -r 300 -c mp4 -o ~/Videos &
    recid=$!
    hyprctl keyword bind SUPER, R, exec, "hyprctl notify -1 10000 'rgb(ff1ea3)' Hello; kill -s SIGUSR1 $recid"
    sleep 20
    hyprctl keyword unbind SUPER, R
    kill -s SIGINT "$recid"
    sleep .5
  '')
  (pkgs.writers.writePython3Bin "clipy" {} ''
    import signal
    import subprocess

    p = subprocess.Popen(["gpu-screen-recorder", "-w", "screen", "-f", "60", "-a", '"$(pactl get-default-sink).monitor"', "-a", '"$(pactl get-default-source)"', "-r", "300", "-c", "mp4", "-o", "~/Videos"])

    subprocess.Popen(["sleep", "30"]).wait()

    p.send_signal(signal.SIGINT)
    p.wait()
  '')
]