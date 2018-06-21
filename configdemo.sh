#!/bin/sh

SRCROOT=../XG-SDK-NAMESPACE
productdir=${SRCROOT}/product

if [ ! -d ${productdir} ]; then
	echo "can't find XG SDK, build it first"
	exit 1
fi

rm -rf ./sdk/*
cp -rf ${productdir}/* ./sdk/

if [ ! -x ${SRCROOT}/header/private/namespace/nmstool ]
then
	chmod a+x ${SRCROOT}/header/private/namespace/nmstool
fi

prefix=$(awk '{if($0 ~ /\s*#define ARK_PREFIX/) print $3}' ${SRCROOT}/header/private/namespace/currentnamespace.h)
if [ ! -z "$prefix" ] && [ ${#prefix} != 0 ]; then
	# 修改Demo的文件
	$SRCROOT/header/private/namespace/nmstool -s ${prefix} -c $SRCROOT/XG-SDK/XG-SDK-Prefix.pch -f $SRCROOT/../XG-Demo/XG-Demo/ViewController.m > $SRCROOT/../XG-Demo/XG-Demo/ViewController.m.tmp
	rm $SRCROOT/../XG-Demo/XG-Demo/ViewController.m
	mv $SRCROOT/../XG-Demo/XG-Demo/ViewController.m.tmp $SRCROOT/../XG-Demo/XG-Demo/ViewController.m

	$SRCROOT/header/private/namespace/nmstool -s ${prefix} -c $SRCROOT/XG-SDK/XG-SDK-Prefix.pch -f $SRCROOT/../XG-Demo/XG-Demo/AppDelegate.m > $SRCROOT/../XG-Demo/XG-Demo/AppDelegate.m.tmp
	rm $SRCROOT/../XG-Demo/XG-Demo/AppDelegate.m
	mv $SRCROOT/../XG-Demo/XG-Demo/AppDelegate.m.tmp $SRCROOT/../XG-Demo/MTA-Demo/AppDelegate.m

	$SRCROOT/header/private/namespace/nmstool -s ${prefix} -c $SRCROOT/XG-SDK/XG-SDK-Prefix.pch -f $SRCROOT/../XG-Demo/XG-DemoTests/XG_DemoTests.m > $SRCROOT/../XG-Demo/XG-DemoTests/XG_DemoTests.m.tmp
	rm $SRCROOT/../XG-Demo/XG-DemoTests/XG_DemoTests.m
	mv $SRCROOT/../XG-Demo/XG-DemoTests/XG_DemoTests.m.tmp $SRCROOT/../XG-Demo/MTA-DemoTests/XG_DemoTests.m
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
