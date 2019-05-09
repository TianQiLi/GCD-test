# GCD-test
** 对NSOprationQueue (队列) 和NSOpration （任务）进行了实现
** 其中NSOpration 是抽象类，系统给出了两个派生类NSInvocationOperation 和 NSBlockOpration;也可以自己自定义继承类，重写main 或者start 方法
*** NSInvocationOperation 用于selector 的方式添加任务
*** NSBlockOpration 用于block 的方式添加任务


** NSOprationQueue 有两种主队列和自定义队列； 其中自定义队列可以是串行或者是并行的，由maxConcurrentOperationCount 控制
*** maxConcurrentOperationCount = 1 表示串行队列 ； maxConcurrentOperationCount > 1 表示并行 ； 默认是-1 不受限制
*** shouldAlwaysAlertWhileAppIsForeground 属性是用于ios 10 - ios 11 的，ios 12 以上不能使用，否则会崩溃






# 前台推送系统弹窗实现
** ios 10 之后可以采用新的框架UserNotifications
** ios < 10 是实现不了前台系统弹窗的
** UNUserNotificationCenterDelegate 是核心的协议，有两个方法决定了正常显示前台系统弹窗

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
