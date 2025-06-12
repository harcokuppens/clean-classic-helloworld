#!/bin/bash
set -e

script_dir=$(dirname $0)
script_dir=${script_dir:?} # aborts with error if script_dir not set

# uninstall old version first
echo bash "$script_dir/cleanup.bash"
bash "$script_dir/cleanup.bash" all

cd "$script_dir"

# install fresh clean in your workspace folder
# Must be in workspace folder otherwise vscode does not show the location of a clean source file in tree view.
# We want to see clean sources in the tree view so we can easily browse them!
wget https://ftp.cs.ru.nl/Clean/Clean31/linux/clean3.1_64.tar.gz \
     && tar -xzvf  clean3.1_64.tar.gz \
     && rm clean3.1_64.tar.gz \
     && make -C clean \
     && echo 'export PATH="$PATH:'$PWD'/clean/bin/:'$PWD'/clean/exe/"' >> /etc/bash.bashrc


# note: similar code done when container created in /onCreate.sh
