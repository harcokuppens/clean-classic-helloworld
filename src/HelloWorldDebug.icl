module HelloWorldDebug;

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

    // write debug message to stderr
    #! stderr = stderr <<< "DEBUG:1: message 1\n";
    // note: The #! construct (a strict let construct) forces evaluation of the defined values independent whether they are being used later or not.
    //       this is useful for debugging, because it forces the evaluation of the new value stderr by forcing the evaluation of the rhs of the assignment

    // write another debug message to stderr
    # stderr = stderr <<< "DEBUG:2: message 2\n";


    // cmdline arguments handling
    // open console
    # name = argv.[1];                                            // trace expressions;  prefer using ->> operator because it outputs to stderr, but it does not always works, then you can use  ->>- operator which outputs to stdout
    # (console,w) = ctrace_n ("DEBUG:3a: name",name)  stdio w       ->> ("DEBUG:3b: name",name); // last part is trace expression added to the line with the ->> operator which outputs to stderr
    //                                                                                           // print name to stderr here because name is not yet defined on the previous line
    # console = console <<< "Hello " <<< name <<< "\n"              ->>- ("DEBUG:4: argv",argv); // last part is trace expression added to the line with the ->>- operator which outputs to stdout  (note: ->> does not work with argv)

    | not (trace_tn  "DEBUG:5: only works on toString values") // => prints msg to stderr ; trace_tn cannot be used with tuples as arguments because tuple is not a toString value
             = undef          // => never reached, but must be there
    | not (ctrace_tn  ("DEBUG:6: name",name)) // => prints msg to stderr
            = undef          // => never reached, but must be there
    | not (print_graph  ("DEBUG:7: argv",argv)) // => prints msg to stdout // note: ctrace_tn does not work with argv
             = undef          // => never reached, but must be there

    # stderr = stderr <<< "DEBUG:8: the name is "  <<< name <<< "\n";

    // we must close console to get it printed (otherwise compiler think console is not used and optimizes all program code with it away)
    # w = file_close  console  w;
    // we must close stderr to get it printed (otherwise compiler think stderr is not used and optimizes all program code with it away)
    # w = file_close  stderr  w;

    | ctrace_tn  ("DEBUG:9: again_name",name)
        = w; // return world


// notice that the debug messages of lines with strict let (#!)  and with trace msg in guard are printed first! (evaluated first)
