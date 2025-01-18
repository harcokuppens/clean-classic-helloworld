# HelloWorld Clean console application build using `clm`  

This is a Clean example project that uses a clean distribution from the Clean programming language website https://clean.cs.ru.nl/ and compiles projects with the `clm` tool, managed through the build.bash script.
The project includes a simple “Hello, World!” console application, but it can also serve as a template for building other projects.

This project can be used using a devcontainer which automatically setups a development environment with a clean installation from https://clean.cs.ru.nl/ for you in a docker container from which you can directly start developing. (see section below)

However you offcourse can use this project on your local machine by installing Clean from https://clean.cs.ru.nl/ yourself.
* install Clean from https://clean.cs.ru.nl/ .
* build project with `clm` using the command:  ./build.bash
* clean project with bash script using the command:  ./cleanup.bash

There is also a similar repository where we build the same HelloWorld Clean code using the nitrile tool at: https://github.com/harcokuppens/clean-nitrile-helloworld.git .

## Devcontainer 

The project provides a ready-to-use environment for developing Clean applications using Docker development container via a devcontainer.

The development container (devcontainer) uses Nitrile to install the Eastwood language server. However, for developing applications, only the Clean distribution from the Clean programming language website https://clean.cs.ru.nl/ and its associated libraries are used.

The Eastwood language server is compatible with all Clean projects, regardless of whether Clean was installed via Nitrile or directly from the Clean website https://clean.cs.ru.nl/. For compiling the project, the `clm` command-line tool is used. If your project includes a project file, you can also compile it using the cpm command-line tool.

Please note that the devcontainer is built specifically for the `x64` architecture. Nevertheless, it works seamlessly on Mac and Windows machines with the `ARM64` architecture thanks to Docker Desktop’s support for `QEMU` emulation for `ARM64`.


## Build without Docker for different platforms

For Linux `x86`, Windows `x64` and Macos `x64` you can compile the `x64` binary with the
clean compiler for that platform.  

Clean only has a compiler for the `ARM64` architecture for the linux platform.
For linux `ARM64` you can compile a native binary using `ARM64` Clean compiler for linux. 
If your project compiles a static binary then the binary compiled on a `x64` Mac
also runs fine on a `ARM64` Mac using Rosetta emulation for `x64`, and the binary compile
on a `x64` Windows runs fine on a Windows `ARM64` using `x64` emulation. 

## VSCode Development Environment Installation Guide

This project is meant to be used through a development environment which can be setup using Docker.

The development environment allows to develop Clean applications on Linux, macOS or Windows.

The installation guide is based on [the official documentation](https://code.visualstudio.com/docs/remote/containers).

### Prerequisites

- Windows: Docker Desktop 2.0+ on Windows 10 Pro/Enterprise. Windows 10 Home (2004+) requires Docker Desktop 2.3+ and the WSL 2 back-end. (Docker Toolbox is not supported. Windows container images are not supported.)
- macOS: Docker Desktop 2.0+.
- Linux: Docker CE/EE 18.06+ and Docker Compose 1.21+. (The Ubuntu snap package is not supported.)

### Linux/macOS

1. Install docker through your package manager or by other means.
   Note that the Ubuntu snap package is not supported. For macOS, tick the "Enable VirtioFS accelerating directory sharing" checkbox under Preferences > Experimental features.

2. Install VSCode if this has not already been done, either through your package manager or by other means.
   Note that using FOSS variants of VSCode (E.g: VSCodium) does not currently work.

3. Install the `Dev Containers` and `Docker` `VSCode` extensions, both are offered by Microsoft.

4. Clone the project using

   `git clone https://github.com/harcokuppens/clean-clm-helloworld.git` 

   or the SSH equivalent

   `git clone git@github.com:harcokuppens/clean-clm-helloworld.git`

   Afterwards, open the root directory of the repository in VSCode using the command

   `code PATH_TO_ROOT_OF_CLONED_REPOSITORY`

5. A message should pop up offering to open the repository within a development container, do so.

6. Open the root folder of the clean-clm-helloworld repository within a devcontainer terminal if it is not already open, using the command:

   `cd clean-clm-helloworld`

7. After the development container is built,
   verify that everything is working by opening a terminal within VSCode and running:

	`./build.bash`

8. Afterwards, the example executable can be run by running `./bin/HelloWorld` within the terminal.

9. If anything does not work as expected, it is recommended to rebuild the container, click the "Dev container" button in the bottom left of VSCode and select "Rebuild container".

10. It is recommended to turn on the autosave feature for VSCode if it is not enabled already.

    Ticking `File -> Autosave` in the VSCode menu enables the feature.

### Windows

#### Prerequisites
It is necessary to enable virtualization and data execution prevention in the BIOS of your computer.

Docker will provide errors notifying you that this should be done in case these features are not enabled already.

#### Installing WSL

1. Open Start
2. Windows Search (Windows key + Q) for "Turn Windows features on or off" and click the search result.
3. Check the “Windows Subsystem for Linux” option that is listed within the program
   that opens after clicking the search result, if it is already enabled, do nothing.
4. Afterwards, open powershell and perform the following command:

   `wsl --install -d ubuntu`

#### Installing docker

1. [Download Docker Desktop for Windows](https://www.docker.com/products/docker-desktop) and go through the installation procedure.

2. Enable WSL integration in the settings of Docker Desktop under the general tab if it is not enabled.

#### Configuring VSCode

1. Install VSCode if this has not already been done, make sure you are using the latest version of VSCode.

2. Install the `Dev Containers` and `WSL` VSCode extensions, both are offered by Microsoft.

3. Open a powershell terminal and perform the `wsl` command, now a linux terminal will open. Afterwards, you can `cd ~` or change the directory to wherever you want to clone the project in. It is very important that this directory is located
under the home (`~`) directory.

4. Clone the project by performing the following command:

   `git clone https://github.com/harcokuppens/clean-clm-helloworld.git` 

   or the SSH equivalent

   `git clone git@github.com:harcokuppens/clean-clm-helloworld.git`

   in the wsl terminal.

5. Run `code clean-clm-helloworld` in the linux terminal to open the repository in VSCode.

6. A message should pop up offering to open the repository within a development container, do so.

6. Open the root folder of the clean-clm-helloworld repository within a devcontainer terminal if it is not already open, using the command:

   `cd clean-clm-helloworld`

8. After the development container is built,
   verify that everything is working by opening a terminal within VSCode and running:

   `./build.bash`

9. Afterwards, the example executable can be ran by executing `./bin/HelloWorld` within the VSCode terminal.

10. If anything does not work as expected, it is recommended to rebuild the container, click the "Dev container" button in the bottom left of VSCode and select "Rebuild container".

11. It is recommended to turn on the autosave feature for VSCode if it is not enabled already.

    Ticking `File -> Autosave` in the VSCode menu enables the feature.

## License
The project is licensed under the BSD-2-Clause license.
