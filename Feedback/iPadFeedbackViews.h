//
//  iPadFeedbackViews.h
//  Feedback
//
//  Created by Oliver Hayman on 14/05/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//


// this file imports the header files for all feedbackView's for iPad
#ifndef Feedback_iPadFeedbackViews_h
#define Feedback_iPadFeedbackViews_h

#import "iPadBasicViewController.h"
#import "iPadBasicFeedbackView.h"
#import "iPadLimitViewController.h"
#import "iPadLimitView.h"
#import "GraphView.h"

// this gives us a "prototype" of what our viewcontrollers will include... and yet is never used
@interface GenericViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UISlider *inputSlider;
@property (weak, nonatomic) IBOutlet UISlider *outputSlider;
@property (weak, nonatomic) IBOutlet UISlider *distrubanceSlider;

- (void)highlightBlockDeveces:(const NSString *)block;
- (void)removeHighlight;
@end

#endif
