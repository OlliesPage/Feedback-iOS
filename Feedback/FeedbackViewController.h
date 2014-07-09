//
//  FeedbackViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 02/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPhoneGraphViewController.h"
#import "feedbackModel.h"
#import "iPhoneFeedbackView.h"

@interface FeedbackViewController : UIViewController <GraphViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *firstSlider;
@property (weak, nonatomic) IBOutlet UISlider *secondSlider;
@property (weak, nonatomic) IBOutlet UITextField *controllerText;
@property (weak, nonatomic) IBOutlet UITextField *deviceText;
@property (weak, nonatomic) IBOutlet UITextField *feedbackText;
@property (weak, nonatomic) IBOutlet UILabel *feedbackTypeText;
@property (weak, nonatomic) IBOutlet UISlider *disturbanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *disturbanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *graphButton;
@property (strong) IBOutlet NSObject *textFieldDelegate;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *inputGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *disturbanceGestureRecognizer;
@property (weak, nonatomic) IBOutlet UICircleView *firstCircleView;
@property (weak, nonatomic) IBOutlet UICircleView *disturbanceCircleView;

- (IBAction)inputValueChanged;
- (IBAction)editEnded:(id)sender;
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (IBAction)goToGraphs:(id)sender;
- (IBAction)resetGesture:(id)sender;

@end
