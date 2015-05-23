//
//  feedbackModel.h
//  blockDevices
//
//  Created by Oliver Hayman on 23/05/2012.
//  Updated by Oliver Hayman on 28/07/2014.
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