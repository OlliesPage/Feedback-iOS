//
//  UICircleView.m
//  Feedback
//
//  Created by Oliver Hayman on 22/07/2014.
//  Copyright (c) 2014 OlliesPage.
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

#import "UICircleView.h"

@implementation UICircleView

@synthesize hasBottomPlus = _hasBottomPlus;
@synthesize hasTopPlus = _hasTopPlus;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hasBottomPlus = self.hasTopPlus = false; // default
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:(231.0/255.0) alpha:1];
        self.translatesAutoresizingMaskIntoConstraints = false;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hasBottomPlus = self.hasTopPlus = false; // default
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:(231.0/255.0) alpha:1];
        self.translatesAutoresizingMaskIntoConstraints = false;
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius plusAtTop:(BOOL)top plusAtBottom:(BOOL)bottom inContext:(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextSetLineWidth(context, 1.5*[UIScreen mainScreen].scale);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    
    // new line drawing code that uses the equation (x, y) = (center.x+radius*cos(a), center.y+radius*sin(a))
    CGContextMoveToPoint(context, p.x+radius*cos((135*M_PI)/180), p.y+radius*sin((135*M_PI)/180));
    CGContextAddLineToPoint(context, p.x+radius*cos((315*M_PI)/180), p.y+radius*sin((315*M_PI)/180));
    CGContextMoveToPoint(context, p.x+radius*cos((45*M_PI)/180), p.y+radius*sin((45*M_PI)/180));
    CGContextAddLineToPoint(context, p.x+radius*cos((225*M_PI)/180), p.y+radius*sin((225*M_PI)/180));
    CGContextStrokePath(context); // output the cross to teh screen
    
    // draw us a nice plus at the side - Note this will not be drawn to screen if there is no plus at the top or bottom
    CGContextSetLineWidth(context, [UIScreen mainScreen].scale);
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
    CGContextSetLineWidth(context, 1.5*[UIScreen mainScreen].scale);
    UIGraphicsPopContext();
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //[self.backgroundColor setFill];
    [[UIColor blackColor] setStroke];
    CGPoint center;
    center.x = rect.size.width/2;
    center.y = rect.size.height/2;
    [self drawCircleAtPoint:center withRadius:30 plusAtTop:self.hasTopPlus plusAtBottom:self.hasBottomPlus inContext:context];
}


@end
