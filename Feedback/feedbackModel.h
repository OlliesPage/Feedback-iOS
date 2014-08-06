//
//  feedbackModel.h
//  blockDevices
//
//  Created by Oliver Hayman on 23/05/2012.
//  Updated by Oliver Hayman on 28/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface feedbackModel : NSObject

- (void)setLimitValue:(double)value;
- (double)getLimitValue;

- (NSDictionary *)getForwardDictionary;
- (NSDictionary *)getLoopDictionary;

- (void)addBlockDevicesWithForwardDevices:(NSArray *)forwardDevices WithLoopDevices:(NSArray *)loopDevices;
- (void)addBlockDevice:(BlockDevice *)device onLevel:(int)level; // the level is 0 for forward, 1 for loop
- (void)setBlockDeviceWithName:(NSString *)name value:(double)value onLevel:(int)level;
- (BlockDevice *)getBlockDeviceWithName:(NSString *)name onLevel:(int)level;
- (void)resetModel;
- (void)resetCache;

- (double)calculateOutputForInput:(float)input withDistrubance:(float)disturbance;
- (double)minOutputWithDisturbance:(float)disturbance;
- (double)maxOutputWithDisturbance:(float)disturbance;
- (double)outputVdisturbanceGradient;
- (BOOL)isFeedbackNegative;
- (BOOL)isLimitingAtInput:(float)input;
@end