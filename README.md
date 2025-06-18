# HelloWorld Clean console application build using the 'classic' Clean distribution

This is a Clean example project that uses a 'classic' Clean distribution from the
Clean programming language website https://clean.cs.ru.nl/. The project includes a
simple “Hello World” console application, but it can also serve as a template for
building other projects.

The project is build with the `cpm` tool (Clean Project Manager). You can also build
the project with the `clm` tool (CLean Make), however the `cpm` tool is preferred
because it uses a project file which gives you fine level control of your project and
which is also used by the Clean IDE (only for Windows).

There is also a similar repository where we build the same HelloWorld Clean code
using a Clean installation using the nitrile tool at:
https://github.com/harcokuppens/clean-nitrile-helloworld.git . The nitrile tool
installs the Clean runtime and its libraries as versioned packages, and also manages
the build of the project.

## HelloWorld program

The HelloWorld program asks for you name and prints 'Hello NAME'. In the example we
also added some debug trace expressions to show how you can debug your programs with
tracing. For details about debugging see the document
[Debugging in Clean](./Debugging.md). To demonstrate tracing in more detail we also
include the alternative Clean program `HelloWorldDebug.icl`.

The source of the Helloworld project is located in the `src/` folder, and it uses
libraries of the the classic Clean distribution installed in the project's `clean/`
subfolder. You do not need to install any packages/dependencies to build the project,
because all libraries are in the `clean/lib/` folder. As developer you can easily
browse and inspect the libraries there within your project folder.

To build the project you only have to run:

```bash
$ cpm HelloWorld.prj
```

and then the result will be build in the project's `bin/` folder which you then can
execute directly:

```bash
$ ./bin/HelloWorld
usage: HelloWorld  NAME
$ ./bin/HelloWorld You
("DEBUG:1: name", "You")
Hello You
("DEBUG:2: argv",{"./bin/HelloWorld","You"})
65536
```

To simplify building and cleaning up the project we use some bash helpers scripts:

```bash
./cleanup.bash             # cleans up the project build
./cleanup.bash all         # cleans up the project build, and the Clean installation in the `clean/` folder
./install-clean.bash       # (re)installs the Clean installation in the `clean/` folder
```

The `./cleanup.bash all` is convenient when you stop working on the project to reduce
it to only what is really necessary. For example removing the `clean/` folder saves
disk space, and with the `./install-clean.bash` it can later easily be reinstalled.

## Project file

The best way to configure and build your project is by using project files with
either `cpm` or
[the Clean IDE on Windows](doc/2001_UserManual_Clean_IDE_for_Windows.pdf).

To start your project you first have to create a main module file in the `src/`
folder. Then you can create a project file using the command:

```bash
$ ./createProject.bash -s src/WrapDebug/ -l Platform -l ArgEnv HelloWorld
```

Once we have a project file we can build the project

```bash
$ # build
$ cpm HelloWorld.prj
$ # run
$ ./bin/HelloWorld
usage: HelloWorld  NAME
```

The project file initially contains only Global and MainModule settings. When you
compile the project with the project manager then ProjectModules settings are added
containing settings for each module needed to build the project. Using the project
file we can the apply settings specific for a module.

It is best practice to commit the initial project file to git, and then never update
it again in git, unless you make changes to the Global and MainModule settings which
are really required. Most of the time we only make changes in the projects settings
for debugging purposes, which we do not need to be committed. So after first creation
of the project file and after committing it to git, you best can run:

```bash
git update-index --assume-unchanged HelloWorld.prj
```

then git will ignore all future changes. For an occusional change you have to undo
this setting commit a change and apply this setting again:

```bash
git update-index --no-assume-unchanged
git add HelloWorld.prj
git commit -m "My new changes to HelloWorld.prj"
git update-index --assume-unchanged HelloWorld.prj
```

