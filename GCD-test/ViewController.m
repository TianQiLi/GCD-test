//
//  ViewController.m
//  GCD-test
//
//  Created by litianqi on 2019/5/7.
//  Copyright © 2019 edu24ol. All rights reserved.
//

#import "ViewController.h"
#import "PushNotificationManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testForOperation];
    [PushNotificationManager localNotificationTest];
    
  
    
}

- (void)testForOperation{
    
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;//串行队列
//    queue.maxConcurrentOperationCount = -1;//不受限制的并发队列
//    queue.maxConcurrentOperationCount = 8;//> 1不受限制的并发队列
    
    
//    queue = [NSOperationQueue mainQueue];
    
//    NSInvocation * invocation = [[NSInvocation alloc]invokeWithTarget:self];
    NSInvocationOperation * invacationOP = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    NSInvocationOperation * invacationOP2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    [invacationOP addDependency:invacationOP2];
    
    
    NSInvocationOperation * invacationOP3 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task3) object:nil];

    NSBlockOperation * blockOP4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"-4---%s---%@\n",__func__,[NSThread currentThread]);
    }];
    
    [blockOP4 addExecutionBlock:^{
        NSLog(@"--5--%s---%@\n",__func__,[NSThread currentThread]);
    }];
    
    
    [queue addOperation:invacationOP];
    [queue addOperation:invacationOP2];
    
    [queue addOperation:invacationOP3];
    [queue addOperation:blockOP4];
    
}


- (void)task1{
    NSLog(@"----%s---%@\n",__func__,[NSThread currentThread]);
}

- (void)task2{
    NSLog(@"----%s---%@\n",__func__,[NSThread currentThread]);
}

- (void)task3{
    NSLog(@"----%s---%@\n",__func__,[NSThread currentThread]);
}

@end
