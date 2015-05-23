//
//  OvDGraphView.m
//  Feedback
//
//  Created by Oliver Hayman on 19/07/2012.
//  Copyright (c) 2012 OlliesPage.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "OvDGraphView.h"

@interface OvDGraphView ()
@property UILabel *minInput;
@property UILabel *minOutput;
@property UILabel *maxInput;
@property UILabel *maxOutput;

- (void)initLabels;
@end

@implementation OvDGraphView
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

- (void)drawLineWithGradient:(double)gradient withLimit:(double)limit onContext:(CGContextRef)context
{
    NSLog(@"Gradient is %f", gradient);
    // note that this expects the axis to be as defined: x vals: ±10, y vals ±100
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    // y equals m times x - but this is using cartezian co-ordinates
    double max = center.y - (gradient*(limit==0?100:25));
    double min = center.y + (gradient*(limit==0?100:25));
    CGPoint maxPoint = CGPointMake(self.bounds.size.width, max); // a y value of 0 = 10
    CGPoint minPoint = CGPointMake(0, min); // a y value of height = -10
    if(limit != 0)
    {
        maxPoint.x -= center.x/2;
        minPoint.x += center.x/2;
    }
        // this is the simplest case y=mx - lets try not working out the center
    [[UIColor blueColor] setStroke];
    if((maxPoint.y+11) > self.bounds.size.height) maxPoint.y = self.bounds.size.height-11;
    if((maxPoint.y-10) < 0) maxPoint.y = 10;
    if((minPoint.y+11) > self.bounds.size.height) minPoint.y = self.bounds.size.height-11;
    if((minPoint.y-10) < 0) minPoint.y = 10;
    CGContextMoveToPoint(context, minPoint.x, minPoint.y);
    CGContextAddLineToPoint(context, maxPoint.x, maxPoint.y);
    if(limit != 0)
    {
        // this is for limits only
        CGPoint ends = CGPointMake(minPoint.y<center.y?0:self.bounds.size.height, maxPoint.y<center.y?0:self.bounds.size.height);
        CGContextMoveToPoint(context, 0, ends.x);
        CGContextAddLineToPoint(context, minPoint.x, minPoint.y);
        CGContextMoveToPoint(context, maxPoint.x, maxPoint.y);
        CGContextAddLineToPoint(context, self.bounds.size.width, ends.y);
    }
    CGContextStrokePath(context);
    
    // this block is the labels for when the system is not limiting
    if(limit != 0)
    {
        [self.minInput setFrame:CGRectMake(minPoint.x, (center.y-21), 50, 21)];
        disturbAtLimit current;
        gradient = 1/gradient;
        current.x = fabs(limit*gradient/(1-gradient));
        current.y = fabs(limit/(1-gradient));
        self.minInput.text = [NSString stringWithFormat:@"%.1f",-1*current.x]; self.minInput.backgroundColor = [UIColor clearColor];
        [self.maxInput setFrame:CGRectMake((maxPoint.x-50), (center.y-21), 50, 21)];
        self.maxInput.text = [NSString stringWithFormat:@"%.1f",current.x];; self.maxInput.backgroundColor = [UIColor clearColor]; self.maxInput.textAlignment = NSTextAlignmentRight;
        double adjust = minPoint.y-maxPoint.y;
        if(adjust < 21)
        {
            adjust=(21-adjust)/2;
            minPoint.y += adjust;
            maxPoint.y -= adjust;
        }
        [self.minOutput setFrame:CGRectMake(center.x+2, (minPoint.y-10), 50, 21)];
        self.minOutput.text = [NSString stringWithFormat:@"%.1f",-1*current.y]; self.minOutput.backgroundColor = [UIColor clearColor];
        [self.maxOutput setFrame:CGRectMake(center.x+2, (maxPoint.y-10), 50, 21)];
        self.maxOutput.text = [NSString stringWithFormat:@"%.1f",current.y]; self.maxOutput.backgroundColor = [UIColor clearColor];
    } else {
        [self.minInput setFrame:CGRectMake(minPoint.x, (center.y-21), 50, 21)];
        self.minInput.text = @"-100"; self.minInput.backgroundColor = [UIColor clearColor];
        [self.maxInput setFrame:CGRectMake((maxPoint.x-50), (center.y-21), 50, 21)];
        self.maxInput.text = @"100"; self.maxInput.backgroundColor = [UIColor clearColor]; self.maxInput.textAlignment = NSTextAlignmentRight;
        double adjust = minPoint.y-maxPoint.y;
        if(adjust < 21)
        {
            adjust=(21-adjust)/2;
            minPoint.y += adjust;
            maxPoint.y -= adjust;
        }
        [self.minOutput setFrame:CGRectMake(center.x+2, (minPoint.y-10), 50, 21)];
        self.minOutput.text = [NSString stringWithFormat:@"%.1f",gradient*-100]; self.minOutput.backgroundColor = [UIColor clearColor];
        [self.maxOutput setFrame:CGRectMake(center.x+2, (maxPoint.y-10), 50, 21)];
        self.maxOutput.text = [NSString stringWithFormat:@"%.1f",gradient*100]; self.maxOutput.backgroundColor = [UIColor clearColor];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
   
    // if the delegate has been set call this, otherwise there will be an issue
    if(super.delegate)
    {
         // get the graphics context back
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self drawLineWithGradient:[super.delegate getOutputvDisturbance] withLimit:[super.delegate getLimitValue] onContext:context];
    }
}

@end
