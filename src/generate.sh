#!/bin/bash
trap "exit" INT
#echo -1
rm generated/*
for dist in arch deb; do
	for sound in non-pipewire pipewire; do
		for proton in old new; do
			#echo 0
			#echo $dist
			#echo $sound
			#echo $proton
			filename=generated/$dist-$sound-$proton.md
			cp base.md $filename

			#echo 01
			sed -i "s/000-title-000/cat title\/${dist}\/${sound}/e" $filename
			sed -i "s/000-title-note-000/cat title\/${dist}\/note/e" $filename

			#echo 02
			sed -i "s/000-install-part-000/cat install-part\/${dist}\/${sound}/e" $filename #needs fixing

			#echo 03
			sed -i "s/000-install-check-000/cat install-check\/${dist}/e" $filename

			#echo 04
			sed -i "s/000-arch-base-devel-note-000/cat install-wineasio-system\/arch-base-devel-note/e" $filename
			#echo 06
			sed -i "s/000-install-wineasio-system-000/cat install-wineasio-system\/${sound}/e" $filename
			sed -i "s/000-wineasio-source-000/cat install-wineasio-system\/wineasio-source/e" $filename
			sed -i "s/000-wineasio-installed-note-000/cat install-wineasio-system\/wineasio-installed-note/e" $filename

			#echo 07
			sed -i "s/000-install-wineasio-runner-000/cat install-wineasio-runner\/${proton}/e" $filename
			sed -i "s/000-old-000/cat install-wineasio-runner\/old/e" $filename

			#echo 08
			sed -i "s/000-jack-setup-000/cat jack-setup\/${sound}/e" $filename

			#echo 09
			sed -i "s/000-steam-running-required-000/cat steam-running-required\/${sound}/e" $filename

			#echo 10
			sed -i "s/000-pipewire-note-000/cat pipewire-note\/${sound}/e" $filename
			#echo 10.1
			sed -i "s/000-pipewire-bootup-000/cat pipewire-bootup\/${sound}/e" $filename # using "start" gave the following error message (I don't know why): sh: line 1: Save: command not found

			#echo 11
			./replace-paths.sh $dist $filename
			# those lines cause issues, for some reason. Write a seperate script with the lines in it; quick fix.
			##echo 11
			# insert paths
			#sed -i 's/000-x64unix-000/'"`cat paths/$dist-x64unix`"'/' $filename # why does this thing ask for sudo?
			##echo 11.1
			#sed -i "s/000-x64windows-000/cat paths\/${dist}-x64windows/e" $filename
			##echo 11.2
			#sed -i "s/000-x32unix-000/cat paths\/${dist}-x32unix)e" $filename
			##echo 11.3
			#sed -i "s/000-x32windows-000/cat paths\/${dist}-x32windows/e" $filename
			#echo 12
		done
	done
done

#echo 13
echo "missing:"
for file in $(ls generated); do
	echo $file
	cat generated/$file | grep -P "000-"
done
