#!/bin/bash

# stop on error
set -e

OPEN_XCODE=$1

function main () {
  remove_cache
  npm_install
  pod_install

  build_web_app
  sync_ios_files

  if [ ! -z "$OPEN_XCODE" ]; then
    open_xcode
  else
    deploy_to_iphone
  fi
}

########
function remove_cache () {
  rm -rf ./.cache/*
}

function npm_install () {
  echo -e "\n* Install npm packages"
  yarn
}

function pod_install () {
  echo -e "\n* Install iOS pods"
  (
    cd ./ios/App
    pod install
  )
}

function build_web_app () {
  echo -e "\n* Build web app"

  NODE_ENV=production parcel build --no-source-maps \
                                   --out-dir ./.cache/_web_build/ \
                                   ./src/index.html
}

function sync_ios_files () {
  echo -e "\n* Copy app files to iOS project"

  cap copy ios
}

function open_xcode () {
  echo -e "\n* Open Xcode"

  cap open ios
}

function deploy_to_iphone () {
  echo -e "\n* Deploy to iphone"

  xcrun xcodebuild \
    -workspace "./ios/App/App.xcworkspace" \
    -scheme "App" \
    -archivePath "./.cache/_ios_build.xcarchive" \
    -derivedDataPath "./.cache/_ios_build_derivedData" \
    -configuration "Debug" \
    archive

  ios-deploy --bundle './.cache/_ios_build.xcarchive/Products/Applications/App.app'
}


# go!
main
