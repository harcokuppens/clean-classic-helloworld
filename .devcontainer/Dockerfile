FROM cleanlang/devcontainer

# remove onStartup.sh from original container. Name was wrongly choosen, because script is only run when container is created, and not when started.
RUN rm /onStartup.sh

# we create a onCreate script which installs eastwood and installs classic clean in your workspace folder
COPY <<'EOF' /onCreate.sh
#! /bin/bash
set -e

nitrile update
#nitrile fetch
nitrile global install eastwood

# install fresh clean in your workspace folder
# Must be in workspace folder otherwise vscode does not show the location of a clean source file in tree view.
# We want to see clean sources in the tree view so we can easily browse them!
rm -rf clean
wget https://ftp.cs.ru.nl/Clean/Clean31/linux/clean3.1_64.tar.gz \
     && tar -xzvf  clean3.1_64.tar.gz \
     && rm clean3.1_64.tar.gz \
     && make -C clean \
     && echo 'export PATH="$PATH:'$PWD'/clean/bin/:'$PWD'/clean/exe/"' >> /etc/bash.bashrc
EOF

RUN chmod a+x /onCreate.sh
