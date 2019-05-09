//
//  PushNotificationManager.h
//  GCD-test
//
//  Created by litianqi on 2019/5/9.
//  Copyright © 2019 edu24ol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
NS_ASSUME_NONNULL_BEGIN

/**
 * 前台通知在ios 10 开始支持
 * 注册通知需要针对ios 10 和之前的版本分开注册
 * shouldAlwaysAlertWhileAppIsForeground 属性为yes 表示可以在ios 10 采用前台系统通知 , 但是该属性在 ios 12 上不支持，直接使用会崩溃，所以需要针对ios 12 以上的系统做兼容,采用下面的方法：
 - (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)){
 completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
 }
 
 
 */

@interface PushNotificationManager : NSObject
/**
 * 注册不同平台的通知
 */
+ (void)registerRemoteNotification;
/*
 * 写入本地一个系统通知
 */
+ (void)foregroundPushNotificationWithDate:(NSDate*)date
                                   msgBody:(NSString*)msgBody userInfo:(NSDictionary *)userInfo;
+ (void)localNotificationTest;
@end

NS_ASSUME_NONNULL_END
