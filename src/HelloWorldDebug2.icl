module HelloWorld;

import StdEnv;
import ArgEnv;

import StdMisc,StdFile;
import CustomEvalAbort;
import CustomFile;

import CustomDebug;

import StdDebug;

usage_msg ::  {#Char};
usage_msg = "usage: HelloWorld  NAME";


Start :: !*World  -> *World;
Start w
    // get commandline arguments
    # argv = getCommandLine;
    // print usage message to stderr if no argument given
    | size argv  <> 2
        =  errorAbort usage_msg; // does 'error abort' with exit code and print usage message to stderr
        // =  abort usage_msg  // does 'abort' with exit code and print usage message to stdout

    // cmdline arguments handling
    # name = argv.[1];                                                 // trace statements;  prefer using ->> operator because it outputs to stderr, but it does not always works, then you can use  ->>- operator which outputs to stdout
    // open console
    # (console,w) = stdio w                                            ->> ("DEBUG:1: name",name); // last part is trace expression added to the line with the ->> operator which outputs to stderr
    //                                                                                             // print name to stderr here because name is not yet defined on the previous line
    // print hello message to console
    # console = console <<< "Hello " <<< name <<< "\n"                 ->>- ("DEBUG:2: argv",argv); // last part is trace expression added to the line with the ->>- operator which outputs to stdout  (note: ->> does not work with argv)

    // we must close console to get it printed (otherwise compiler think console is not used and optimizes all program code with it away)
    # w = file_close  console  w;
    // we must close stderr to get it printed (otherwise compiler think stderr is not used and optimizes all program code with it away)
    # w = file_close  stderr  w;

	= w; // return world



