//
//  VerticalUISlider.m
//  Feedback
//
//  Created by Oliver Hayman on 15/05/2012.
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

#import "UIVerticalSlider.h"

@implementation UIVerticalSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // rotate the slider by 270 degrees - this was originally in the drawRect but it had issues
        self.transform = CGAffineTransformRotate(self.transform, 270.0/180*M_PI);
        self.translatesAutoresizingMaskIntoConstraints = false;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // rotate the slider by 270 degrees - this was originally in the drawRect but it had issues
        self.transform = CGAffineTransformRotate(self.transform, 270.0/180*M_PI);
        self.translatesAutoresizingMaskIntoConstraints = false;
    }
    return self;
}
@end
