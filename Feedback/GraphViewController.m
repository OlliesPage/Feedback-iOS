//
//  GraphViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 26/03/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

@synthesize OvIView = _OvIView;
@synthesize returnButton = _returnButton;
@synthesize delegate = _delegate;
@synthesize negOutLabel = _negOutLabel;
@synthesize posOutLabel = _posOutLabel;
@synthesize min = _min;
@synthesize max = _max;

- (void)setPosOutValue:(double)value
{
    NSLog(@"Positive Label value: %.2f",value);
    self.posOutLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)setNegOutValue:(double)value
{
    NSLog(@"Negative Label value: %.2f",value);
    self.negOutLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPosOutValue:self.max];
    [self setNegOutValue:self.min];
	NSLog(@"posLabel: %@", self.posOutLabel.text);
}

- (void)viewDidUnload
{
    [self setReturnButton:nil];
    [self setOvIView:nil];
    [self setNegOutLabel:nil];
    [self setPosOutLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}

- (IBAction)doReturn:(id)sender {
    // this must be done with delegation
    // FeedbackViewController must call it
    [self.delegate doCloseGraphViewController:self];
    //[self dismissModalViewControllerAnimated:YES];
}
@end
