//
//  FeedbackView.m
//  Feedback
//
//  Created by Oliver Hayman on 05/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "iPhoneFeedbackView.h"

@implementation FeedbackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGPoint center;
    center.x= 86;center.y = 69.5;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, center.y);
    CGContextSetLineWidth(context, 4.0);
    CGContextAddLineToPoint(context, rect.size.width, center.y); // line across the screen
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, center.x, center.y+30);
    CGContextAddLineToPoint(context, center.x, 115.5); // line from bottom of circle down to bottom box height
    if(([[UIScreen mainScreen] bounds].size.height*[UIScreen mainScreen].scale) == 1136)
    {
        center.x = 367.5; // second circle center
    } else {
        center.x = 323.5; // second circle center
    }
    CGContextAddLineToPoint(context, rect.size.width-35, 115.5); // line from end of downward line to bottom box
    CGContextAddLineToPoint(context, rect.size.width-35, center.y);
    
    CGContextMoveToPoint(context, 271, center.y);
    CGContextAddLineToPoint(context, center.x-30, center.y); // line from second box to second circle
    CGContextMoveToPoint(context, center.x+30, center.y);
    CGContextAddLineToPoint(context, self.bounds.size.width, center.y); // line from second circle to output slider
    
    CGContextMoveToPoint(context, center.x, 23);
    CGContextAddLineToPoint(context, center.x, 40); // line from top slider to second circle
    CGContextStrokePath(context);
    
    //[self drawCircleAtPoint:center withRadius:30 plusAtTop:YES plusAtBottom:NO inContext:context];
}

@end
