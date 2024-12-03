#!/bin/bash
set -e
STACKSIZE=40m
HEAPSIZE=20m
# add clm to PATH
#export PATH="$PATH:/usr/local/clean/bin/"
script_dir=$(dirname $0)

projects="HelloWorld"


build_script() {
  local prj_dir prj_name line
  prj_dir="$1"
  prj_name="$2"
  line="------------------------------------------------------------------"
  
  mkdir -p "$prj_dir/bin/"
  printf "\n$line\n    $prj_name\n$line\n - project name: $prj_name\n - project dir: $prj_dir\n - command to be builded : $prj_dir/bin/$prj_name\n\n"
  echo clm -nr -nt -h $HEAPSIZE -s $STACKSIZE -I "$prj_dir/src/" -IL ArgEnv  "$prj_name" -o "$prj_dir/bin/$prj_name"
  clm -nr -nt -h $HEAPSIZE -s $STACKSIZE -I "$prj_dir/src/" -IL ArgEnv  "$prj_name" -o "$prj_dir/bin/$prj_name"
  printf "\nThe builded command can be found in : $prj_dir/bin/$prj_name\n\n"
}

# cleanup old build(s) 
echo bash $script_dir/clean.bash
bash $script_dir/clean.bash
# build project(s)
for prj_name in $projects; do
  build_script "$script_dir" "$prj_name" 
done
