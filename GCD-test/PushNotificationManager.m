//
//  PushNotificationManager.m
//  GCD-test
//
//  Created by litianqi on 2019/5/9.
//  Copyright © 2019 edu24ol. All rights reserved.
//

#import "PushNotificationManager.h"
#import <UIKit/UIKit.h>
@interface PushNotificationManager()<UNUserNotificationCenterDelegate>

@end
@implementation PushNotificationManager

+ (id)shareInstance{
    static PushNotificationManager * obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [PushNotificationManager new];
    });
    return obj;
}

+ (void)registerRemoteNotification{
    // 添加自定义的categories
    NSSet *categories = [[self class] categories];
    
    // 创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categories, nil]];
    
    // 注册推送, 只能在主线程中push
    dispatch_async(dispatch_get_main_queue(), ^{
        if (@available(iOS 10.0, *)) {
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
            }];
            [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
            [UNUserNotificationCenter currentNotificationCenter].delegate = [PushNotificationManager shareInstance];
            //        [UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]
            //        [UNUserNotificationCenter setNotificationCategories:]
            
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        
    });
}

+ (NSSet *)categories {
    
    NSMutableSet *categories = [[NSMutableSet alloc] init];
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"category_identifier";
    
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = @"backgroundAction.identifier";
    action1.title = @"Reject";
    // 点击的时候不启动程序，在后台处理
    action1.activationMode = UIUserNotificationActivationModeBackground;
    // 需要解锁才能处理
    action1.authenticationRequired = YES;
    //YES 显示为红色，NO显示为蓝色
    action1.destructive = YES;
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"foregroundAction.identifier";
    action2.title = @"Accept";
    // 点击的时候启动程序，在前台处理
    if (@available(iOS 10.0, *)) {
        action2.activationMode = UNNotificationActionOptionForeground;
    } else {
        action2.activationMode = UIUserNotificationActivationModeForeground;
        // Fallback on earlier versions
    }
    //    action2.authenticationRequired = YES;//被忽略
    //YES 显示为红色，NO显示为蓝色
    action1.destructive = NO;
    
    NSArray *actions = @[action1,action2];
    
    [category setActions:actions forContext:UIUserNotificationActionContextDefault];
    
    
    [categories addObject:category];
    
    return categories;
}

+ (void)localNotificationTest{
      [PushNotificationManager foregroundPushNotificationWithDate:[NSDate dateWithTimeIntervalSinceNow:5] msgBody:@"11" userInfo:nil];
}

+ (void)foregroundPushNotificationWithDate:(NSDate*)date
                                   msgBody:(NSString*)msgBody userInfo:(NSDictionary *)userInfo
{
    if (@available(iOS 10.0, * )) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.body = msgBody;
        content.title = @"来自环球网校的一条新消息";
        content.sound = [UNNotificationSound defaultSound];
        content.badge = @(1);
        content.userInfo = userInfo;
        content.categoryIdentifier = @"test";
        //10之后的系统可以设置在前台显示
        if (!@available(iOS 12.0, * )) {
            //shouldAlwaysAlertWhileAppIsForeground 只能在ios 10 和ios 11 使用，其实willPresentNotification 协议方法实现后，该属性不设置也可以
            [content setValue:@(YES) forKeyPath:@"shouldAlwaysAlertWhileAppIsForeground"];
        }
        
        //  触发模式
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:4 repeats:NO];
        
        // 创建本地通知
        NSString *requestIdentifer = [NSString stringWithFormat:@"TestRequestww1%u",arc4random() % 1000];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger];
        
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
    }else{
        UILocalNotification* noti = [[UILocalNotification alloc] init];
        noti.fireDate = date;
        noti.repeatInterval = NSCalendarUnitDay;
        noti.soundName = UILocalNotificationDefaultSoundName;
        noti.applicationIconBadgeNumber = 1;
        noti.alertBody = msgBody;
        noti.userInfo = userInfo;
        [[UIApplication sharedApplication]  scheduleLocalNotification:noti];
    }
    
   
}

#pragma mark -- UNUserNotificationCenterDelegate
/* ios 12--创建前台通知时不设置 shouldAlwaysAlertWhileAppIsForeground属性。
 * ios 12.0 必须实现该协议，返回弹窗呈现的类型，否则自定义系统通知不显示
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"通知显示了：%s",__func__);
    completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionSound);
}
/*
 * 通知点击后的回调-可以用于处理自定义的跳转等
 */
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"通知点击了：%s",__func__);
}

@end
