//
//  iPadFeedbackViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 28/03/2012.
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

#import "iPadFeedbackViewController.h"
#import "feedbackModel.h"
#import "iPadViewControllerCommon.h"

@interface iPadFeedbackViewController () <FeedbackViewControllerDelegate, GraphViewDelegate>
@property (strong, nonatomic) feedbackModel *model;
@property (strong, nonatomic) UIView *currentFeedbackView;
@property (strong, nonatomic) NSArray *viewControllers;
@end

@implementation iPadFeedbackViewController
@synthesize OvIView = _OvIView;
@synthesize DvOView = _DvOView;
@synthesize PosOrNegFeedback = _PosOrNegFeedback;
@synthesize FeedbackDescriptionText = _FeedbackDescriptionText;
@synthesize LearnText = _LearnText;
@synthesize CorrectText = _CorrectText;
@synthesize IncorrectText = _IncorrectText;
@synthesize model = _model;
@synthesize currentFeedbackView = _currentFeedbackView;
@synthesize viewControllers = _viewControllers;

long active =0;

#pragma mark - Custom getters
- (feedbackModel *)model
{
    if(!_model) _model = [[feedbackModel alloc] init];
    return _model;
}

#pragma mark - FeedbackViewControllerDelegate Methods
-(void)setModelForwardDevices:(NSArray *)forwardDevices loopDevices:(NSArray *)loopDevices
{
    NSLog(@"delegate recieved set message with %lu forward devices and %lu loop devices", (unsigned long)[forwardDevices count],(unsigned long)[loopDevices count]);
    // first check the model is clear
    [self.model resetModel];
    [self.model addBlockDevicesWithForwardDevices:forwardDevices WithLoopDevices:loopDevices];
    [self setFeedbackTypeValue];
    // when the model is changed/set, we need to re-draw our graphs
    [self.OvIView setNeedsDisplay];
    [self.DvOView setNeedsDisplay];
}

- (void)setDeviceValue:(NSNumber *)value forDevice:(NSString *)name onLevel:(int)level
{
    NSLog(@"Setting device %@'s value to %f.1", name, [value doubleValue]);
    [self.model setBlockDeviceWithName:name value:[value doubleValue] onLevel:level];
    [self.OvIView setNeedsDisplay]; // re-genereate both graphs
    [self.DvOView setNeedsDisplay];
    [self setFeedbackTypeValue]; // this sets if the feedback is positive or negative unless learning mode is enabled
}

- (void)setLimitValue:(double)value
{
    [self.model setLimitValue:value];
    [self.DvOView setNeedsDisplay]; // re-generate the disturbance graph
}

- (double)calculateOutputForInput:(float)input withDisturbance:(float)disturbance
{
    [self.OvIView setNeedsDisplay]; // this should mark as dirty
    return [self.model calculateOutputForInput:input withDistrubance:disturbance];
}

- (BOOL)isLimitAtInput:(float)input
{
    return [self.model isLimitingAtInput:input];
}

#pragma mark - GraphViewDelegate Methods
- (double)getMaxValue
{
    return [self.model maxOutputWithDisturbance:[((GenericViewController *)[self.viewControllers objectAtIndex:active]).distrubanceSlider value]];
}

- (double)getMinValue
{
    return [self.model minOutputWithDisturbance:[((GenericViewController *)[self.viewControllers objectAtIndex:active]).distrubanceSlider value]];
}

- (double)getLimitValue
{
    return [self.model getLimitValue];
}

- (double)getOutputvDisturbance
{
    return [self.model outputVdisturbanceGradient];
}

#pragma mark - IBActions
- (IBAction)changeView:(id)sender
{
    // Let's see which button was pushed... they are all tagged
    if([self.viewControllers count] > [sender tag])
    {
        active = [sender tag];
        if([self.currentFeedbackView isKindOfClass:[((UIViewController *)[self.viewControllers objectAtIndex:active]).view class]]) {
            NSLog(@"Already on screen");
            return;
        } else {
            [self.currentFeedbackView removeFromSuperview]; // remove the current view
            self.currentFeedbackView = ((UIViewController *)[self.viewControllers objectAtIndex:active]).view;
            CGRect viewSpace = CGRectMake(0, 65, 721, 392);
            self.currentFeedbackView.frame = viewSpace;
            [self.view addSubview:self.currentFeedbackView];
        }
    }
}

