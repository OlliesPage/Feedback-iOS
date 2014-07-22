//
//  FeedbackViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 02/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "FeedbackViewController.h"
#import "Feedback-Swift.h"

@interface FeedbackViewController()
@property (nonatomic, weak) FeedbackView *feedbackView;
@property (nonatomic, strong) feedbackModel *model;
@end

@implementation FeedbackViewController
@synthesize inputGestureRecognizer = _inputGestureRecognizer;
@synthesize disturbanceGestureRecognizer = _disturbanceGestureRecognizer;

@synthesize firstSlider = _firstSlider;
@synthesize secondSlider = _secondSlider;
@synthesize controllerText = _controllerText;
@synthesize deviceText = _deviceText;
@synthesize feedbackText = _feedbackText;
@synthesize feedbackTypeText = _feedbackTypeText;
@synthesize disturbanceSlider = _disturbanceSlider;
@synthesize inputLabel = _inputLabel;
@synthesize outputLabel = _outputLabel;
@synthesize disturbanceLabel = _disturbanceLabel;
@synthesize infoButton = _infoButton;
@synthesize graphButton = _graphButton;
@synthesize model = _model;
@synthesize feedbackView = _feedbackView;

double temp;

- (feedbackModel *)model
{
    if(!_model)
    {
        _model = [[feedbackModel alloc] init];
        
        // generate the basic model
        NSString *pathToBasic = [[NSBundle mainBundle] pathForResource:@"basic" ofType:@"json"];
        JSONFeedbackModel *jsonM = [[JSONFeedbackModel alloc] initWithSysModel:_model pathToModel:pathToBasic];
        #pragma unused(jsonM) // tell the compiler that we're not going to use this variable and not to moan about it
    }
    return _model;
}
- (IBAction)showInfo:(id)sender {
    // Segue to credits page
    [self performSegueWithIdentifier:@"CreditsSegue" sender:self];
}

- (IBAction)inputValueChanged {
    double output = [self.model calculateOutputForInput:[self.firstSlider value] withDistrubance:[self.disturbanceSlider value]];
    if (![[self.inputLabel text] isEqualToString:[NSString stringWithFormat:@"I=%.2f", [self.firstSlider value]]])
    self.inputLabel.text = [NSString stringWithFormat:@"I=%.2f", [self.firstSlider value]];
    self.outputLabel.text = [NSString stringWithFormat:@"O=%.2f",output];
    if (![[self.disturbanceLabel text] isEqualToString:[NSString stringWithFormat:@"D=%.2f",[self.disturbanceSlider value]]])
    self.disturbanceLabel.text = [NSString stringWithFormat:@"D=%.2f",[self.disturbanceSlider value]];
    if(output > 10) output = 10;
    if(output < -10) output = -10;
    self.secondSlider.value = output; // show the feedback
    self.feedbackTypeText.text = NSLocalizedString([self.model isFeedbackNegative]?@"Negative":@"Positive", @"Describing the type of feedback system");
}

- (IBAction)textWillChange:(id)sender {
    temp = [[sender text] doubleValue];
}

- (IBAction)editEnded:(id)sender {
    NSLog(@"Value changed to: '%@' with doubleValue: %f",[sender text], [[sender text] doubleValue]);
    double newValue = [[sender text] doubleValue];
    if(![[sender text] isEqualToString:@"0"])
    {
        // if you attempt to change the string to zero... it doesn't change, unless you put 0.0
        if([[sender text] doubleValue] == 0)
        {
            newValue = temp;
            [sender setText:[NSString stringWithFormat:@"%.1f",temp]];
        } else {
            if(![[sender text] isEqualToString:[NSString stringWithFormat:@"%f",[[sender text] doubleValue]]])
            {
                [sender setText:[NSString stringWithFormat:@"%.1f",[[sender text] doubleValue]]];
            }
        }
    } else newValue = temp;
    NSString *identifier; int level=0; // code to work out which text is being edited
    if ([sender isEqual:self.controllerText])
    {
        identifier = @"controller";
    } else if ([sender isEqual:self.deviceText])
    {
        identifier = @"device";
    } else if ([sender isEqual:self.feedbackText])
    {
        identifier = @"sensor"; level=1;
    }
    [self.model setBlockDeviceWithName:identifier value:newValue onLevel:level];
    [self inputValueChanged]; // this should make it recalculate the value shown for output
    temp = 0;
}

#pragma mark - View lifecycle

- (void)dismissKeyboard
{
    [self.controllerText resignFirstResponder];
    [self.deviceText resignFirstResponder];
    [self.feedbackText resignFirstResponder];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"graphSegue"])
    {
        iPhoneGraphViewController *graphView = segue.destinationViewController;
        graphView.min = [self.model minOutputWithDisturbance:[self.disturbanceSlider value]];
        graphView.max = [self.model maxOutputWithDisturbance:[self.disturbanceSlider value]];
        graphView.gradient = [self.model outputVdisturbanceGradient];
        graphView.delegate = sender;
    }
    NSLog(@"Segue has been called: %@", [segue identifier]);
}

#pragma mark - GraphViewControllerDelegate
- (void)doCloseGraphViewController:(iPhoneGraphViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToGraphs:(id)sender {
    [self performSegueWithIdentifier:@"graphSegue" sender:self];
}

- (IBAction)resetGesture:(id)sender
{
    if([sender isEqual:self.inputGestureRecognizer])
        [self.firstSlider setValue:0];
    else if([sender isEqual:self.disturbanceGestureRecognizer])
        [self.disturbanceSlider setValue:0];
    [self inputValueChanged];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.feedbackTypeText.text = NSLocalizedString([self.model isFeedbackNegative]?@"Negative":@"Positive", @"Describing the type of feedback system");
    self.secondSlider.thumbTintColor = [UIColor grayColor];
    self.firstCircleView.hasBottomPlus = YES;
    self.disturbanceCircleView.hasTopPlus = YES;
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidUnload
{
    [self setFirstSlider:nil];
    [self setSecondSlider:nil];
    [self setControllerText:nil];
    [self setDeviceText:nil];
    [self setFeedbackText:nil];
    [self setDisturbanceSlider:nil];
    [self setInputLabel:nil];
    [self setOutputLabel:nil];
    [self setDisturbanceLabel:nil];
    [self setInfoButton:nil];
    [self setGraphButton:nil];
    [self setFeedbackTypeText:nil];
    [self setInputGestureRecognizer:nil];
    [self setDisturbanceGestureRecognizer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
@end
