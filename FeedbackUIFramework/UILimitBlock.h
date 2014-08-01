//
//  limitView.h
//  Feedback
//
//  Created by Oliver Hayman on 29/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
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
