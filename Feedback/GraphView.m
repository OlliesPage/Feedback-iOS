//
//  GraphView.m
//  Feedback
//
//  Created by Oliver Hayman on 18/07/2012.
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
