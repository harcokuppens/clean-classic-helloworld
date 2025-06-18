#!/bin/bash

script_dir=$(dirname $0)

if [[ -d "$script_dir/clean" ]]
then 
   export CLEAN_HOME="$script_dir/clean"
   export PATH="$CLEAN_HOME/bin:$PATH"   
fi

echo "Using Clean in $CLEAN_HOME"

cpm "$@"  