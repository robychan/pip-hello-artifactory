#!/bin/sh

if [ "$#" -eq "0" -o "$1" == "--build" -o "$1" == "-b" ]
then
	if [ -f setup.py ]
	then
		python setup.py bdist_wheel --universal #builds the pip package
		if [ "$?" -eq 0 ]
		then
			if [ -f *.egg-info/PKG-INFO ]
			then
				name=$(cat *.egg-info/PKG-INFO | grep ^Name |cut -f 2 -d ' ') #gets the package name
				version=$(cat *.egg-info/PKG-INFO | grep ^Version |cut -f 2 -d ' ') #gets the package version

				#creates the tar file after creating relevant files
				mkdir $name-$version
				cp -rf $name setup.py *.egg-info *.egg-info/PKG-INFO $name-$version/
	
				#	not sure how to generate setup.cfg
				#	but for now:
				printf "[egg_info]\ntag_build = 0\ntag_date = 0\ntag_svn_revision = 0">$name-$version/setup.cfg

				tar -zcvf $name-$version.tar.gz $name-$version/
				rm -rf $name-$version/
			else
				echo "PKG-INFO doesn't exist in package's egg-info directory"
			fi
		else
			echo "Error building the package: possible errors in setup.py"
		fi
	else
		echo "setup.py doesn't exist!"
	fi
elif [ "$1" == "--clean" -o "$1" == "-c" ]
then
	rm -rf $name-$version.tar.gz
elif [ "$1" == "--help" ]
then
        printf "Usage: bash pip-packer.sh [option]\n"
        printf "Possible options:\n"
        printf " --build \tIt builds the package this is the default option\n"
        printf "\t\tAlternatively -b can be used\n"

        printf " --clean \tIt cleans the latest tar file that was built using this packer\n"
        printf "\t\tAlternatively -c can be used\n"
else
	printf "Usage: bash pip-packer.sh [option]\n"
	printf "Possible options:\n"
	printf " --build \tIt builds the package this is the default option\n"
	printf "\t\tAlternatively -b can be used\n"

	printf " --clean \tItcleans the latest tar file that was built using this packer\n"
        printf "\t\tAlternatively -c can be used\n"
fi
