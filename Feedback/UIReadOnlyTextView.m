//
//  UIReadOnlyTextView.m
//  Feedback
//
//  Created by Oliver Hayman on 08/11/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "UIReadOnlyTextView.h"

@implementation UIReadOnlyTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return NO; // this should stop any form of keyboard selection
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if([[sender class] isSubclassOfClass:[UIGestureRecognizer class]])
        return [super canPerformAction:action withSender:sender];
    else
        return NO;
} // this limits the selectors that can be used to only UIGestures

@end