Using a text editor we can easily change project settings in this project file. Most
values are either a boolean 'True' or 'False', or an integer. Only for two
configuration files you need to know the possible values it can have:

- the field 'Application -> Output -> Output' can have values:
  - BasicValuesOnly - Show only basic values without constructors.
  - NoReturnType - Disable displaying the result of the application.
  - NoConsole - No console (output window) for the program will be provided and the
    result of the Start function will not be displayed
  - ShowConstructors - Show values with constructors.
- the field 'Application -> Output -> Module -> Compiler -> ListTypes' can have
  values:
  - NoTypes - No type or strictness information is displayed
  - InferredTypes - Listing only the inferred types. Strictness information is not
    displayed.
  - StrictExportTypes - The types of functions that are exported are displayed
    including inferred strictness information, but only when the type in the
    definition module does not contain the same strictness information as was found
    by the strictness analyser. This way it is easy to check for all functions if all
    strictness information is exported.
  - AllTypes - The types of all functions including strictness information are
    displayed.

You can also edit the project easily with a GUI interface on Windows using the Clean
IDE, see the
[User Manual for Clean IDE on Windows](doc/2001_UserManual_Clean_IDE_for_Windows.pdf).

## Try out more examples

In the examples subfolder are some examples from the classic Clean distribution which
can also be tried out instead of `HelloWorld.icl`.

The examples come with a project file ( `.prj` ) next to its source file ( `.icl`).
For easy building these project files build the executable next to its source and
project file:

```bash
# build
cpm examples/SmallExamples/fsieve.prj
# run
./examples/SmallExamples/fsieve
```

You can also copy the example to the `src/` folder, and create a new project for it
which uses the same project layout as the `HelloWorld` project:

```
# our project layout convention requires source files in the src/ folder
cp examples/SmallExamples/fsieve.icl src/
# create sieve.prj
./createProject.bash  fsieve
# build
cpm fsieve.prj
# run
./bin/fsieve
```

The new `sieve.prj` file has its source in the `src/` folder and builds it result in
the `bin/` folder.

Now you have both `HelloWorld.prj` and `fsieve.prj` project files. This shows that
you can have multiple project files next to each other in the root of your workspace
folder sharing the `src/` and `clean/` folders.

## Clean documentation

- For an introduction to functional programming in Clean read the book
  [Functional Programming in Clean](doc/2002_Functional_Programming_in_Clean.pdf)
- The ideas behind Clean and its implementation on sequential and parallel machine
  architectures are explained in detail in the following textbook:
  [Functional Programming and Parallel Graph Rewriting](doc/1993_Functional_Programming_and_Parallel_Graph_Rewriting.pdf)
- A description of the syntax and semantics of Clean can be found in the
  [Clean Language Report](doc/2021_CleanLanguageReport_Version3.0.pdf). The latest
  version can be found online at https://cloogle.org/doc/ .
