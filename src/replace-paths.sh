#!/bin/bash
trap "exit" INT

# $1: $dist
# $2: $filename

case $1 in
	arch)
		echo "path script: arch"
		sed -i 's/000-x64unix-000/\/usr\/lib\/wine\/x86_64-unix/' $2
		#echo p1
		sed -i "s/000-x64windows-000/\/usr\/lib\/wine\/x86_64-windows/" $2
		#echo p2
		sed -i "s/000-x32unix-000/\/usr\/lib32\/wine\/i386-unix/" $2
		#echo p3
		sed -i "s/000-x32windows-000/\/usr\/lib32\/wine\/i386-windows/" $2
		;;
	deb)
		echo "path script: debian"
		sed -i 's/000-x64unix-000/\/usr\/lib\/x86_64-linux-gnu\/wine/' $2
		#echo p1
		sed -i "s/000-x64windows-000/\/usr\/lib\/x86_64-linux-gnu\/wine/" $2
		#echo p2
		sed -i "s/000-x32unix-000/\/usr\/lib\/i386-linux-gnu\/wine/" $2
		#echo p3
		sed -i "s/000-x32windows-000/\/usr\/lib\/i386-linux-gnu\/wine/" $2
	;;
	*)
		echo "error: could not find out."
		exit 2
		;;
esac

exit 0
