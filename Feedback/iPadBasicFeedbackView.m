//
//  iPadFeedbackView.m
//  Feedback
//
//  Created by Oliver Hayman on 28/03/2012.
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

#import "iPadBasicFeedbackView.h"

@implementation iPadBasicFeedbackView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint screenBoundry;
    screenBoundry.x = self.bounds.size.width;
    screenBoundry.y = self.bounds.size.height;
    [[UIColor blackColor] setStroke];
    CGPoint center;
    center.x= 130;center.y = (screenBoundry.y/2-100);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 15, center.y);
    CGContextSetLineWidth(context, 4.0);
    CGContextAddLineToPoint(context, 100, center.y); // line from the edge of the screen to the circle
    CGContextStrokePath(context);
    [self drawCircleAtPoint:center plusAtTop:NO plusAtBottom:YES inContext:context];
    CGContextMoveToPoint(context, center.x+30, center.y);
    CGContextAddLineToPoint(context, 230, center.y); // lines after the circle to the first box
    
    CGContextMoveToPoint(context, 290, center.y);
    CGContextAddLineToPoint(context, 430, center.y); // line between the top two boxes
    
    
    CGContextMoveToPoint(context, 490, center.y);
    CGContextAddLineToPoint(context, 550, center.y); // draw the line to the second circle
    CGContextStrokePath(context);
    center.x = 580;
    [self drawCircleAtPoint:center plusAtTop:YES plusAtBottom:NO inContext:context];
    
    CGContextMoveToPoint(context, center.x, center.y-30);
    CGContextAddLineToPoint(context, center.x, center.y-75); // add line from second circle to disturbance slider
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, center.x+30, center.y);
    CGContextAddLineToPoint(context, screenBoundry.x-15, center.y); // add line from second circle to output
    CGContextMoveToPoint(context, center.x+50, center.y);
    CGContextAddLineToPoint(context, center.x+50, center.y+100); // add line from output line to input circle
    CGContextAddLineToPoint(context, 130, center.y+100); // the under middle of the line
    CGContextAddLineToPoint(context, 130, center.y+30); // up to the circle
    CGContextStrokePath(context);
}

@end
