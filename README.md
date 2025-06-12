# HelloWorld Clean console application build using  the 'classic' Clean distribution

This is a Clean example project that uses a 'classic' Clean distribution from the Clean programming language website https://clean.cs.ru.nl/ and compiles projects with the `clm` tool, managed through the build.bash script.
The project includes a simple “Hello, World!” console application, but it can also serve as a template for building other projects.

This project can be used using a devcontainer which automatically setups a development environment with a 'classic' clean installation from https://clean.cs.ru.nl/ for you in a docker container from which you can directly start developing. For installation instructions see the
[VSCode Development Environment Installation Guide](./DevContainer.md) Please note that the devcontainer is built specifically for the `x64` architecture. Nevertheless, it works seamlessly on Mac and Windows machines with the `ARM64` architecture thanks to Docker Desktop’s support for `QEMU` emulation for `ARM64`.


However you offcourse can use this project on your local machine by installing Clean from https://clean.cs.ru.nl/ yourself.
* install Clean from https://clean.cs.ru.nl/ .
* build project with `clm` using the command:  `./build.bash`
* cleanup project with bash script using the command: ` ./cleanup.bash`
* cleanup both project and clean installation in project: `./cleanup.bash all`
* reinstall clean in project: `./install-clean-clm.bash` \
  By default this installs Clean for X64 Linux, for [other platforms](#platforms-the-clean-compiler-supports) you must the download url in the script.

If you add a  a project file ( `.prj` ) to this project, which is used by the Clean IDE,
you can also can compile this project with the `cpm` commandline tool instead of using `clm`. 

There is also a similar repository where we build the same HelloWorld Clean code using a Clean installation using the nitrile tool at: https://github.com/harcokuppens/clean-nitrile-helloworld.git . The nitrile tool  installs the  Clean runtime and its libraries as versioned packages, and also manages the  build of the project. 


## HelloWorld program

The HelloWorld program asks for you name and prints 'Hello NAME'. In the example we
also added some debug trace expressions to show how you can debug your programs with
tracing. For details about debugging see the document
[Debugging in Clean](./Debugging.md). To demonstrate tracing in more detail we also
include the alternative Clean program `HelloWorldDebug.icl`.

The Helloworld project uses some libraries of the
many of the standard libraries coming with the classic Clean distribution in the `clean/` folder. 
You do not need to install any packages/dependencies to build the project, because all libraries
are in  the `clean/lib/` folder. As developer you can easily browse and inspect the libraries 
there within your project folder.

## Build project with clm

`Clm` is the commandline build tool for Clean projects without needing a Clean project file used by the Clean IDE.

To simplify building and cleaning up the project we use some bash helpers scripts written around `clm`.
 To build the
`HelloWorld` project you have to run the following commands:

    ./build.bash               # builds the Clean project. Configure the build using the 
                               # variables $projects, $libs and $srcDirs in this script.
    ./cleanup.bash             # cleans up the project build 
    ./cleanup.bash all         # cleans up the project build, and the Clean installation in the `clean/` folder
    ./install-clean-clm.bash   # (re)installs the Clean installation for x64 Linux in the `clean/` folder

Note that  the Clean compiler and its libraries  are installed  using a 'classic' clean distribution from the Clean programming language website https://clean.cs.ru.nl/ into the project`s `clean/` subfolder. 

## Other examples

In the examples subfolder are some examples from the classic Clean distribution which
can also be tried out instead of `HelloWorld.icl`. You need to copy the `.icl` file
from the examples folder to the `src` folder, and adapt the `projects` variable in the
`build.bash` file.  

The examples also come with a project file ( `.prj` ) which is used by the Clean IDE. 
However using the `cpm` command-line tool you can also can compile these projects instead of using `clm`. 

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
- Website with [Guides and hints to work with the Clean](https://top-software.gitlab.io/clean-lang/) \
This website contains a collection of guides and hints to work with the Clean
programming language.

## Installation details

### The Eastwood language server for vscode

The project provides a ready-to-use environment for developing Clean applications using Docker development container via a devcontainer.

The development container (devcontainer) uses Nitrile to install the Eastwood language server. However, for developing applications, only the Clean distribution from the Clean programming language website https://clean.cs.ru.nl/ and its associated libraries are used.

The Eastwood language server is compatible with all Clean projects, regardless of whether Clean was installed via Nitrile or directly from the Clean website https://clean.cs.ru.nl/. For compiling the project, the `clm` command-line tool is used. If your project includes a project file, you can also compile it using the `cpm` command-line tool. The Eastwood language server provides 
* autocomplete,                               
* error-checking (diagnostics),  linting             
* jump-to-definition or declaration
             

The HelloWorld project comes with an already configure `Eastwood.yml` configuration file, which specifies all libraries in the
clean distribution in `clean/lib/` so they are available in the Eastwood language server in vscode. 

Please note that the devcontainer is built specifically for the `x64` architecture. Nevertheless, it works seamlessly on Mac and Windows machines with the `ARM64` architecture thanks to Docker Desktop’s support for `QEMU` emulation for `ARM64`.


### Platforms the Clean compiler supports

On all platforms you can run Clean within the vscode devcontainer which runs `X64` Clean on linux. However you can also install Clean locally on your system and use it directly there. 

We advice to use this devcontainer  because then you can also use all the features of the  Eastwood language server in vscode.

Per architecture we specify which operating systems support Clean:

#### X64 

For Linux `x64`, Windows `x64` and Macos `x64` you can compile the `x64` binary with the
clean compiler for that platform.  

#### ARM 

Clean only has a compiler for the `ARM64` architecture for the linux platform.
For linux `ARM64` you can compile a native binary using `ARM64` Clean compiler for linux. 

However `x64` clean builds can be run on none-supported `ARM64` platforms using emulation. If your project compiles a static binary then
* the binary compiled on a `x64` Mac also runs fine on a `ARM64` Mac using Rosetta emulation for `x64`, and 
* the binary compiled on a `x64` Windows also runs fine on a Windows `ARM64` using `x64` emulation. 

On  a `ARM64` Mac using Rosetta emulation for `x64` you can install the Clean compiler for `x64` Macs,
and then compile Clean programs for `x64` which then also run on that Mac using Rosetta emulation for `x64`.
However you need to patch the 'classic' Clean installation for `x64` Macs to get the installation working
correctly on a `ARM64` Mac. In the folder [`arm-mac/`](arm-mac/) we provide the installation instructions for installing the Clean 
compiler for a `x64` Mac on a `ARM64` Mac.

## License
The project is licensed under the BSD-2-Clause license.
