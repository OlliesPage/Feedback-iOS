//
//  FeedbackView.m
//  Feedback
//
//  Created by Oliver Hayman on 05/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "FeedbackView.h"

@implementation FeedbackView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius plusAtTop:(BOOL)top plusAtBottom:(BOOL)bottom inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    // note here we have to modify our positions by 2pi and the extra width point
    CGContextMoveToPoint(context, p.x-radius+2*M_PI+1, p.y-radius+2*M_PI+1);
    CGContextAddLineToPoint(context, p.x+radius-2*M_PI-1, p.y+radius-2*M_PI-1);
    CGContextMoveToPoint(context, p.x-radius+2*M_PI+1, p.y+radius-2*M_PI-1);
    CGContextAddLineToPoint(context, p.x+radius-2*M_PI-1, p.y-radius+2*M_PI+1);
    CGContextStrokePath(context);
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


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGPoint center;
    center.x= 86;center.y = 69.5;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, center.y);
    CGContextSetLineWidth(context, 4.0);
    CGContextAddLineToPoint(context, 56, center.y); // line from the edge of the screen to the circle
    CGContextStrokePath(context);
    [self drawCircleAtPoint:center withRadius:30 plusAtTop:NO plusAtBottom:YES inContext:context];
    CGContextMoveToPoint(context, 116, center.y);
    CGContextAddLineToPoint(context, 131, center.y); // lines after the circle to the first box
    CGContextMoveToPoint(context, 180, center.y);
    CGContextAddLineToPoint(context, 229, center.y); // line between the top two boxes
    
    CGContextMoveToPoint(context, center.x, center.y+30);
    CGContextAddLineToPoint(context, center.x, 115.5); // line from bottom of circle down to bottom box height
    CGContextAddLineToPoint(context, 166, 115.5); // line from end of downward line to bottom box
    
    center.x = 323.5; // second circle center
    
    CGContextMoveToPoint(context, 212, 115.5);
    CGContextAddLineToPoint(context, center.x+45, 115.5);
    CGContextAddLineToPoint(context, center.x+45, center.y);
    
    CGContextMoveToPoint(context, 271, center.y);
    CGContextAddLineToPoint(context, center.x-30, center.y); // line from second box to second circle
    CGContextMoveToPoint(context, center.x+30, center.y);
    CGContextAddLineToPoint(context, self.bounds.size.width, center.y); // line from second circle to output slider
    
    CGContextMoveToPoint(context, 323.5, 23); 
    CGContextAddLineToPoint(context, 323.5, 40); // line from top slider to second circle
    CGContextStrokePath(context);
    
    [self drawCircleAtPoint:center withRadius:30 plusAtTop:YES plusAtBottom:NO inContext:context];
}

@end
