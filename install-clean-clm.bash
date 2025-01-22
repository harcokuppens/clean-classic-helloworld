#!/bin/bash
set -e

script_dir=$(dirname $0)
script_dir=${script_dir:?} # aborts with error if script_dir not set
echo bash "$script_dir/cleanup.bash"
bash "$script_dir/cleanup.bash" all

/onCreate.sh
