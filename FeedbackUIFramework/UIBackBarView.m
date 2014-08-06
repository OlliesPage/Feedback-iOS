//
//  UIBackBarView.m
//  Feedback
//
//  Created by Ollie Hayman on 05/08/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
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
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 4.0);
    CGContextMoveToPoint(context, 0, (rect.size.height/2));
    CGContextAddLineToPoint(context, rect.size.width, (rect.size.height/2));
    CGContextStrokePath(context);
}

@end
