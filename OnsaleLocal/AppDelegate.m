//
//  AppDelegate.m
//  OnsaleLocal
//
//  Created by Admin on 1/27/13.
//  Copyright (c) 2013 Jonathan Emrich. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import "OnsaleLocalConstants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [LocationManager instance];
    //[self openSessionWithAllowLoginUI:NO];
    return YES;
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}





- (void)applicationWillTerminate:(UIApplication *)application {
    [FBSession.activeSession close];
}


#pragma mark -
#pragma mark Facebook Methods
/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"%@",error);
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                [[NSUserDefaults standardUserDefaults] setObject:session.accessTokenData.accessToken forKey:FB_ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:FB_LOGIN_SUCCESS];
                
            }
            break;
        case FBSessionStateClosed:
            NSLog(@"FBSessionStateClosed");
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:FB_LOGIN_SUCCESS];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FB_ACCESS_TOKEN];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [NSArray arrayWithObjects:@"basic_info",@"user_likes, email", nil];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                          allowLoginUI:allowLoginUI
                                     completionHandler:^(FBSession *session,
                                                         FBSessionState state,
                                                         NSError *error) {
                                         [self sessionStateChanged:session
                                                             state:state
                                                             error:error];
                                         NSLog(@"%@",session.accessTokenData.accessToken);
                                         [[NSUserDefaults standardUserDefaults] setObject:session.accessTokenData.accessToken forKey:FB_ACCESS_TOKEN];
                                     }];
}

/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

@end
