//
//  limitView.m
//  Feedback
//
//  Created by Oliver Hayman on 29/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "limitBlock.h"

@implementation limitView
@synthesize limiting;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {

    }
    return self;
}

- (void)hideSelf
{
    self.hidden = YES;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.8;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if(self.limiting)
        [[UIColor redColor] setStroke];
    else
        [[UIColor blackColor] setStroke];
    CGContextMoveToPoint(context, 0, self.bounds.size.height*0.75);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.25, self.bounds.size.height*0.75);
    CGContextAddLineToPoint(context, self.bounds.size.width*0.75, self.bounds.size.height*0.25);
    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height*0.25);
    CGContextStrokePath(context);
}

@end
