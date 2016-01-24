#! /bin/sh

if [ "$wait_to_deploy" == "True" ];
then
    echo "------------------------------------------------------------------------------------------------------------------------"
    echo "Skipping Unity install. ------------------------------------------------------------------------------------------------"
    echo "------------------------------------------------------------------------------------------------------------------------"
    exit 0
fi

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo 'Downloading Unity; -----------------------------------------------------------------------------------------------------'
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
curl -o CI/Unity.pkg http://download.unity3d.com/download_unity/f3d16a1fa2dd/MacEditorInstaller/Unity-5.2.3f1.pkg

printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
echo 'Installing Unity; ------------------------------------------------------------------------------------------------------'
printf '%s\n' ------------------------------------------------------------------------------------------------------------------------
if [ "$verbose" == "True" ];
then
    sudo installer -dumplog -package CI/Unity.pkg -target /
else
    sudo installer -package CI/Unity.pkg -target /
fi
