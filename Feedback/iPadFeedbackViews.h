//
//  iPadFeedbackViews.h
//  Feedback
//
//  Created by Oliver Hayman on 14/05/2012.
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
