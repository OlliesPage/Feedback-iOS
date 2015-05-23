//
//  UIBackBarView.m
//  Feedback
//
//  Created by Ollie Hayman on 05/08/2014.
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

#import "UIBackBarView.h"

@implementation UIBackBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initiate];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initiate];
    }
    return self;
}

- (void)initiate
{
    self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:(231.0/255.0) alpha:1];
    self.translatesAutoresizingMaskIntoConstraints = false; // do this by default
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, [UIScreen mainScreen].scale*1.5);
    CGContextMoveToPoint(context, 0, (rect.size.height/2));
    CGContextAddLineToPoint(context, rect.size.width, (rect.size.height/2));
    CGContextStrokePath(context);
}

@end
