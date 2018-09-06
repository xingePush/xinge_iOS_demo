//
//  NotificationService.m
//  XGService
//
//  Created by uwei on 09/08/2017.
//  Copyright © 2017 tyzual. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>
#import "XGExtension.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    if (self.bestAttemptContent.title.length > 0) {
        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    } else {
        self.bestAttemptContent.title = @"标题为空";
    }
    
    [[XGExtension defaultManager] handleNotificationRequest:request appID:2200257934 contentHandler:^(NSArray<UNNotificationAttachment *> * _Nullable attachments, NSError * _Nullable error) {
        self.bestAttemptContent.attachments = attachments;
        self.contentHandler(self.bestAttemptContent);
    }];
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
