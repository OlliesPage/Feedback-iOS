//
//  iPadFeedbackViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 28/03/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iPadFeedbackViews.h"

@interface iPadFeedbackViewController : UIViewController
@property (weak, nonatomic) IBOutlet GraphView *OvIView;
@property (weak, nonatomic) IBOutlet GraphView *DvOView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *PosOrNegFeedback;
@property (weak, nonatomic) IBOutlet UITextView *FeedbackDescriptionText;
@property (weak, nonatomic) IBOutlet UITextView *LearnText;
@property (weak, nonatomic) IBOutlet UILabel *CorrectText;
@property (weak, nonatomic) IBOutlet UILabel *IncorrectText;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *forwardGesture;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *loopGesture;



- (IBAction)changeView:(id)sender;
- (IBAction)feedbackTypeGuessed:(id)sender;
- (IBAction)blockPressed:(UILongPressGestureRecognizer *)sender;

- (void)setFeedbackTypeValue;

@end
