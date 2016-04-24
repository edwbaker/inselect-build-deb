#!/bin/sh

#Prep
#####
#Inselect directory containing all build files in same directory as this script 
cd inselect

#Change version in DEBIAN/control and elsewhere
cp ../conf/control DEBIAN
echo "Version: $1trusty1" >> DEBIAN/control
cp ../conf/inselect.desktop usr/share/applications/
echo "Version=$1trusty1;" >> usr/share/applications/inselect.desktop

cd usr/share
#Get Inselect from GitHub
sudo git clone https://github.com/NaturalHistoryMuseum/inselect.git

cd inselect
git checkout v$1
cd ..

SIZE=$(du -s inselect | cut -f1)
echo "Installed-Size: $SIZE" >> ../../DEBIAN/control

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
dpkg -b inselect inselect-$1trusty1.deb
lintian inselect-$1trusty1.deb


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
