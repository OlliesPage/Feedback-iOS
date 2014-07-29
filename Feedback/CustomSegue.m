//
//  CustomSegue.m
//  Feedback
//
//  Created by Oliver Hayman on 11/06/2013.
//  Copyright (c) 2013 OlliesPage. All rights reserved.
//

#import "CustomSegue.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomSegue

- (void)perform
{
    __weak UIViewController *srcViewController = (UIViewController *) self.sourceViewController;
    __weak UIViewController *destViewController = (UIViewController *) self.destinationViewController;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [srcViewController.view.window.layer addAnimation:transition forKey:nil];
    
    [srcViewController presentViewController:destViewController animated:NO completion:nil];
}

@end
