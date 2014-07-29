//
//  SinGraphGLKViewController.h
//  OpenGLSinGraph
//
//  Created by Oliver Hayman on 16/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@protocol GraphGestureResizeDelegate <NSObject>
- (void)setYScale:(GLfloat)scale;
- (void)gestureDidFinish;
@end

@interface SinGraphGLKViewController : GLKViewController

@property (weak) id<GraphGestureResizeDelegate> guestureDelegate;
@property (weak) SinGraphGLKViewController *twin;

- (void)setGraphData:(GLKVector2[])data withSize:(size_t)size;
- (void)scaleX:(GLfloat)scale;
@end