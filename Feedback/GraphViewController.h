//
//  GraphViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 26/03/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OvIView.h"

@class GraphViewController; // predefine this so that it can be used in the protocal

// this sets up the delegate protocal so that the viewController can be closed returning control to it's delegate.
@protocol GraphViewControllerDelegate <NSObject>

- (void)doCloseGraphViewController:(GraphViewController *)controller;

@end

@interface GraphViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet OvIView *OvIView;
@property (weak, nonatomic) id <GraphViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *negOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *posOutLabel;

@property (nonatomic) double min;
@property (nonatomic) double max;

- (IBAction)doReturn:(id)sender;
- (void)setPosOutValue:(double)value;
- (void)setNegOutValue:(double)value;

@end
