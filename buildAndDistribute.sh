#!/bin/sh

if [ "$1" = "Debug" ]; then
  CONFIGURATION="Debug"
  PROVISIONING_PATH="${HOME}/Library/MobileDevice/Provisioning\ Profiles/345E1F49-53BE-4AC6-9B9D-764E78406C6F.mobileprovision"
else
  echo "\nUsage: ./buildAndDistribute.sh [Debug]\n"
  exit 1
fi

#PING=`which ping`
#function waitForHost
#{
  #reachable=0;
  #while [ $reachable -eq 0 ];
  #do
    #$PING -q -c 1 $1
    #if [ "$?" -eq 0 ];
    #then
      #reachable=1
    #fi
  #done
  #sleep 5
#}

#waitForHost genesixdev.local

#Parameters
SDK="iphoneos"
WORKSPACE_FILE_PATH="WordPress.xcworkspace"
SCHEME_NAME="WordPress"
PRODUCT_NAME="WordPress"
OUT_APP_DIR="appFile"
OUT_IPA_DIR="ipaFile"
DATE=`date +%Y%m%d`
DATE_TIME=`date`
AGV_TOOL=`which agvtool`
VERSION=`$AGV_TOOL mvers -terse1`
IPA_FILE_NAME="$PRODUCT_NAME-$CONFIGURATION-$VERSION-$DATE"
DEVELOPPER_NAME="iPhone Distribution: Tonny Xu"

# This will automatically check and create the folder on genesixdev.local
#REMOTE_FOLDER_MAIN="test -d ~/Sites/$PRODUCT_NAME && echo exists"
#if [[ -z `ssh genesixdev@genesixdev.local "$REMOTE_FOLDER_MAIN"` ]]; then
  #ssh genesixdev@genesixdev.local "mkdir ~/Sites/$PRODUCT_NAME"
#fi
#REMOTE_FOLDER_TARGET="test -d ~/Sites/$PRODUCT_NAME/$PRODUCT_NAME-$CONFIGURATION && echo exists"
#if [[ -z `ssh genesixdev@genesixdev.local "$REMOTE_FOLDER_TARGET"` ]]; then
  #ssh genesixdev@genesixdev.local "mkdir ~/Sites/$PRODUCT_NAME/$PRODUCT_NAME-$CONFIGURATION"
#fi

if [ ! -d ${OUT_IPA_DIR} ]; then
  mkdir "${OUT_IPA_DIR}"
fi

echo "Cleaning $WORKSPACE_FILE_PATH now..."
xcodebuild clean -workspace "${WORKSPACE_FILE_PATH}" -scheme "${SCHEME_NAME}" > /dev/null
echo "Building $WORKSPACE_FILE_PATH now..."
xcodebuild -workspace "${WORKSPACE_FILE_PATH}" -sdk "${SDK}" -configuration "${CONFIGURATION}" -scheme "${SCHEME_NAME}" install DSTROOT="${OUT_APP_DIR}" > /dev/null
echo "Archiving $WORKSPACE_FILE_PATH now..."
xcrun -sdk "${SDK}" PackageApplication "${PWD}/$PRODUCT_NAME/${OUT_APP_DIR}/Applications/${SCHEME_NAME}.app" -o "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa" -embed "${PROVISIONING_PATH}" > /dev/null

#scp "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa" "genesixdev@genesixdev.local:~/Sites/$PRODUCT_NAME/${PRODUCT_NAME}-${CONFIGURATION}/"
#SED_COMMAND_INDEX_HTML="sed -e 's/_{product_name}_/${PRODUCT_NAME}/g' -e 's/_{version}_/${VERSION}/g' -e 's/_{configuration}_/${CONFIGURATION}/g' -e 's/_{date}_/${DATE}/g' -e 's/_{date_time}_/${DATE_TIME}/g' BetaInstaller/index.html.template > BetaInstaller/index.html"
#eval ${SED_COMMAND_INDEX_HTML}
#SCP_INDEX_COMMAND="scp BetaInstaller/index.html genesixdev@genesixdev.local:~/Sites/$PRODUCT_NAME/${PRODUCT_NAME}-${CONFIGURATION}/"
#eval ${SCP_INDEX_COMMAND}

#SED_COMMAND_MANIFEST="sed -e 's/_{product_name}_/${PRODUCT_NAME}/g' -e 's/_{version}_/${VERSION}/g' -e 's/_{configuration}_/${CONFIGURATION}/g' -e 's/_{date}_/${DATE}/g' -e 's/_{date_time}_/${DATE_TIME}/g' BetaInstaller/manifest.plist.template > BetaInstaller/manifest.plist"
#eval ${SED_COMMAND_MANIFEST}
#SCP_MANIFEST_COMMAND="scp BetaInstaller/manifest.plist genesixdev@genesixdev.local:~/Sites/$PRODUCT_NAME/${PRODUCT_NAME}-${CONFIGURATION}/"
#eval ${SCP_MANIFEST_COMMAND}
#scp "BetaInstaller/iTunesArtwork.png" "genesixdev@genesixdev.local:~/Sites/$PRODUCT_NAME/${PRODUCT_NAME}-${CONFIGURATION}/"
#[ -f ./afterBuild.personal.sh ] && source "afterBuild.personal.sh" "${PWD}/${OUT_IPA_DIR}/${IPA_FILE_NAME}.ipa"

rm -rf $PWD/$PRODUCT_NAME/${OUT_APP_DIR}
rm -rf ${OUT_IPA_DIR}
rm -rf ${PWD}/build

