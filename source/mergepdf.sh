#!/bin/sh
set -x
if [ $# -lt 2 ]; then
	echo "$(basename $0) OUTPUT_PDF INPUT_PDF ..."
	exit 1
fi
OUT=$1
PDF=$(basename $OUT)
NAME=${PDF/\.pdf/}
DIR=$(cd $(dirname $PDF); pwd)
# rm -rf $DIR/*
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
(cd $TMP; pdflatex ${NAME}.tex  ) 1>${TEX/\.tex/.out}
mv $TEX $OUT
# rm -rf $TMP
