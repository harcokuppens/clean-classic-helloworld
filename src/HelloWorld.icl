module HelloWorld;

import StdEnv,ArgEnv;

import StdMisc,StdFile;
import CustomEvalAbort;
import CustomFileConsole;

write_usage file
    # file = file <<<
"usage: HelloWorld  NAME"  <<<
"\n";
    = file;

Start :: !*World  -> *World;
Start w
    // get commandline arguments
    # argv = getCommandLine;
    // print usage message if no single argument given
    | size argv  <> 2
        # stderr = write_usage stderr;
        = abort "" <--- stderr;

    // cmdline arguments handling
    # name = argv.[1];
    # stderr = stderr <<< "Hello " <<<  name <<< "\n";
    // we must close stderr to get it printed
    # w = file_close  stderr  w;
    = w;
