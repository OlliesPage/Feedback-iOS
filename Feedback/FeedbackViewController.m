//
//  FeedbackViewController.m
//  Feedback
//
//  Created by Oliver Hayman on 02/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "FeedbackViewController.h"
#import "simpleFeedbackModel.h"
#import "FeedbackView.h"

@interface FeedbackViewController()
@property (nonatomic, weak) FeedbackView *feedbackView;
@property (nonatomic, strong) simpleFeedbackModel *model;
@end

@implementation FeedbackViewController

@synthesize firstSlider = _firstSlider;
@synthesize secondSlider = _secondSlider;
@synthesize controllerText = _controllerText;
@synthesize deviceText = _deviceText;
@synthesize feedbackText = _feedbackText;
@synthesize disturbanceSlider = _disturbanceSlider;
@synthesize inputLabel = _inputLabel;
@synthesize outputLabel = _outputLabel;
@synthesize disturbanceLabel = _disturbanceLabel;
@synthesize infoButton = _infoButton;
@synthesize graphButton = _graphButton;
@synthesize model = _model;
@synthesize feedbackView = _feedbackView;

double temp;

- (void)setFirstSlider:(UISlider *)firstSlider
{
    _firstSlider = firstSlider;
    firstSlider.transform = CGAffineTransformRotate(firstSlider.transform, 270.0/180*M_PI);
}

- (void)setSecondSlider:(UISlider *)secondSlider
{
    _secondSlider = secondSlider;
    secondSlider.transform = CGAffineTransformRotate(secondSlider.transform, 270.0/180*M_PI);
}

- (simpleFeedbackModel *)model
{
    if(!_model) _model = [[simpleFeedbackModel alloc] init];
    return _model;
}
- (IBAction)showInfo:(id)sender {
    // Segue to credits page
    [self performSegueWithIdentifier:@"CreditsSegue" sender:self];
}

- (IBAction)inputValueChanged {
    double output = [self.model calculateOutput:[self.firstSlider value] withDistrubance:[self.disturbanceSlider value]];
    if (![[self.inputLabel text] isEqualToString:[NSString stringWithFormat:@"I=%.2f", [self.firstSlider value]]])
    self.inputLabel.text = [NSString stringWithFormat:@"I=%.2f", [self.firstSlider value]];
    self.outputLabel.text = [NSString stringWithFormat:@"O=%.2f",output];
    if (![[self.disturbanceLabel text] isEqualToString:[NSString stringWithFormat:@"D=%.2f",[self.disturbanceSlider value]]])
    self.disturbanceLabel.text = [NSString stringWithFormat:@"D=%.2f",[self.disturbanceSlider value]];
    if(output > 10) output = 10;
    if(output < -10) output = -10;
    self.secondSlider.value = output; // show the feedback
}

- (IBAction)textWillChange:(id)sender {
    temp = [[sender text] doubleValue];
}

- (IBAction)editEnded:(id)sender {
    if(![[sender text] isEqualToString:@"0"])
    {
        if([[sender text] doubleValue] == 0)
        {
            [sender setText:[NSString stringWithFormat:@"%.1f",temp]];
            
        } else {
            if(![[sender text] isEqualToString:[NSString stringWithFormat:@"%f",[[sender text] doubleValue]]])
            {
                [sender setText:[NSString stringWithFormat:@"%.1f",[[sender text] doubleValue]]];
            }
        }
    }
    NSString *identifier; // code to work out which text is being edited
    if ([sender isEqual:self.controllerText])
    {
        identifier = [[NSString alloc] initWithString:@"controller"];
    } else if ([sender isEqual:self.deviceText])
    {
        identifier = [[NSString alloc] initWithString:@"device"];
    } else if ([sender isEqual:self.feedbackText])
    {
        identifier = [[NSString alloc] initWithString:@"sensor"];
    }
    [self.model setVariables:identifier value:[[NSNumber alloc] initWithDouble:[[sender text] doubleValue]]];
    temp = 0;
}

#pragma mark - View lifecycle

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

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
        GraphViewController *graphView = segue.destinationViewController;
        graphView.min = [self.model minOutputWithDisturbance:[self.disturbanceSlider value]];
        graphView.max = [self.model maxOutputWithDisturbance:[self.disturbanceSlider value]];
        graphView.delegate = sender;
    }
    NSLog(@"Segue has been called: %@", [segue identifier]);
}

#pragma mark - GraphViewControllerDelegate
- (void)doCloseGraphViewController:(GraphViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goToGraphs:(id)sender {
    [self performSegueWithIdentifier:@"graphSegue" sender:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortrait);
}
@end
