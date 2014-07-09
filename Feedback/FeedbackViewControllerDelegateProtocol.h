//
//  FeedbackViewControllerProtocol.h
//  Feedback
//
//  Created by Oliver Hayman on 22/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#ifndef Feedback_FeedbackViewControllerDelegateProtocol_h
#define Feedback_FeedbackViewControllerDelegateProtocol_h

@protocol FeedbackViewControllerDelegate
- (void)setModelForwardDevices:(NSArray *)forwardDevices loopDevices:(NSArray *)loopDevices;
- (void)setDeviceValue:(NSNumber *)value forDevice:(NSString *)name onLevel:(int)level;
- (void)setLimitValue:(double)value;
- (double)calculateOutputForInput:(float)input withDisturbance:(float)disturbance;
- (BOOL)isLimitAtInput:(float)input;
@end

#endif
