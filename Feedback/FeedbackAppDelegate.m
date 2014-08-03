//
//  FeedbackAppDelegate.m
//  Feedback
//
//  Created by Oliver Hayman on 02/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "FeedbackAppDelegate.h"

@implementation FeedbackAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // setup preferences, note that one of these preferences is currently only user-changable on the iPood
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"learning_preference",[NSNumber numberWithBool:YES],@"use_sin", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize]; // this sets the default value for learning_preference to NO
    
    // register for remote notifications [APNS]
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize]; // make sure that the preferences are updated when the app returns from the background
}

@end
