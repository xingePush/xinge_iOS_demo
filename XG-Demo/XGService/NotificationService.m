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
    [[XGExtension defaultManager] handleNotificationRequest:request appID:2200262432 contentHandler:nil];
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    if (self.bestAttemptContent.title.length > 0) {
        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    } else {
        self.bestAttemptContent.title = @"标题为空";
    }
    
    
    //1. 下载
    NSURL *url = [NSURL URLWithString:@"http://xg.qq.com/pigeon_v2/resource/imgcache/image/logo.png"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
            //2. 保存数据, 不可以存储到不存在的路径
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"logo.png"];
            UIImage *image = [UIImage imageWithData:data];
            CGRect subrect = CGRectMake(0, 0, 55, CGImageGetHeight(image.CGImage));
            CGImageRef subImage = CGImageCreateWithImageInRect(image.CGImage, subrect);
            
            NSError *err = nil;
            [UIImageJPEGRepresentation([UIImage imageWithCGImage:subImage], 1) writeToFile:path options:NSAtomicWrite error:&err];
            
            //3. 添加附件
            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"remote-atta1" URL:[NSURL fileURLWithPath:path] options:nil error:&err];
            if (attachment) {
                self.bestAttemptContent.attachments = @[attachment];
            }
        }
        
        self.contentHandler(self.bestAttemptContent);
    }];
    
    [task resume];

}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
