//
//  UIReadOnlyTextView.m
//  Feedback
//
//  Created by Oliver Hayman on 08/11/2012.
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

#import "UIReadOnlyTextView.h"

@implementation UIReadOnlyTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return NO; // this should stop any form of keyboard selection
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if([[sender class] isSubclassOfClass:[UIGestureRecognizer class]])
        return [super canPerformAction:action withSender:sender];
    else
        return NO;
} // this limits the selectors that can be used to only UIGestures

@end
