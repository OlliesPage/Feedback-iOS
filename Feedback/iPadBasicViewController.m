//
//  iPadBasicViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 16/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "iPadBasicViewController.h"

@interface iPadBasicViewController ()
@property double temp;
@property CAShapeLayer *shapeOnScreen;
@end

@implementation iPadBasicViewController
@synthesize controllerText = _controllerText;
@synthesize deviceText = _deviceText;
@synthesize sensorText = _sensorText;
@synthesize inputSlider = _inputSlider;
@synthesize inputText = _inputText;
@synthesize outputSlider = _outputSlider;
@synthesize outputText = _outputText;
@synthesize distrubanceSlider = _distrubanceSlider;
@synthesize disturbanceText = _disturbanceText;
@synthesize inputResetGestureRecognizer = _inputResetGestureRecognizer;
@synthesize disturbanceResetGestureRecognizer = _disturbanceResetGestureRecognizer;
@synthesize temp = _temp;
@synthesize shapeOnScreen = _shapeOnScreen;
@synthesize delegate = _delegate;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // This is run each time the view is going to be put on the screen, this makes sure the correct model is loaded
    NSArray *forwardDevices = [[NSArray alloc] initWithObjects:[BlockDevice blockWithName:@"controller" andValue:[NSNumber numberWithDouble:[[self.controllerText text] doubleValue]]],[BlockDevice blockWithName:@"device" andValue:[NSNumber numberWithDouble:[[self.deviceText text] doubleValue]]], nil];
    NSArray *loopDevices = [[NSArray alloc] initWithObjects:[BlockDevice blockWithName:@"sensor" andValue:[NSNumber numberWithDouble:[[self.sensorText text] doubleValue]]], nil];
    self.temp = 0;
    // now send them to the delegate to be added to the model
    [self.delegate setModelForwardDevices:forwardDevices loopDevices:loopDevices];
    _shapeOnScreen = nil; // initialise
}

- (void)viewDidUnload
{
    [self setInputSlider:nil];
    [self setOutputSlider:nil];
    [self setControllerText:nil];
    [self setDeviceText:nil];
    [self setSensorText:nil];
    [self setDistrubanceSlider:nil];
    [self setDisturbanceText:nil];
    [self setOutputText:nil];
    [self setInputText:nil];
    [self setInputResetGestureRecognizer:nil];
    [self setDisturbanceResetGestureRecognizer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)highlightBlockDeveces:(const NSString *)block
{
    CGPoint position = CGPointMake(215, 45);
    int height = 100;
    if([block isEqualToString:@"Loop"])
    {
        height = 200;
        position.y = 20;
    }
    if(self.shapeOnScreen != nil)
        [self.shapeOnScreen removeFromSuperlayer]; // this removes the old CALayer from the screen
    
    self.shapeOnScreen = [CAShapeLayer layer];
    self.shapeOnScreen.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 292, height)].CGPath;
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

- (IBAction)inputChanged {
    double output = [self.delegate calculateOutputForInput:[self.inputSlider value] withDisturbance:[self.distrubanceSlider value]];
    if (![[self.inputText text] isEqualToString:[NSString stringWithFormat:@"I=%.2f", [self.inputSlider value]]])
        self.inputText.text = [NSString stringWithFormat:@"I=%.2f", [self.inputSlider value]];
    if (![[self.disturbanceText text] isEqualToString:[NSString stringWithFormat:@"D=%.2f",[self.distrubanceSlider value]]])
        self.disturbanceText.text = [NSString stringWithFormat:@"D=%.2f",[self.distrubanceSlider value]];
    [self.outputText setText:[NSString stringWithFormat:@"O=%.2f",output]];
    if(output > 10) output = 10;
    if(output < -10) output = -10;
    self.outputSlider.value = output; // show the feedback
}

- (IBAction)editBegins:(id)sender {
    self.temp = [[sender text] doubleValue];
}

- (IBAction)blockChanged:(id)sender {
    // this means that the block value was altered
    NSLog(@"Value changed to: '%@' with doubleValue: %.1f",[sender text], [[sender text] doubleValue]);
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
    if ([sender isEqual:self.controllerText])
    {
        identifier = @"controller";
    } else if ([sender isEqual:self.deviceText])
    {
        identifier = @"device";
    } else if ([sender isEqual:self.sensorText])
    {
        identifier = @"sensor"; level = 1;
    }
    [self.delegate setDeviceValue:[NSNumber numberWithDouble:[[sender text] doubleValue]] forDevice:identifier onLevel:level];
    [self inputChanged]; // this should make it recalculate the value shown for output
    self.temp = 0;
    
}

- (IBAction)resetGesture:(id)sender
{
    if([sender isEqual:self.inputResetGestureRecognizer])
        [self.inputSlider setValue:0];
    else if([sender isEqual:self.disturbanceResetGestureRecognizer])
        [self.distrubanceSlider setValue:0];
    [self inputChanged];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
@end
