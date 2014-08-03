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
    [self setBackgroundColor:[UIColor redColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

}*/


@end
