//
//  PGCAppDelegate.m
//  PGC
//
//  Created by Shuai Xiao on 10/1/13.
//  Copyright (c) 2013 Shuai Xiao. All rights reserved.
//

#import "PGCAppDelegate.h"
#import "HomePageVC.h"

@implementation PGCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //判断如果由远程消息通知触发应用程序启动
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]!=nil) {
        
        NSLog(@"init frome remote ");
        //获取应用badge数
        int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        
        if (badge>0) {
            
            badge--;
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            
        }
        
    }
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    UIRemoteNotificationType enabledTypes =[[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    
    NSLog(@"My Token is %@",token);
    
}

//向APNS申请token失败

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"%@", err];
    
    NSLog(@"Failed to get token,err %@",str);
    
}

//获取到远程通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    int badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    badge++;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    for (id key in userInfo) {
        
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
        
    }
    
}

@end
