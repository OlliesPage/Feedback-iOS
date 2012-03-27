//
//  FeedbackViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 02/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewController.h"

@interface FeedbackViewController : UIViewController <UITextFieldDelegate, GraphViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UISlider *firstSlider;
@property (weak, nonatomic) IBOutlet UISlider *secondSlider;
@property (weak, nonatomic) IBOutlet UITextField *controllerText;
@property (weak, nonatomic) IBOutlet UITextField *deviceText;
@property (weak, nonatomic) IBOutlet UITextField *feedbackText;
@property (weak, nonatomic) IBOutlet UISlider *disturbanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;
@property (weak, nonatomic) IBOutlet UILabel *outputLabel;
@property (weak, nonatomic) IBOutlet UILabel *disturbanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *graphButton;

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
- (IBAction)goToGraphs:(id)sender;

@end
