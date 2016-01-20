#! /bin/sh

#the only case where it shouldn't run is if there is an api key present but it's not rebuilding.
if [ ! -z "$TRAVIS_TAG" -a "$TRAVIS_TAG" != " " ];
then
    if ! [ -z "${GH_TOKEN+x}" ];
    then
        if [ -z "${REBUILDING+x}" ];
        then exit 0
        fi
    else
        if ! [ -z "${ASSET_TOKEN+x}" ];
        then
            if [ -z "${REBUILDING+x}" ];
            then exit 0
            fi
        fi
    fi
fi

project="${TRAVIS_REPO_SLUG##*/}"
package=$project.unitypackage

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Setting up project directory; ------------------------------------------------------------------------------------------"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
mkdir ./Project
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
 -batchmode \
 -nographics \
 -silent-crashes \
 -logFile ./CI/unityProject.log \
 -createProject ./Project \
 -quit
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo 'Project Log; -----------------------------------------------------------------------------------------------------------'
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
cat ./CI/unityProject.log
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Moving files into temporary project; -----------------------------------------------------------------------------------"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
mkdir -p ./Project/Assets/$project
find ./* \
 ! -path '*/\.*' \
 ! -path "./Project/*" \
 ! -name "Project" \
 ! -path "./CI/*" \
 ! -name "CI" \
 ! -name ".gitignore" \
 -exec cp -v {} ./Project/Assets/$project/ \;

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Attempting to package $project;"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
/Applications/Unity/Unity.app/Contents/MacOS/Unity \
 -batchmode \
 -nographics \
 -silent-crashes \
 -logFile ./CI/unityPackage.log \
 -projectPath "$PWD"/Project \
 -exportPackage Assets/$project $package \
 -quit

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo 'Packaging Log; ---------------------------------------------------------------------------------------------------------'
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
cat ./CI/unityPackage.log
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------

#The package is exported to ./Project/$package
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo "Checking package exists; -----------------------------------------------------------------------------------------------"
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
file=./Project/$package

if [ -e $file ];
then
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	echo "Package exported successfully: $file"
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	exit 0
else
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	echo "Package not exported. Aborting.----------------------------------------------------------------------------------------------"
    printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
	exit 1
fi
