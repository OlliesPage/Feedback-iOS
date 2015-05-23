//
//  SinGraphGLKViewController.h
//  OpenGLSinGraph
//
//  Created by Oliver Hayman on 16/07/2014.
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
#import <GLKit/GLKit.h>

@protocol GraphGestureResizeDelegate <NSObject>
- (void)setYScale:(GLfloat)scale;
- (void)setPhase:(GLfloat)degrees;
- (void)gestureDidFinish;
@end

@interface SinGraphGLKViewController : GLKViewController

@property (weak) id<GraphGestureResizeDelegate> gestureDelegate;
@property (weak) SinGraphGLKViewController *twin;

- (void)setGraphData:(GLKVector2[])data withSize:(size_t)size;
- (void)scaleX:(GLfloat)scale;
@end