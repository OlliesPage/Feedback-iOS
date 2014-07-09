//
//  GraphViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 26/03/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@class iPhoneGraphViewController; // predefine this so that it can be used in the protocal

// this sets up the delegate protocal so that the viewController can be closed returning control to it's delegate.
@protocol GraphViewControllerDelegate <NSObject>

- (void)doCloseGraphViewController:(iPhoneGraphViewController *)controller;

@end

@interface iPhoneGraphViewController : UIViewController <GraphViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet GraphView *OvIView;
@property (weak, nonatomic) IBOutlet GraphView *OvDView;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *dismissGuesture;
@property (weak, nonatomic) id <GraphViewControllerDelegate> delegate;

@property double min;
@property double max;
@property double gradient;

- (IBAction)doReturn:(id)sender;

@end
