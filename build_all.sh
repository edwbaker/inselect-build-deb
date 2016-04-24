git checkout master
./inselect2deb.sh $1

git checkout 14.04
./inselect2deb.sh $1

scp *.deb ed@ebaker.me.uk:~

ssh -t ed@ebaker.me.uk "sudo ./add_inselect.sh $1"

rm *.deb
