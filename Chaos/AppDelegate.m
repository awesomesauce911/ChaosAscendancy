//
//  AppDelegate.m
//  Chaos
//
//  Created by Rayan on 14/11/14.
//  Copyright (c) 2014 FNLSpider. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
#import "GameViewController.h"
@interface AppDelegate ()

@end
#define TRACKING_ID @"UA-56746383-2"
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    BOOL ads = [store boolForKey:@"AdsDisabled"];
    [[NSUserDefaults standardUserDefaults] setBool:ads forKey:@"AdsDisabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    
    NSString *device;
    
   // NSLog(@"%f",iOSDeviceScreenSize.height);
    
    if (iOSDeviceScreenSize.height == 480)
    {
        device = @"iPhone35";
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
        UIStoryboard *iPhone35Storyboard = [UIStoryboard storyboardWithName:@"iPhone35" bundle:nil];
        
        // Instantiate the initial view controller object from the storyboard
        UIViewController *initialViewController = [iPhone35Storyboard instantiateInitialViewController];
        
        // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        // Set the initial view controller to be the root view controller of the window object
        self.window.rootViewController  = initialViewController;
        
        // Set the window object to be the key window and show it
        [self.window makeKeyAndVisible];
    }
    
    else if(iOSDeviceScreenSize.height== 1024)
    {   // iPad
        // Instantiate a new storyboard object using the storyboard file named iPad
        device = @"iPad";

        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        
        UIViewController *initialViewController = [iPadStoryboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    else if(iOSDeviceScreenSize.height == 568)
    {
        
        // iPhone 5/5s
        // Instantiate a new storyboard object using the storyboard file named Main
        device = @"iPhone4";

        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *initialViewController = [iPadStoryboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
        
    }
    else if(iOSDeviceScreenSize.height == 667)
    {
        
        // iPhone 6
        // Instantiate a new storyboard object using the storyboard file named iPhone47
        device = @"iPhone47";

        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"iPhone47" bundle:nil];
        
        UIViewController *initialViewController = [iPadStoryboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
        
    }
    
    else if(iOSDeviceScreenSize.height == 736)
    {
       // NSLog(@"Reached correct");
        // iPhone 6 +
        // Instantiate a new storyboard object using the storyboard file named iPhone55
        device = @"iPhone55";

        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"iPhone55" bundle:nil];
        
        UIViewController *initialViewController = [iPadStoryboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
    }
    
    else
        
    {
        // iPhone 5 and iPod Touch 5th generation: 4 inch screen
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone4
        device = @"idk";

        UIStoryboard *iPadStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *initialViewController = [iPadStoryboard instantiateInitialViewController];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController  = initialViewController;
        [self.window makeKeyAndVisible];
        
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:@"Device"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:TRACKING_ID];
    
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    tracker.allowIDFACollection = YES;

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[GameViewController class]])
    {
        GameViewController *gvc = (GameViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
        [gvc resignActive];
        
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
     [[NSUbiquitousKeyValueStore defaultStore] setBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"AdsDisabled"] forKey:@"AdsDisabled"];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if([application.keyWindow.rootViewController isKindOfClass:[GameViewController class]])
    {
        GameViewController *gvc = (GameViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        BOOL yes = NO;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Music"] isEqualToString:@"On"])
        {
            yes = YES;
        }
        
        [gvc regainActive:yes];

    }
    
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [[NSUbiquitousKeyValueStore defaultStore] setBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"AdsDisabled"] forKey:@"AdsDisabled"];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

@end
