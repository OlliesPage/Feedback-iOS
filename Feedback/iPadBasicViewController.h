//
//  iPadBasicViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 16/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackViewControllerDelegateProtocol.h"

@interface iPadBasicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *controllerText;
@property (weak, nonatomic) IBOutlet UITextField *deviceText;
@property (weak, nonatomic) IBOutlet UITextField *sensorText;
@property (weak, nonatomic) IBOutlet UISlider *inputSlider;
@property (weak, nonatomic) IBOutlet UILabel *inputText;
@property (weak, nonatomic) IBOutlet UISlider *outputSlider;
@property (weak, nonatomic) IBOutlet UILabel *outputText;
@property (weak, nonatomic) IBOutlet UISlider *distrubanceSlider;
@property (weak, nonatomic) IBOutlet UILabel *disturbanceText;
@property (strong) IBOutlet NSObject *textFieldDelegate;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *inputResetGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *disturbanceResetGestureRecognizer;
@property (nonatomic, weak) id <FeedbackViewControllerDelegate> delegate;

- (IBAction)inputChanged;
- (IBAction)editBegins:(id)sender;
- (IBAction)blockChanged:(id)sender;
- (IBAction)resetGesture:(id)sender;
- (void)highlightBlockDeveces:(const NSString *)block;
- (void)removeHighlight;
@end
