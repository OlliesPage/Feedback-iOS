//
//  OvIView.m
//  Feedback
//
//  Created by Oliver Hayman on 26/03/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "OvIView.h"

@implementation OvIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    
    CGContextBeginPath(context);
//    CGContextSetLineWidth(context, 0.05);
//    CGContextMoveToPoint(context, 0, 0);
//    CGContextAddLineToPoint(context, self.bounds.size.width, 0);
//    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height);
//    CGContextAddLineToPoint(context, 0, self.bounds.size.height);
//    CGContextAddLineToPoint(context, 0, 0);
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, (self.bounds.size.width/2), 0);
    CGContextAddLineToPoint(context, (self.bounds.size.width/2), self.bounds.size.height);
    CGContextMoveToPoint(context, 0, (self.bounds.size.height/2));
    CGContextAddLineToPoint(context, self.bounds.size.width, (self.bounds.size.height/2));
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokePath(context);
    [[UIColor blueColor] setStroke];
    CGContextMoveToPoint(context, 0, self.bounds.size.height);
    CGContextAddLineToPoint(context, self.bounds.size.width, 0); // line from the edge of the screen to the circle
    CGContextStrokePath(context);
    
}

@end
