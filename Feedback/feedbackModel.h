//
//  feedbackModel.h
//  blockDevices
//
//  Created by Oliver Hayman on 23/05/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feedbackModel : NSObject
@property (strong, nonatomic) NSMutableDictionary *forwardDict;
@property (strong, nonatomic) NSMutableDictionary *loopDict;

- (void)setLimitValue:(double)value;
- (double)getLimitValue;

- (void)addBlockDevicesWithForwardDevices:(NSArray *)forwardDevices WithLoopDevices:(NSArray *)loopDevices;
- (void)addBlockDevice:(NSBlockDevice *)device onLevel:(int)level; // the level is 0 for forward, 1 for loop
- (void)setBlockDeviceWithName:(NSString *)name value:(double)value onLevel:(int)level;
- (void)resetModel;

- (double)calculateOutputForInput:(float)input withDistrubance:(float)disturbance;
- (double)minOutputWithDisturbance:(float)disturbance;
- (double)maxOutputWithDisturbance:(float)disturbance;
- (double)outputVdisturbanceGradient;
- (BOOL)isFeedbackNegative;
- (BOOL)isLimitingAtInput:(float)input;
@end