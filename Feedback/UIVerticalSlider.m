//
//  VerticalUISlider.m
//  Feedback
//
//  Created by Oliver Hayman on 15/05/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "UIVerticalSlider.h"

@implementation UIVerticalSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // rotate the slider by 270 degrees - this was originally in the drawRect but it had issues
        self.transform = CGAffineTransformRotate(self.transform, 270.0/180*M_PI);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // rotate the slider by 270 degrees - this was originally in the drawRect but it had issues
        self.transform = CGAffineTransformRotate(self.transform, 270.0/180*M_PI);
    }
    return self;
}
@end
