//
//  FeedbackAppDelegate.m
//  Feedback
//
//  Created by Oliver Hayman on 02/02/2012.
//  Copyright (c) 2012 OlliesPage.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
