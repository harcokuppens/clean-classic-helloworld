#!/bin/bash
set -e

script_dir=$(dirname $0)
rm -rf "$script_dir/bin"
rm -rf "$script_dir/src/Clean System Files"

# also cleanup clean folder 
rm -rf "$script_dir/clean"

echo "To recreate the clean/ folder in your workspace folder in the container run in the container: /onCreate.sh "