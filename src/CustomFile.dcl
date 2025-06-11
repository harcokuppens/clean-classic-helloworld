definition module CustomFile;

import StdFile;

file_open_write :: !{#Char} *a -> (*File,*a) | FileSystem a;

file_open_read :: !{#Char} *a -> (*File,*a) | FileSystem a;

file_close :: *File *a -> *a | FileSystem a;

file_flush :: *File -> *File;