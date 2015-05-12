#!/bin/bash
echo "Content-type: text/html"
echo ""

OIFS="$IFS"

IFS="${IFS}&"
set $QUERY_STRING
Args="$*"
IFS="$OIFS"

floor=""
for i in $Args ;do
	IFS="${OIFS}="
	set $i
	IFS="${OIFS}"
	case $1 in
		f) floor=$2
		;;
		esac
		done
echo $floor
gpio mode $floor out; gpio write $floor 1; sleep 1;gpio write $floor 0;sleep 1
