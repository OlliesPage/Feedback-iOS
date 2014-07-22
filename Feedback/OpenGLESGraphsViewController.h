//
//  OpenGLESGraphsViewController.h
//  Feedback
//
//  Created by Oliver Hayman on 17/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "feedbackModel.h"
#import "SinGraphGLKViewController.h"

@interface OpenGLESGraphsViewController : UIViewController <GraphGestureResizeDelegate>
@property (weak, nonatomic) feedbackModel *systemModel;
- (IBAction)returnToModel;
@end
