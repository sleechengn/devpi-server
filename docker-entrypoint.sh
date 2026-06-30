#!/usr/bin/bash
source /opt/venv/bin/activate

nohup nginx > /dev/null &
nohup filebrowser -d /opt/filebrowser/filebrowser.db -a 127.0.0.1 -p 8081 -b /filebrowser -r / --noauth > /dev/null &
nohup ttyd.x86_64 --port 8082 --base-path /ttyd --writable -t enableZmodem=true -t enableTrzsz=true /usr/bin/fish > /dev/null &
if [ ! -e "~/.tmux.conf" ]; then
cat > ~/.tmux.conf <<EOF
set -g mouse on
unbind -n MouseDown3Pane
set -g default-command fish
EOF
tmux source ~/.tmux.conf
fi
if [ ! -e "/usr/bin/t" ] && [ $(id -u $(whoami)) -eq 0 ]; then
cat > /usr/bin/t <<EOF
#!/usr/bin/env bash
if [ "\$(tmux ls|grep '^default.*')" ]; then
        tmux a -t default
else
        tmux new -s default
fi
EOF
chmod +x /usr/bin/t
fi
devpi-server --serverdir /opt/devpi-server --host=0.0.0.0
