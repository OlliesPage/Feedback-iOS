//
//  GraphViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 26/03/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "iPhoneGraphViewController.h"

@interface iPhoneGraphViewController ()

@end

@implementation iPhoneGraphViewController

@synthesize returnButton = _returnButton;
@synthesize OvIView = _OvIView;
@synthesize OvDView = _OvDView;
@synthesize delegate = _delegate;
@synthesize min = _min;
@synthesize max = _max;
@synthesize gradient = _gradient;

#pragma mark - GraphView Delegates
- (double)getMaxValue
{
    return self.max;
}

- (double)getMinValue
{
    return self.min;
}

- (double)getLimitValue
{
    return 0;
}

- (double)getOutputvDisturbance
{
    return self.gradient;
}


#pragma mark - methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.OvIView setDelegate:self];
    [self.OvDView setDelegate:self];
}

- (void)viewDidUnload
{
    [self setReturnButton:nil];
    [self setDelegate:nil];
    [self setOvIView:nil];
    [self setOvDView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)doReturn:(id)sender
{
    if([sender isEqual:self.dismissGuesture])
        NSLog(@"Dismiss guesture registered");
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self.delegate doCloseGraphViewController:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
@end
