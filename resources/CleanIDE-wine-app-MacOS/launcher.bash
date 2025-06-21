#!/bin/bash
# Set up any environment variables needed for your GUI app
# For a Wine app, this might involve setting WINEPREFIX:

export WINE_PATH="/opt/homebrew/bin/wine"
#export WINEPREFIX="/path/to/your/wine/prefix" # Use an absolute path or a path relative to the app bundle if bundled
# By default, Wine uses a prefix located at ~/.wine, but you can create and use custom prefixes.

#echo "$@" >>/tmp/debug_log.txt

script_dir=$(dirname $0)
script_dir="$(realpath $script_dir)"
script_dir=${script_dir:?} # aborts with error if script_dir not set
cd "$script_dir" || exit

# Check if any arguments were passed (i.e., if a file was opened with the app)
if [ "$#" -gt 0 ]; then
    #echo "$(date) - Files opened with the app:" >>/tmp/debug_log.txt # For debugging
    # Loop through all passed arguments (file paths)
    for file_path in "$@"; do
        #echo "$(date) - Processing file: $file_path" >>/tmp/debug_log.txt
        windows_path="$(
            /opt/homebrew/bin/winepath -l -w "$file_path" 2>/dev/null
        )"
        #echo "$(date) - Converted to Windows path: $windows_path" >>/tmp/debug_log.txt
        "$WINE_PATH" "$script_dir/clean3.1/CleanIde.exe" "$windows_path" &
        disown
    done
else
    # If no arguments were passed, launch the app without a file (e.g., if double-clicked)
    echo "$(date) - No files opened, launching app normally." >>/tmp/debug_log.txt

    "$WINE_PATH" "$script_dir/clean3.1/CleanIde.exe" &
    disown
    #"$WINE_PATH" WINEPREFIX="$WINEPREFIX" C:\\path\\to\\your\\windows\\app.exe &
fi
