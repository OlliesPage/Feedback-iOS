//
//  iPadFeedbackView.m
//  Feedback
//
//  Created by Oliver Hayman on 15/05/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "iPadFeedbackView.h"

@implementation iPadFeedbackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set the background colour and autoresizingMask :)
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth+UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p plusAtTop:(BOOL)top plusAtBottom:(BOOL)bottom inContext:(CGContextRef)context
{
    CGFloat radius = 30; // overwritten to a fixed width... smooth
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 4);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES); 
    
    // By using sOh cAh tOa you can work out the length of the lines... duh
    CGPoint trig; trig.x = cos(M_PI/4)*radius; trig.y = sin(M_PI/4)*radius;
    CGContextMoveToPoint(context, p.x-trig.x, p.y-trig.y);
    CGContextAddLineToPoint(context, p.x+trig.x, p.y+trig.y);
    // then use these points again, but with different sings to draw the other way
    CGContextMoveToPoint(context, p.x-trig.x, p.y+trig.y);
    CGContextAddLineToPoint(context, p.x+trig.x, p.y-trig.y);
    CGContextStrokePath(context);
    
    // this is the draw the plus on the left had side
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, p.x-((radius/2)+7), p.y);
    CGContextAddLineToPoint(context, p.x-(radius/2)+3, p.y);
    CGContextMoveToPoint(context, p.x-((radius/2)+2), p.y-5);
    CGContextAddLineToPoint(context, p.x-((radius/2)+2), p.y+5);
    
    // add the bottom plus
    if(bottom)
    {
        CGContextMoveToPoint(context, p.x, p.y+((radius/2)+7));
        CGContextAddLineToPoint(context, p.x, p.y+(radius/2)-3);
        CGContextMoveToPoint(context, p.x-5, p.y+((radius/2)+2));
        CGContextAddLineToPoint(context, p.x+5, p.y+((radius/2)+2));
        CGContextStrokePath(context);
    }
    
    if(top)
    {
        CGContextMoveToPoint(context, p.x, p.y-((radius/2)+7));
        CGContextAddLineToPoint(context, p.x, p.y-(radius/2)+3);
        CGContextMoveToPoint(context, p.x-5, p.y-((radius/2)+2));
        CGContextAddLineToPoint(context, p.x+5, p.y-((radius/2)+2));
        CGContextStrokePath(context);
    }
    CGContextSetLineWidth(context, 4.0);
    UIGraphicsPopContext();
}

@end
