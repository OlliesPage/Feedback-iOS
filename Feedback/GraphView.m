//
//  GraphView.m
//  Feedback
//
//  Created by Oliver Hayman on 18/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawLineWithMaxValue:(double)max andMinValue:(double)min withLimit:(double)limit onContext:(CGContextRef)context
{
    // this function is to be overwritten by subclasses
    [self doesNotRecognizeSelector:_cmd];
}

- (void)drawLineWithGradient:(double)gradient withLimit:(double)limit onContext:(CGContextRef)context
{
    // this function is to be overwritten by subclasses
    [self doesNotRecognizeSelector:_cmd];
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"Class is %@", [self class]);
    // the first thing to do in drawRect is to draw the axis
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.bounds.size.width/2, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width/2, self.bounds.size.height);
    CGContextMoveToPoint(context, 0, self.bounds.size.height/2);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height/2);
    CGContextStrokePath(context);
    // here used to cal the drawLine... methods from above in a very view-specific way... that's now been removed
    // this makes this class even better than before, hopefully
}

@end
