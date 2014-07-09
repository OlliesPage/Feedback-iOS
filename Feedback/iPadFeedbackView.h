//
//  iPadFeedbackView.h
//  Feedback
//
//  Created by Oliver Hayman on 15/05/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iPadFeedbackView : UIView

- (void)drawCircleAtPoint:(CGPoint)p plusAtTop:(BOOL)top plusAtBottom:(BOOL)bottom inContext:(CGContextRef)context;

@end
