implementation module CustomFile;

import StdFile,StdMisc,StdBool,StdString;

file_open_write :: !{#Char} *a -> (*File,*a) | FileSystem a;
file_open_write  filename  w
    | filename == "-"
           = stdio w;
	# (ok,file,w) = fopen filename FWriteText w;
	| not ok
		= abort ("Could not open file for writing: "+++filename);
	= (file,w);

file_open_read :: !{#Char} *a -> (*File,*a) | FileSystem a;
file_open_read  filename  w
    | filename == "-" 
           = stdio w;
	# (ok,file,w) = fopen filename FReadData w;
	| not ok
		= abort ("Could not open file for reading: "+++filename);
	= (file,w);

file_close :: *File *a -> *a | FileSystem a;
file_close  file  w
	# (ok,w) = fclose file w;
	| not ok
		= abort ("Error closing file");
	= w; 

file_flush :: *File -> *File;
file_flush  file
	# (ok,file) = fflush file;
	| not ok
		= abort ("Error flushing file");
	= file;

// file_flush :: *File -> Bool;
// file_flush  file
// 	# (ok,w) = fflush file;
// 	| not ok
// 		= abort ("Error flushing file");
// 	= ok;
