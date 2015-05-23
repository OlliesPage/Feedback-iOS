//
//  iPadLimitViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 20/07/2012.
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
#import <FeedbackUIFramework/UILimitBlock.h>
#import "FeedbackViewControllerDelegateProtocol.h"

@interface iPadLimitViewController : UIViewController <UILimitBlockDelegate>
@property (weak, nonatomic) IBOutlet UILabel *inputTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *outputTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *disturbanceTextLabel;
@property (weak, nonatomic) IBOutlet UISlider *inputSlider;
@property (weak, nonatomic) IBOutlet UISlider *outputSlider;
@property (weak, nonatomic) IBOutlet UISlider *distrubanceSlider;
@property (weak, nonatomic) IBOutlet UITextField *controllerBlock;
@property (weak, nonatomic) IBOutlet UITextField *sensorBlock;

@property (strong) IBOutlet NSObject *textFieldDelegate;
@property (weak, nonatomic) IBOutlet UILimitBlock *limitBlockView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *inputGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *disturbanceGestureRecognizer;
@property (nonatomic, weak) id <FeedbackViewControllerDelegate> delegate;

- (IBAction)inputChanged;
- (IBAction)editWillBegin:(id)sender;
- (IBAction)blockChanged:(id)sender;
- (IBAction)resetGesture:(id)sender;

- (void)highlightBlockDeveces:(const NSString *)block;
- (void)removeHighlight;
@end
