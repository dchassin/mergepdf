# mergepdf

A utility to merge PDF files.

## Prerequisite

You must install `pdflatex` on your system and it must be in found the `PATH` environment.  To check, use the command

~~~
% which pdflatex
~~~

If it is not found, you must install it and add it to `PATH` so that `mergepdf` can find it.

## Install

~~~
% git clone https://github.com/dchassin/mergepdf
% cd mergepdf/source
% make install
~~~

## Running

The utility will merge all the PDF files listed in the command line into the first PDF listed. For example

~~~
% mergepdf output.pdf input1.pdf input2.pdf
~~~

will merge `input1.pdf` and `input2.pdf` into the file `output.pdf`.

Note that if you use `*.pdf` the output file will not be included among the input files.
