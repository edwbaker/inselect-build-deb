#!/bin/sh

#Prep
#####
#Inselect directory containing all build files in same directory as this script 
cd inselect

#Change version in DEBIAN/control and elsewhere
cp ../conf/control DEBIAN
echo "Version: $1\n" >> DEBIAN/control
cp ../conf/inselect.desktop usr/share/applications/
echo "Version=$1;" >> usr/share/applications/inselect.desktop

cd usr/share
#Get Inselect from GitHub
sudo git clone https://github.com/NaturalHistoryMuseum/inselect.git

cd inselect
git checkout v$1
cd ..

cd ../..

#Move LICENSE.md to copyright
sudo mv usr/share/inselect/LICENSE.md usr/share/doc/inselect/copyright

#Zip the changelog
cd usr/share/doc/inselect
gzip -9n changelog
cd ../../../..

#Remove git files
cd usr/share/inselect
sudo rm -rf .git
sudo rm -f .gitignore
cd ../../..

#Get the icon into the right place
cp usr/share/inselect/data/Inselect_Icon_256px.png usr/share/pixmaps/inselect-icon.png

#Build
######
cd ..
dpkg -b inselect inselect-$1.deb
lintian inselect-$1.deb


#Cleanup
########
cd inselect

#remove downloaded copy of Inselect
rm -rf usr/share/inselect

#remove generated DEBIAN/control and others
rm DEBIAN/control
rm usr/share/applications/inselect.desktop
rm usr/share/pixmaps/inselect-icon.png

#unzip changelog
cd usr/share/doc/inselect
gzip -d changelog.gz
cd ../../../..
