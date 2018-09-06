//
//  XG_DemoTests.m
//  XG-DemoTests
//
//  Created by xf on 2017/2/17.
//  Copyright © 2017年 tyzual. All rights reserved.
//

#import "XGPush.h"
#import "XGSetting.h"
#import <XCTest/XCTest.h>

//waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT                                                                    \
	do {                                                                        \
		[self expectationForNotification:@"XGBaseTest" object:nil handler:nil]; \
		[self waitForExpectationsWithTimeout:30 handler:nil];                   \
	} while (0);

#define NOTIFY \
	[[NSNotificationCenter defaultCenter] postNotificationName:@"XGBaseTest" object:nil];

@interface XG_DemoTests : XCTestCase

@end

@implementation XG_DemoTests

- (void)setUp {
	[super setUp];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerDeviceFailed) name:@"registerDeviceFailed" object:nil];

	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.

	[super tearDown];
}

- (void)registerDeviceFailed {
	NSLog(@"registerDeviceFailed.....");
	XCTFail(@"注册apns或设备出错");
}

- (void)testSetTag {
	[XGPush setTag:@"myTag"
		successCallback:^{
			NSLog(@"[XGDemo] Set tag success");
			NOTIFY
		}
		errorCallback:^{
			NSLog(@"[XGDemo] Set tag error");
			XCTFail(@"设置标签出错");
			NOTIFY
		}];
	WAIT
}

- (void)testDelTag {
	[XGPush delTag:@"myTag"
		successCallback:^{
			NSLog(@"[XGDemo] Del tag success");
			NOTIFY
		}
		errorCallback:^{
			NSLog(@"[XGDemo] Del tag error");
			XCTFail(@"删除标签出错");
			NOTIFY
		}];
	WAIT
}

- (void)testSetAccount {
	[XGPush setAccount:@"myAccount"
		successCallback:^{
			NSLog(@"[XGDemo] Set account success");
			NOTIFY
		}
		errorCallback:^{
			NSLog(@"[XGDemo] Set account error");
			XCTFail(@"设置账号出错");
			NOTIFY
		}];
	WAIT
}

- (void)testDelAccount {
	[XGPush delAccount:^{
		NSLog(@"[XGDemo] Del account success");
		NOTIFY
	}
		errorCallback:^{
			NSLog(@"[XGDemo] Del account error");
			XCTFail(@"删除账号出错");
			NOTIFY
		}];
	WAIT
}

- (void)testUnregisterDevice {
	[XGPush unRegisterDevice:^{
		NSLog(@"Unregister Success");
		NOTIFY
	}
		errorCallback:^{
			NSLog(@"Unregister Error");
			XCTFail(@"注销设备出错");
			NOTIFY
		}];
	WAIT
}

- (void)testCopyToken {
	NSString *token = [XGPush getCurrentDeviceToken];
	if (!token || token.length == 0) {
		XCTFail(@"拷贝token出错");
		return;
	}
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = token;
	NSLog(@"token = %@", token);
}


- (void)testExample {
	// This is an example of a functional test case.
	// Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
	// This is an example of a performance test case.
	[self measureBlock:^{
		// Put the code you want to measure the time of here.
	}];
}

@end
