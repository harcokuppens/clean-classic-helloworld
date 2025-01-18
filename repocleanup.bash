#!/bin/bash
set -e

script_dir=$(dirname $0)
rm -rf "$script_dir/bin"
# cleanup builds in src folders in "Clean System Files" folders
find "$script_dir/src"  -name 'Clean System Files' -type d -exec echo {} ';'  | xargs -I % rm -r "%"


# also cleanup clean folder 
rm -rf "$script_dir/clean"

echo "To recreate the clean/ folder in your workspace folder in the container run in the container: /onCreate.sh "