- (IBAction)feedbackTypeGuessed:(id)sender
{
    // ok here we have some fun - we've got to work out if they are right or not and show that!
    [self.FeedbackDescriptionText setHidden:NO];
    [self.LearnText setHidden:YES];
    if(((UISegmentedControl *)sender).selectedSegmentIndex == [self.model isFeedbackNegative])
    {
        [self.CorrectText setHidden:NO];
        [self.IncorrectText setHidden:YES];
    } else {
        [self.CorrectText setHidden:YES];
        [self.IncorrectText setHidden:NO];
    }
}

- (IBAction)blockPressed:(UILongPressGestureRecognizer *)sender
{
    // this action is taken if the forward or loop block descriptor is tapped
    const NSString *block = [sender isEqual:self.forwardGesture]?@"Forward":@"Loop";
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        [[self.viewControllers objectAtIndex:active] highlightBlockDeveces:block];
        NSLog(@"%@ has been pressed",block);
        // start the drawing of the circle on self.currentFeedbackView
    }
    
    if([sender state] == UIGestureRecognizerStateEnded || [sender state] == UIGestureRecognizerStateCancelled)
    {
        [[self.viewControllers objectAtIndex:active] removeHighlight];
        NSLog(@"%@ has finished", block);
        // start the fading of the circle from self.currentFeedbackView
    }
}

#pragma mark - PublicOrPrivate Methods
- (void)setFeedbackTypeValue
{
    [self.CorrectText setHidden:YES];
    [self.IncorrectText setHidden:YES];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"learning_preference"])
    {
        [self.PosOrNegFeedback setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [self.PosOrNegFeedback setUserInteractionEnabled:YES]; // enable user touch
        [self.FeedbackDescriptionText setHidden:YES];
        [self.LearnText setHidden:NO];
    } else {
        [self.PosOrNegFeedback setUserInteractionEnabled:NO]; // disable user touch
        self.PosOrNegFeedback.selectedSegmentIndex = [self.model isFeedbackNegative]; // generate the feedbackType
        [self.FeedbackDescriptionText setHidden:NO];
        [self.LearnText setHidden:YES];
    }
}

#pragma mark - ViewController stuff

- (void)viewDidLoad
{
    [super viewDidLoad];
    // init the viewControllers array here... tried doing in init for but objects are not instansiated
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setFeedbackTypeValue) name:UIApplicationDidBecomeActiveNotification object:nil];
    self.viewControllers = [[NSArray alloc] initWithObjects:[self.storyboard instantiateViewControllerWithIdentifier:@"iPadBasicViewController"],[self.storyboard instantiateViewControllerWithIdentifier:@"iPadLimitViewController"], nil];
    
    [self.OvIView setDelegate:self]; // set self to be delegate for GraphView
    [self.DvOView setDelegate:self]; // set self to be delegate for GraphView
    
    // here we set up the additional View Controllers
    for(int i=0; i<[self.viewControllers count]; i++)
    {
        [(iPadViewControllerCommon *)[self.viewControllers objectAtIndex:i] setDelegate:self]; // this sets the delegate method of all viewControllers
    }
    [self addChildViewController:[self.viewControllers objectAtIndex:active]];
    self.currentFeedbackView = ((UIViewController *)[self.viewControllers objectAtIndex:active]).view;
    CGRect viewSpace = CGRectMake(0, 65, 721, 392);
    self.currentFeedbackView.frame = viewSpace;
    [self.view addSubview:self.currentFeedbackView];
}

- (void)viewDidUnload
{
    [self setOvIView:nil];
    [self setDvOView:nil];
    [self setCurrentFeedbackView:nil];
    [self setViewControllers:nil];
    [self setModel:nil];
    [self setPosOrNegFeedback:nil];
    [self setFeedbackDescriptionText:nil];
    [self setCorrectText:nil];
    [self setIncorrectText:nil];
    [self setLearnText:nil];
    [self setForwardGesture:nil];
    [self setLoopGesture:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
