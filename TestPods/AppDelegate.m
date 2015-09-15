//
//  AppDelegate.m
//  TestPods
//
//  Created by xy on 15/8/25.
//  Copyright (c) 2015年 XY. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "T.h"



@interface AppDelegate ()

@end

@implementation AppDelegate



//校验数据库
- (void)validateDatabase
{
    //原始数据库路径
    NSString *originalDataBasePath = [[NSBundle mainBundle] pathForResource:DATABASE_NAME_PREFIX ofType:@"db"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSLog(@"3.2 GetDATABASE = %@",GetDATABASE);
    if (![fileManager fileExistsAtPath:GetDATABASE]) {
        //如果不存在数据库，将原始数据库复制到目标文件夹下
        [fileManager copyItemAtPath:originalDataBasePath toPath:GetDATABASE error:nil];
    }else {
        //TODO 对原始数据库与业务数据库的表结构进行对比
    }
    
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self validateDatabase];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    application.applicationIconBadgeNumber = 0;
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    UINavigationController *navigationController = (UINavigationController*)self.window.rootViewController;
    
    id topViewController = navigationController.topViewController;
    if ([topViewController isKindOfClass:[ViewController class]]) {
//        [(ViewController*)topViewController insertNewObjectForFetchWithCompletionHandler:completionHandler];
    } else {
        NSLog(@"Not the right class %@.", [topViewController class]);
        completionHandler(UIBackgroundFetchResultFailed);
    }
}
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
  completionHandler:(void (^)())completionHandler {
    self.backgroundSessionCompletionHandler = completionHandler;
    
    //add notification
    NSLog(@"这是一个本地推送");
    [self presentNotification];
}


-(void)presentNotification{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Download Complete!";
    localNotification.alertAction = @"Background Transfer Download!";
    
    //On sound
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //increase the badge number of application plus 1
//    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}



@end
