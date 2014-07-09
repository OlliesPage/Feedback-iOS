//
//  VerticalUISlider.m
//  Feedback
//
//  Created by Oliver Hayman on 15/05/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "VerticalUISlider.h"

@implementation VerticalUISlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // rotate the slider by 270 degrees - this was originally in the drawRect but it had issues
        self.transform = CGAffineTransformRotate(self.transform, 270.0/180*M_PI);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // rotate the slider by 270 degrees - this was originally in the drawRect but it had issues
        self.transform = CGAffineTransformRotate(self.transform, 270.0/180*M_PI);
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}*/


@end
