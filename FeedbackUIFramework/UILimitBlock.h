//
//  UILimitBlock.h
//  Feedback
//
//  Created by Oliver Hayman on 29/07/2012.
//  Updated by Oliver Hayman on 29/07/2014.
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol UILimitBlockDelegate <NSObject>

- (IBAction)limitChange:(id)sender;

@end

IB_DESIGNABLE
@interface UILimitBlock : UIView
@property IBInspectable BOOL limiting;
@property (nonatomic) IBInspectable double value;
@property (weak) id<UILimitBlockDelegate> delegate;
- (void)hideSelf;
@end
