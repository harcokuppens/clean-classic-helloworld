script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

if [[ -d "$script_dir/clean" ]]; then
    export CLEAN_HOME="$script_dir/clean"
    export PATH="$CLEAN_HOME:$CLEAN_HOME/bin:$PATH"
    # note in Windows the cpm command is located in the root of CLEAN_HOME
    echo "Set environment to use Clean in $CLEAN_HOME"
else
    echo "WARNING: environment not changed because local clean/ folder not found"
fi
