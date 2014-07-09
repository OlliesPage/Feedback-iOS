//
//  GraphView.h
//  Feedback
//
//  Created by Oliver Hayman on 18/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDelegate <NSObject>
- (double)getMaxValue;
- (double)getMinValue;
- (double)getLimitValue;
- (double)getOutputvDisturbance;
@end

@interface GraphView : UIView
@property (weak, nonatomic) id <GraphViewDelegate> delegate;
- (void)drawLineWithMaxValue:(double)max andMinValue:(double)min withLimit:(double)limit onContext:(CGContextRef)context; // must be overwritten by a subclass and will only be run if delegate is set
- (void)drawLineWithGradient:(double)gradient withLimit:(double)limit onContext:(CGContextRef)context; // must be overwritten by a subclass and will only be run if delegate is set
@end
