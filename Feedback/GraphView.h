//
//  GraphView.h
//  Feedback
//
//  Created by Oliver Hayman on 18/07/2012.
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