- [Clean for Haskell programmers](2024_Clean_for_Haskell_Programmers.pdf)
- [A Concise Guide to Clean StdEnv (standard library)](doc/2018_ConciseGuideToClean3xStdEnv.pdf)
- Website with
  [Guides and hints to work with the Clean](https://top-software.gitlab.io/clean-lang/)
  \
  This website contains a collection of guides and hints to work with the Clean programming
  language.
- [User Manual for Clean IDE on Windows](doc/2001_UserManual_Clean_IDE_for_Windows.pdf)

## Setup Development environment

### Easy develop in DevContainer

This project can be used using a devcontainer which automatically setups a
development environment with a 'classic' clean installation from
https://clean.cs.ru.nl/ for you in a docker container from which you can directly
start developing. For installation instructions see the
[VSCode Development Environment Installation Guide](./DevContainer.md) Please note
that the devcontainer is built specifically for the `x64` architecture. Nevertheless,
it works seamlessly on Mac and Windows machines with the `ARM64` architecture thanks
to Docker Desktop’s support for `QEMU` emulation for `ARM64`.

We advice to use the vscode devcontainer because then you can

- quickly start developing,
- use all the features of the Eastwood language server in vscode, and
- you can run it on all platforms.

### Develop on local machine

You offcourse can use this project also direclty on your local machine by installing
Clean from https://clean.cs.ru.nl/ yourself.

- install Clean from https://clean.cs.ru.nl/ into the `clean/` subfolder of your
  project.\
  Using the `./install-clean.bash` script you can automaticaly (re)install clean in your
  project.
- set the `clean/` subfolder as value for the`CLEAN_HOME` environment variable in
  your bash shell
- add the path where `cpm`, and or `clm` are located to the `PATH` environment
  variable in your bash shell

## Build project without project file using `clm`

`Clm` is the commandline build tool for Clean projects without needing a Clean
project file used by the Clean IDE. The `clm` tool is only available on Linux and
MacOS, but not on Windows.

To simplify building and cleaning up the project we use some bash helpers scripts
written around `clm`. To build the `HelloWorld` project you have to run the following
commands:

    ./build.bash               # builds the Clean project. Configure the build using the
                               # variables $projects, $libs and $srcDirs in this script.
    ./cleanup.bash             # cleans up the project build
    ./cleanup.bash all         # cleans up the project build, and the Clean installation in the `clean/` folder
    ./install-clean.bash       # (re)installs the Clean installation in the `clean/` folder

The `./build.bash` command prints the `clm` command used to build the project. This
command can be convenient to automate the build in an automated build setting.

Note that the Clean compiler and its libraries are installed using a 'classic' clean
distribution from the Clean programming language website https://clean.cs.ru.nl/ into
the project's `clean/` subfolder.

When using a Clean installation using the nitrile tool, then the `nitrile build`
command also uses `clm` in the background to build the project. In the classic Clean
distribution the `clm` tool is not available on Windows. The nitrile tool ported
`clm` tool to windows to also support builds on Windows.

To build any of the programs in the examples subfolder with `clm` you need to copy
the `.icl` file from the examples folder to the `src` folder, and adapt the
`projects` variable in the `build.bash` file.

## Installation details

### The Eastwood language server for vscode

The project provides a ready-to-use environment for developing Clean applications
using Docker development container via a devcontainer.

The development container (devcontainer) uses Nitrile to install the Eastwood
language server. However, for developing applications, only the Clean distribution
from the Clean programming language website https://clean.cs.ru.nl/ and its
associated libraries are used.

The Eastwood language server is compatible with all Clean projects, regardless of
whether Clean was installed via Nitrile or directly from the Clean website
https://clean.cs.ru.nl/. For compiling the project, the `clm` command-line tool is
used. If your project includes a project file, you can also compile it using the
`cpm` command-line tool. The Eastwood language server provides

- autocomplete,
- error-checking (diagnostics), linting
- jump-to-definition or declaration

The HelloWorld project comes with an already configure `Eastwood.yml` configuration
file, which specifies all libraries in the clean distribution in `clean/lib/` so they
are available in the Eastwood language server in vscode.

Please note that the devcontainer is build specifically for the `x64` architecture.
Nevertheless, it works seamlessly on Mac and Windows machines with the `ARM64`
architecture thanks to Docker Desktop’s support for `QEMU` emulation for `ARM64`.

### Platforms the Clean compiler supports

On all platforms you can run Clean within the vscode devcontainer which runs `X64`
Clean on linux. However you can also install Clean locally on your system and use it
directly there.

We advice to use the vscode devcontainer because then you can also use all the
features of the Eastwood language server in vscode.

Per architecture we specify which operating systems support Clean:

#### X64

For Linux `x64`, Windows `x64` and Macos `x64` you can compile the `x64` binary with
the clean compiler for that platform.

#### ARM

Clean only has a compiler for the `ARM64` architecture for the linux platform. For
linux `ARM64` you can compile a native binary using `ARM64` Clean compiler for linux.

However `x64` clean builds can be run on none-supported `ARM64` platforms using
emulation. If your project compiles a static binary then

- the binary compiled on a `x64` Mac also runs fine on a `ARM64` Mac using Rosetta
  emulation for `x64`, and
- the binary compiled on a `x64` Windows also runs fine on a Windows `ARM64` using
  `x64` emulation.

On a `ARM64` Mac using Rosetta emulation for `x64` you can install the Clean compiler
for `x64` Macs, and then compile Clean programs for `x64` which then also run on that
Mac using Rosetta emulation for `x64`. However you need to patch the 'classic' Clean
installation for `x64` Macs to get the installation working correctly on a `ARM64`
Mac. In the folder [`arm-mac/`](arm-mac/) we provide the installation instructions
for installing the Clean compiler for a `x64` Mac on a `ARM64` Mac.

### The `createProject.bash` command

With the `createProject.bash` command we can create project files for Clean projects.
It supports setting up a project using an predefined Clean environment where you can
extend it with libraries. You can easily specify more source folders then the default
`src/` folder, and you can specify a different name for the main module and
executable then the project name. By running the `createProject.bash` command with
the `--help` option it display in detail how we can use it:

```bash
$ ./createProject.bash  --help
Usage: createProjectFile [-h] [-e ENVIRONMENT] [-s SOURCE] [-l LIB] [-m MODULE] [-o EXEC_NAME ] PROJECTNAME

Description:
  This script creates a project file based on the specified options.

Arguments:
  PROJECTNAME            The name of the project to be created. This argument is mandatory.

Options:
  -e ENVIRONMENT         Specify the environment for the project.
                         Default: 'StdEnv'.
                         (On Linux, this is typically found in clean/etc/ folder;
                         on Windows, in the Config folder).

  -s SOURCE              Add an extra source folder to the project file.
                         By default, the 'src' folder is always included.
                         This option can be specified multiple times to add several
                         source folders.

  -l LIB                 Add an extra library folder to the project file.
                         These folders are added in addition to any libraries
                         specified within the chosen environment.
                         This option can be specified multiple times to add several
                         library folders.

  -m MODULE              Specify the name of the main module for the project.
                         This module must be located directly in the 'src' directory
                         (e.g., 'src/MyModule.icl').
                         Default: PROJECTNAME.icl (e.g., if PROJECTNAME is 'MyProject',
                         the default module would be 'MyProject.icl').

  -o EXEC_NAME           Specify the name of the executable build by the project in the
                         project's bin directory.
                         Default: PROJECTNAME

  -h, --help             Display this help message and exit.

Note:
  To ensure project folder compatibility across Windows and Linux/macOS,
  both 'lib' and 'Libraries' paths are handled internally where appropriate.
```

## License

The project is licensed under the BSD-2-Clause license.

# old

./install-clean-clm.bash # (re)installs the Clean installation for x64 Linux in the
`clean/` folder

On Windows x64 you can also use the Clean IDE using the project file (
`HelloWorld.prj` ). When using the Clean IDE you do not need the `clean/` subfolder
in your project because the Clean IDE comes with its own Clean installation.

Instead of using `clm` you can also can compile this project with the `cpm`
commandline tool using the project file ( `HelloWorld.prj` ) . However we advice to
use `clm` builds for all other platforms because project files are difficult to edit
by hand, and mainly edited via the Clean IDE.

- build project with `clm` using the command: `./build.bash`
- cleanup project with bash script using the command: ` ./cleanup.bash`
- cleanup both project and clean installation in project: `./cleanup.bash all`
- reinstall clean in project: `./install-clean-clm.bash` \
  By default this installs Clean for X64 Linux, for [other platforms](#platforms-the-clean-compiler-supports)
  you must edit the download url in the script. Note that not all platform/architecture
  combinations are supported.
