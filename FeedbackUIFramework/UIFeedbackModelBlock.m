//
//  UIFeedbackModelBlock.m
//  Feedback
//
//  Created by Oliver Hayman on 03/08/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import "UIFeedbackModelBlock.h"

@implementation UIFeedbackModelBlock

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOpacity = 0.8;
    [self setBackgroundColor:[UIColor whiteColor]];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.5);
    [[UIColor redColor] setStroke];
    CGContextMoveToPoint(context, 5, self.bounds.size.height*0.40);
    // start at the side somewhere
    CGContextAddCurveToPoint(context, 5, self.bounds.size.height*0.40, self.bounds.size.width*0.5, -10, self.bounds.size.width-5, self.bounds.size.height*0.40);
    CGContextMoveToPoint(context, 5, self.bounds.size.height*0.60);
    CGContextAddCurveToPoint(context, 5, self.bounds.size.height*0.60, self.bounds.size.width*0.5, self.bounds.size.height+9, self.bounds.size.width-5, self.bounds.size.height*0.60);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.bounds.size.width-3, self.bounds.size.height*0.45);
    CGContextAddLineToPoint(context, self.bounds.size.width-15, self.bounds.size.height*0.40);
    CGContextAddLineToPoint(context, self.bounds.size.width-10, self.bounds.size.height*0.15);
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 3, self.bounds.size.height*0.55);
    CGContextAddLineToPoint(context, 15, self.bounds.size.height*0.60);
    CGContextAddLineToPoint(context, 10, self.bounds.size.height*0.85);
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextFillPath(context);
    CGContextStrokePath(context);
}


@end
