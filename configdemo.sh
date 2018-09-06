#!/bin/sh
cd ..
SCRIPTPATH=`pwd -P`
SRCROOT=$SCRIPTPATH/public/XG-SDK-NAMESPACE
DEMOSRCROOT=$SCRIPTPATH/xinge_iOS_demo
productdir=${SRCROOT}/product

if [ ! -d ${productdir} ]; then
	echo "can't find XG SDK, build it first"
	exit 1
else
echo ${productdir}
fi
cd xinge_iOS_demo

rm -rf ./sdk/*
cp -rf ${productdir}/* ./sdk/

if [ ! -x ${SRCROOT}/header/private/namespace/nmstool ]
then
chmod a+x ${SRCROOT}/header/private/namespace/nmstool
fi

prefix=$(awk '{if($0 ~ /\s*#define ARK_PREFIX/) print $3}' ${SRCROOT}/header/private/namespace/currentnamespace.h)
if [ ! -z "$prefix" ] && [ ${#prefix} != 0 ]; then
# 修改Demo的文件
$SRCROOT/header/private/namespace/nmstool -s ${prefix} -c $SRCROOT/XG-SDK/XG-SDK-Prefix.pch -f $DEMOSRCROOT/XG-Demo/ViewController.m > $DEMOSRCROOT/XG-Demo/ViewController.m.tmp
rm $DEMOSRCROOT/XG-Demo/ViewController.m
mv $DEMOSRCROOT/XG-Demo/ViewController.m.tmp $DEMOSRCROOT/XG-Demo/ViewController.m

$SRCROOT/header/private/namespace/nmstool -s ${prefix} -c $SRCROOT/XG-SDK/XG-SDK-Prefix.pch -f $DEMOSRCROOT/XG-Demo/AppDelegate.m > $DEMOSRCROOT/XG-Demo/AppDelegate.m.tmp
rm $DEMOSRCROOT/XG-Demo/AppDelegate.m
mv $DEMOSRCROOT/XG-Demo/AppDelegate.m.tmp $DEMOSRCROOT/XG-Demo/AppDelegate.m

$SRCROOT/header/private/namespace/nmstool -s ${prefix} -c $SRCROOT/XG-SDK/XG-SDK-Prefix.pch -f $DEMOSRCROOT/XG-DemoTests/XG_DemoTests.m > $DEMOSRCROOT/XG-DemoTests/XG_DemoTests.m.tmp
rm $DEMOSRCROOT/XG-DemoTests/XG_DemoTests.m
mv $DEMOSRCROOT/XG-DemoTests/XG_DemoTests.m.tmp $DEMOSRCROOT/XG-DemoTests/XG_DemoTests.m
fi

xcodebuild -sdk iphonesimulator
buildstatsimulator=$?

if [ $buildstatsimulator -ne 0 ]
then
echo simulator build demo error
exit 1
fi

xcodebuild -sdk iphoneos -configuration "Release"
buildstatios=$?

if [ $buildstatios -ne 0 ]
then
echo ios build demo error
exit 1
fi

rm -rf ./build


