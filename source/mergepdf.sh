#!/bin/bash
# mergepdf 
# Copyright (C) 2022, David P. Chassin
#
# Utility to merge multiple PDF files into a single PDF
#
# Depends on pdflatex utility
#

STDOUT=/dev/null
STDERR=/dev/stderr

syntax()
{
	echo "Syntax: $(basename $0) [OPTIONS ...] OUTPUT_PDF INPUT_PDF ..."
	if [ "$1" == "--with-options" ]; then
		echo 'Options:
	-d|--debug   enable debug output
	-q|--quiet   disable error output
	-v|--verbose enable verbose output
For details see https://github.com/dchassin/mergepdf.'
	fi
}

if [ "$(which pdflatex)" == "" ]; then
	echo "$(basename $0): pdflatex is not installed on this system"  >$STDERR
	exit 2
fi

while [ "${1:0:1}" == "-" ]; do
	if [ "$1" == "-h" -o "$1" == "--help" ]; then
		syntax --with-options
		exit 0
	elif [ "$1" == "-v" -o "$1" == "--verbose" ]; then
		STDOUT=/dev/stdout
		shift 1
	elif [ "$1" == "-d" -o "$1" == "--debug" ]; then
		set -x
		STDOUT=/dev/stderr
		shift 1
	elif [ "$1" == "-q" -o "$1" == "--quiet" ]; then
		STDERR=/dev/null
		shift 1
	elif [ "${1:0:1}" == "-" ]; then
		echo "$(basename $0): option '$1' is not recognized" >$STDERR
		shift
	fi
done

if [ $# -lt 2 ]; then
	syntax  >$STDERR
	exit 1
fi

OUT=$1
PDF=$(basename $OUT)
NAME=${PDF/\.pdf/}
DIR=$(cd $(dirname $PDF); pwd)
TMP=$DIR/${NAME/\.pdf/}
mkdir -p $TMP
TEX=${TMP}/$NAME.tex
echo '\documentclass{article}
\usepackage{pdfpages}
\begin{document}' > ${TEX}
shift 1
while [ $# -gt 0 ]; do
	if [ "$1" != "$OUT" ]; then
		FILE="$1"
		echo '\includepdf[pages=-]{'$DIR/${FILE/.pdf/}'}' >> ${TEX}
	fi
	shift 1
done
echo '\end{document}' >> ${TEX}
(cd $TMP; pdflatex ${NAME}.tex  ) 1>$STDOUT 2>$STDERR
mv $PDF $OUT 1>$STDOUT 2>$STDERR
