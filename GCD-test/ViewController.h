//
//  ViewController.h
//  GCD-test
//
//  Created by litianqi on 2019/5/7.
//  Copyright © 2019 edu24ol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
@interface ViewController : UIViewController
+ (void)registerRemoteNotification:(id<UNUserNotificationCenterDelegate>)delegate;

@end

