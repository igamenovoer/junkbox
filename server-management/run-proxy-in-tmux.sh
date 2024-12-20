#!/bin/bash

# start a clash proxy in tmux
# the input argument is a directory containing the clash and config file
# the clash binary is in the directory

# directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# check if the argument is given, if not given, defaults to ./clash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <clash directory>"
    echo "defaulting to ./clash"
    CLASH_DIR="$DIR/clash"
else
    CLASH_DIR=$1
fi

# check if the directory exists
if [ ! -d "$CLASH_DIR" ]; then
  echo "$CLASH_DIR does not exist"
  exit 1
fi

# find a binary in the directory, starting with clash
CLASH_BIN=$(find $CLASH_DIR -type f -name "clash*" | head -n 1)

# check if the binary exists
if [ ! -f "$CLASH_BIN" ]; then
  echo "clash binary does not exist in $CLASH_DIR"
  exit 1
fi

# is CLASH_BIN executable?
if [ ! -x "$CLASH_BIN" ]; then
  echo "$CLASH_BIN is not executable"
  exit 1
fi

# is clash already running?
# if so, close the tmux session
if tmux has-session -t clash; then
    echo "clash is already running, killing it"
    tmux kill-session -t clash
fi

# create a new named tmux session called 'clash'
echo "starting clash in tmux session"
tmux new-session -d -s clash

# run the clash proxy in the tmux session
echo "running clash in tmux session"
tmux send-keys -t clash "$CLASH_BIN -d $CLASH_DIR" C-m

echo "clash is running in tmux session clash"
echo "you can attach to the session by running 'tmux attach -t clash'"