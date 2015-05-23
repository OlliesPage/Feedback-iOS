//
//  iPadFeedbackViewController.h
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
