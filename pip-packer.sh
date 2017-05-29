#!/bin/sh

## Not the best packer/helper script but it does the job
## It packs the the files into a tar with the right folder structure
## It also cleans any temporary files and even the tar file as long as the files haven't been moved or renamed
## It basically deletes the file which it built, so if there is any file that has the names of the files this script created, it WILL be deleted if cleaning using this scipt, so beware!


if [ "$#" -eq "0" -o "$1" == "--build" -o "$1" == "-b" ]
then
	if [ -f setup.py ]
	then
#		python setup.py bdist_wheel --universal #builds the pip package. This is the recommended method I think. If using Jenkins pipeline or shell where wheel is not install. Then use the below command
#		python setup.py bdist
		python setup.py sdist
		if [ "$?" -eq 0 ]
		then
			ls dist/*
			if [ "$?" -eq 0 ]
			then
				# name=$(grep ^Name *.egg-info/PKG-INFO | cut -f 2 -d ':' |tr -d " ")	#retrieves the name of the package
# 				version=$(grep ^Version *.egg-info/PKG-INFO | cut -f 2 -d ':' |tr -d " ")	#retrieves th version of the package
# 				#creates the tar file after creating relevant files
# 				mkdir $name-$version
# 				cp -rf $name setup.py *.egg-info *.egg-info/PKG-INFO $name-$version/
# 	
# 				#	not sure how to generate setup.cfg
# 				#	but for now:
# 				printf "[egg_info]\ntag_build = 0\ntag_date = 0\ntag_svn_revision = 0">$name-$version/setup.cfg
# 
# 				tar -zcvf $name-$version.tar.gz $name-$version/
# 				rm -rf $name-$version/
				cp dist/* .
				rm -rf dist
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
	if [ -f setup.py ]
	then
		name=$(grep ^Name *.egg-info/PKG-INFO | cut -f 2 -d ':' |tr -d " ")	#retrieves the name of the package
		version=$(grep ^Version *.egg-info/PKG-INFO | cut -f 2 -d ':' |tr -d " ")	#retrieves th version of the package
		if [ -f $name-$version.tar.gz ]
		then
			rm -rf $name-$version.tar.gz
		else
			echo "$name-$version.tar.gz doesn't exist in this directory!"
		fi
	else
		echo "setup.py doesn't exist!"
	fi
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
