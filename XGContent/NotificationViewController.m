//
//  NotificationViewController.m
//  XGContent
//
//  Created by uwei on 09/08/2017.
//  Copyright © 2017 tyzual. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any required interface initialization here.
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
    NSArray <UNNotificationAttachment *> *attachments = notification.request.content.attachments;
    if (attachments.count > 0) {
        UNNotificationAttachment *firstAttachment = attachments[0];
        if ([firstAttachment.URL startAccessingSecurityScopedResource]) {
            // access attachment
            [firstAttachment.URL stopAccessingSecurityScopedResource];
        }
    }
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response completionHandler:(void (^)(UNNotificationContentExtensionResponseOption))completion {
    if ([response.actionIdentifier isEqualToString:@"xg000001"]) {
        self.label.text = @"点击了1";
    } else if ([response.actionIdentifier isEqualToString:@"xg000002"]) {
        self.label.text = @"点击了2";
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(UNNotificationContentExtensionResponseOptionDismissAndForwardAction);
    });
}


@end
