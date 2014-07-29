//
//  iPadLimitViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 20/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "iPadLimitViewController.h"

@interface iPadLimitViewController ()
@property double temp;
@property CAShapeLayer *shapeOnScreen;
@end

@implementation iPadLimitViewController
@synthesize inputTextLabel = _inputTextLabel;
@synthesize outputTextLabel = _outputTextLabel;
@synthesize disturbanceTextLabel = _disturbanceTextLabel;
@synthesize inputSlider = _inputSlider;
@synthesize outputSlider = _outputSlider;
@synthesize distrubanceSlider = _distrubanceSlider;
@synthesize controllerBlock = _controllerBlock;
@synthesize sensorBlock = _sensorBlock;
@synthesize limitBlockView = _limitBlockView;
@synthesize inputGestureRecognizer = _inputGestureRecognizer;
@synthesize disturbanceGestureRecognizer = _disturbanceGestureRecognizer;
@synthesize temp = _temp;
@synthesize shapeOnScreen = _shapeOnScreen;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _shapeOnScreen = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSBlockDevice *limitBlock = [NSBlockDevice blockWithName:@"limit" andValue:[NSNumber numberWithDouble:9.0]];
    [limitBlock setType:[NSNumber numberWithInt:1]];
    NSArray *forwardDevices = [[NSArray alloc] initWithObjects:[NSBlockDevice blockWithName:@"controller" andValue:[NSNumber numberWithDouble:[[self.controllerBlock text] doubleValue]]],limitBlock, nil];
    NSArray *loopDevices = [[NSArray alloc] initWithObjects:[NSBlockDevice blockWithName:@"sensor" andValue:[NSNumber numberWithDouble:[[self.sensorBlock text] doubleValue]]], nil];
    self.temp = 0;
    // now send them to the delegate to be added to the model
    NSLog(@"sending delegate message with %lu fowrward devices and %lu loop devices", (unsigned long)[forwardDevices count],(unsigned long)[loopDevices count]);
    [self.delegate setModelForwardDevices:forwardDevices loopDevices:loopDevices];
    self.limitBlockView.value = 9.0;
    self.limitBlockView.delegate = self;
}

- (void)highlightBlockDeveces:(const NSString *)block
{
    CGPoint position = CGPointMake(220, 45);
    int height = 100;
    if([block isEqualToString:@"Loop"])
    {
        height = 200;
        position.y = 20;
    }
    if(self.shapeOnScreen != nil)
        [self.shapeOnScreen removeFromSuperlayer]; // this removes the old CALayer from the screen
    
    self.shapeOnScreen = [CAShapeLayer layer];
    self.shapeOnScreen.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 300, height)].CGPath;
    self.shapeOnScreen.position = position;
    self.shapeOnScreen.fillColor = [UIColor clearColor].CGColor;
    self.shapeOnScreen.strokeColor = [UIColor redColor].CGColor;
    self.shapeOnScreen.lineWidth = 1;
    [self.view.layer addSublayer:self.shapeOnScreen];
}

- (void)removeHighlight
{
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.delegate = self;
    fade.fromValue = [NSNumber numberWithFloat:1.0];
    fade.toValue = [NSNumber numberWithFloat:0.0];
    fade.duration = 1;
    fade.fillMode = kCAFillModeForwards;
    fade.removedOnCompletion = NO;
    [self.shapeOnScreen addAnimation:fade forKey:@"fadeOut"];
}

- (IBAction)inputChanged
{
    double output = [self.delegate calculateOutputForInput:[self.inputSlider value] withDisturbance:[self.distrubanceSlider value]];
    if(![[self.inputTextLabel text] isEqualToString:[NSString stringWithFormat:@"I=%.2f", [self.inputSlider value]]])
        [self.inputTextLabel setText:[NSString stringWithFormat:@"I=%.2f", [self.inputSlider value]]];
    if(![[self.disturbanceTextLabel text] isEqualToString:[NSString stringWithFormat:@"D=%.2f",[self.distrubanceSlider value]]])
        [self.disturbanceTextLabel setText:[NSString stringWithFormat:@"D=%.2f",[self.distrubanceSlider value]]];
    [self.outputTextLabel setText:[NSString stringWithFormat:@"O=%.2f",output]];
    self.limitBlockView.limiting = [self.delegate isLimitAtInput:[self.inputSlider value]];
    if(output < -10) output = -10;
    if(output >  10) output = 10;
    [self.outputSlider setValue:output];
    [self.limitBlockView setNeedsDisplay]; // this causes the limit block to re-draw
}

- (IBAction)editWillBegin:(id)sender
{
    self.temp = [[sender text] doubleValue];
}

- (IBAction)blockChanged:(id)sender
{
    if(![[sender text] isEqualToString:@"0"])
    {
        // if you attempt to change the string to zero... it doesn't change, unless you put 0.0
        if([[sender text] doubleValue] == 0)
        {
            [sender setText:[NSString stringWithFormat:@"%.1f",self.temp]];
        } else {
            if(![[sender text] isEqualToString:[NSString stringWithFormat:@"%f",[[sender text] doubleValue]]])
            {
                [sender setText:[NSString stringWithFormat:@"%.1f",[[sender text] doubleValue]]];
            }
        }
    }
    NSString *identifier; // code to work out which text is being edited
    int level = 0;
    if ([sender isEqual:self.controllerBlock])
    {
        identifier = @"controller";
    } else if ([sender isEqual:self.sensorBlock])
    {
        identifier = @"sensor"; level = 1;
    } else {
        return;
    }
    [self.delegate setDeviceValue:[NSNumber numberWithDouble:[[sender text] doubleValue]] forDevice:identifier onLevel:level];
    [self inputChanged]; // this should make it recalculate the value shown for output
    self.temp = 0;
}

- (void)limitChange:(id)sender
{
    
    [self.delegate setLimitValue:((UILimitBlock *)sender).value];
    [self inputChanged];
}

//- (IBAction)limitChanged:(id)sender
//{
//    double newLimit = fabs([[sender text] doubleValue]); // this saves doing this two more times
//
//    if([[sender text] doubleValue] == 0)
//    {
//        // we're using this to block changing the value so
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot set the limit to zero at this time" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        self.limitBlock.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:self.temp]]; // set the limitBlock's value back to what it was
//        NSLog(@"Limit value is: %@, self.temp is: %f",self.limitBlock.text,self.temp); // if you don't observe it, it doesn't appear to happen.
//        self.temp = 0;
//        self.limitBlockView.hidden = NO;
//        return; // stop it from changing the value!
//    } // stop users from setting the limit to zero!
//
//    [self.delegate setLimitValue:newLimit];
//    self.limitBlockView.value = newLimit;
//    [self inputChanged];
//    self.temp = 0;
//    self.limitBlockView.hidden = NO;
//}

- (IBAction)resetGesture:(id)sender
{
    if([sender isEqual:self.inputGestureRecognizer])
        [self.inputSlider setValue:0];
    else if([sender isEqual:self.disturbanceGestureRecognizer])
        [self.distrubanceSlider setValue:0];
    [self inputChanged];
}

- (void)viewDidUnload
{
    [self setInputTextLabel:nil];
    [self setOutputTextLabel:nil];
    [self setDisturbanceTextLabel:nil];
    [self setInputSlider:nil];
    [self setOutputSlider:nil];
    [self setDistrubanceSlider:nil];
    [self setControllerBlock:nil];
    [self setSensorBlock:nil];
    [self setDelegate:nil];
    [self setLimitBlockView:nil];
    [self setInputGestureRecognizer:nil];
    [self setDisturbanceGestureRecognizer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
@end
