implementation module CustomEvalAbort;

import StdMisc,StdFile;


// when calling use it forces evaluation of x using  helper which is evaluated later
// notes:
//  - the first argument (helper) is lazy and gets evaluated later
//  - the second argument (x) is strict and must be evaluated before calling this function!
//  - the 'use' function returns 'helper' which then does not need to be evaluated directly,
//       and clean being a lazy language then does evaluate it later
use :: .a !.b -> .a;
use helper x = helper;

// operator to force evaluation of x using  helper which is evaluated later
//  eg. # c = a <--- b;      force evaluation of b when evaluating operator expression; c gets value of a, which gets evaluated later
(<---) infix 0 :: .a !.b -> .a;
(<---) value x
	=	use value x;

// abort with exit code and print msg to stderr
errorAbort :: {#Char} -> .a;
errorAbort msg
  	# stderr = stderr <<< msg <<< "\n";    // print msg to stderr
    = abort "" <--- stderr;  // abort with exit code and force eval of stderr

