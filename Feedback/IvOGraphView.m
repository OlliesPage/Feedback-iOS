//
//  IvOGraphView.m
//  Feedback
//
//  Created by Oliver Hayman on 19/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "IvOGraphView.h"

@interface IvOGraphView ()
@property UILabel *minInput;
@property UILabel *minOutput;
@property UILabel *maxInput;
@property UILabel *maxOutput;

- (void)initLabels;
@end

@implementation IvOGraphView
@synthesize minInput = _minInput;
@synthesize minOutput = _minOutput;
@synthesize maxInput = _maxInput;
@synthesize maxOutput = _maxOutput;

- (void)initLabels
{
    self.minInput = [[UILabel alloc] init];
    self.minOutput = [[UILabel alloc] init];
    self.maxInput = [[UILabel alloc] init];
    self.maxOutput = [[UILabel alloc] init];
    // make them all auto-shrink
    self.minInput.adjustsFontSizeToFitWidth = self.minOutput.adjustsFontSizeToFitWidth = self.maxInput.adjustsFontSizeToFitWidth = self.maxOutput.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.minInput];
    [self addSubview:self.minOutput];
    [self addSubview:self.maxInput];
    [self addSubview:self.maxOutput];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initLabels];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initLabels];
    }
    return self;
}

// this must not contain ANY logic that is not related to the line it is trying to draw
// All maths should be to convert values to the axis co-ordinates
- (void)drawLineWithMaxValue:(double)max andMinValue:(double)min withLimit:(double)limit onContext:(CGContextRef)context
{
    // note that this expects the axis to be as defined: x vals: ±10, y vals ±100
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    double maxValue = center.y + -1*(limit==0?max:limit)*(center.y/(limit==0?100:25)); // times by -1 - this is so that the graph is not drawn upside-down
    double minValue = center.y + -1*(limit==0?min:-1*limit)*(center.y/(limit==0?100:25)); // these points are calcuated relative to the input aix (±100 or ±25)
//    NSLog(@"Max value is: %f Min value is: %f", max, min);
    CGPoint maxPoint = CGPointMake(self.bounds.size.width, maxValue); // a y value of 0 = 10
    CGPoint minPoint = CGPointMake(0, minValue); // a y value of height = -10
    if(limit != 0)
    {
        maxPoint.x -= center.x/2; // this is to half the size of the axis
        minPoint.x += center.x/2; // by reducing the line but keeping the gradient the same
        // switch minPoint and maxPoint over if the max is negative
        if(max < 0)
        {
            double temp = maxPoint.x;
            maxPoint.x = minPoint.x;
            minPoint.x = temp;
        }
    }
    // this line drawing is required for both so do it
    [[UIColor blueColor] setStroke]; // set the pen to blue so that the line stands out
    if((maxPoint.y+11) > self.bounds.size.height) maxPoint.y = self.bounds.size.height-11;
    if((maxPoint.y-10) < 0) maxPoint.y = 10;
    if((minPoint.y+11) > self.bounds.size.height) minPoint.y = self.bounds.size.height-11;
    if((minPoint.y-10) < 0) minPoint.y = 10;
    CGContextMoveToPoint(context, minPoint.x, minPoint.y);
    CGContextAddLineToPoint(context, maxPoint.x, maxPoint.y); // draw a diaganol line between minPoint and Max Point
    if(limit != 0)
    {
        // this is for limits only - it draws the "tails" at the limiting values
        CGContextMoveToPoint(context, max<0?self.bounds.size.width:0, minPoint.y);
        CGContextAddLineToPoint(context, minPoint.x, minPoint.y); // this is the tail for rhs of the graph
        CGContextMoveToPoint(context, maxPoint.x, maxPoint.y);
        CGContextAddLineToPoint(context, max<0?0:self.bounds.size.width, maxPoint.y); // this is the tail for the lhs of the graph
    }
    CGContextStrokePath(context); // tell the computer to draw the lines for us
    [self.minInput setFrame:CGRectMake(minPoint.x, (center.y-21), 100, 21)];
    [self.maxInput setFrame:CGRectMake((maxPoint.x-25), (center.y-21), 25, 21)];
    [self.minOutput setFrame:CGRectMake(center.x+2, (minPoint.y-10), 50, 21)];
    [self.maxOutput setFrame:CGRectMake(center.x+2, (maxPoint.y-10), 50, 21)];
    if(limit!=0)
    {
        self.minInput.text = [NSString stringWithFormat:@"%.1f", min]; self.minInput.backgroundColor = [UIColor clearColor];
        self.maxInput.text = [NSString stringWithFormat:@"%.1f", max]; self.maxInput.backgroundColor = [UIColor clearColor]; self.maxInput.textAlignment = NSTextAlignmentRight;
        self.minOutput.text = [NSString stringWithFormat:@"%.1f",-1*limit]; self.minOutput.backgroundColor = [UIColor clearColor];
        self.maxOutput.text = [NSString stringWithFormat:@"%.1f",limit]; self.maxOutput.backgroundColor = [UIColor clearColor];
    } else {
        self.minInput.text = @"-10"; self.minInput.backgroundColor = [UIColor clearColor];
        self.maxInput.text = @"10"; self.maxInput.backgroundColor = [UIColor clearColor]; self.maxInput.textAlignment = NSTextAlignmentRight;
        self.minOutput.text = [NSString stringWithFormat:@"%.1f",min]; self.minOutput.backgroundColor = [UIColor clearColor];
        self.maxOutput.text = [NSString stringWithFormat:@"%.1f",max]; self.maxOutput.backgroundColor = [UIColor clearColor];
    }
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // only run this if the delegate exists, otherwise there will be problems
    if(super.delegate)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        // now add the line
        [self drawLineWithMaxValue:[super.delegate getMaxValue] andMinValue:[super.delegate getMinValue] withLimit:[super.delegate getLimitValue] onContext:context];
    }
}

@end
