//
//  XGExtension.h
//  XGExtension
//
//  Created by uwei on 28/11/2017.
//  Copyright © 2017 mta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

__IOS_AVAILABLE(10.0)
@interface XGExtension : NSObject

/**
 @brief 信鸽推送Service extension管理对象

 @return 管理对象
 */
+ (nonnull instancetype)defaultManager;

/**
 @brief 信鸽推送处理抵达到终端的消息，即消息回执
 
 @param request 推送请求
 @param appID 信鸽应用ID
 @param handler 处理消息的回调，回调方法中处理关联的富媒体文件(暂不可用)
 */
- (void)handleNotificationRequest:(nonnull UNNotificationRequest *)request appID:(uint32_t)appID contentHandler:(nullable void(^)( NSArray <UNNotificationAttachment *>* _Nullable attachments,  NSError * _Nullable error))handler;


/**
 @brief 信鸽推送处理抵达到终端的消息，即消息回执
 
 @param request 推送请求
 @param key 包含有富媒体文件的字段
 @param appID 信鸽应用ID
 @param handler 处理消息的回调，回调方法中处理关联的富媒体文件(暂不可用)
 */
- (void)handleNotificationRequest:(nonnull UNNotificationRequest *)request attachmentKey:(nonnull NSString *)key appID:(uint32_t)appID contentHandler:(nullable void(^)( NSArray <UNNotificationAttachment *>* _Nullable attachments,  NSError * _Nullable error))handler;


/**
 @brief 下载富媒体推送的文件并转换为通知中的附件

 @param url 富媒体文件URL
 @param completionHandler 结果回调，在其中包含富媒体转换为附件的结果
 */
- (void)startDownloadAttachmentFromURL:(nonnull NSString *)url completionHandler:(nullable void(^)(UNNotificationAttachment *_Nullable attachment,  NSError *_Nullable error))completionHandler;




@end
