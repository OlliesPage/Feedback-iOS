//
//  feedbackModel.m
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

#import "feedbackModel.h"
// private elements
@interface feedbackModel ()
@property (strong, nonatomic) NSMutableDictionary *forwardDict;
@property (strong, nonatomic) NSMutableDictionary *loopDict;

- (double)calculateForwardValue;
- (double)calculateOneMinusLoopValueWithForward:(double)forward;
@end

@implementation feedbackModel;
@synthesize forwardDict = _forwardDict;
@synthesize loopDict = _loopDict;

- (NSMutableDictionary *)forwardDict
{
    if(_forwardDict == nil) _forwardDict = [[NSMutableDictionary alloc] init];
    return _forwardDict;
}

- (NSMutableDictionary *)loopDict
{
    if(_loopDict == nil) _loopDict = [[NSMutableDictionary alloc] init];
    return _loopDict;
}

// limit is the current limit block value, forward and loop cache are caches of function output
#warning Only one limit block can be used in the system
double limit = 0, forwardCache=0, loopCache=0;

#pragma mark - limit

- (void)setLimitValue:(double)value
{
    limit = fabs(value); // ^__^ a simple setter
}

- (double)getLimitValue
{
    return limit; // this is a simple getter
}

- (NSDictionary *)getForwardDictionary
{
    return [self.forwardDict copy];
}

- (NSDictionary *)getLoopDictionary
{
    return [self.loopDict copy];
}

#pragma mark - privateInterfaceMethods
- (double)calculateForwardValue
{
    if(forwardCache != 0) return forwardCache;
#ifdef VERBOSE
    NSLog(@"calculating forwardValues");
#endif
    __block double forward=1;
    NSArray *values;
    if([self.forwardDict count] == 0) return forward;
#ifdef VERBOSE
    NSLog(@"There are %lu forward devices and %lu loop devices", (unsigned long)[self.forwardDict count], (unsigned long)[self.loopDict count]);
#endif
    values = [self.forwardDict allValues];
    dispatch_group_t loopGroup = dispatch_group_create(); // create a thread to do the maths on
    dispatch_queue_t loopQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_async(loopGroup, loopQueue, ^{
        for(int i=0; i<[values count];i++)
        {
            dispatch_group_async(loopGroup, loopQueue, ^{
                BlockDevice *current = [values objectAtIndex:i];
                if(current.type.intValue !=1)
                {
                    forward *= [current.value doubleValue];
                }
            });
        }
    });
    dispatch_group_wait(loopGroup, DISPATCH_TIME_FOREVER); // wait for them all to be processed
    forwardCache = forward;
    return forward;
}

- (double)calculateOneMinusLoopValueWithForward:(double)forward
{
    if([self.loopDict count] == 0) return 1;
    if(loopCache != 0) return loopCache;
#ifdef VERBOSE
    NSLog(@"calculating oneMinusLoop with forward %.2f",forward);
#endif
    __block double oneMinusLoop;
    NSArray *values;
    oneMinusLoop = forward; values = [self.loopDict allValues];
    dispatch_group_t loopGroup = dispatch_group_create();
    dispatch_queue_t loopQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_async(loopGroup, loopQueue, ^{
        for(int i=0; i<[values count]; i++)
        {
            dispatch_group_async(loopGroup, loopQueue, ^{
                BlockDevice *current = [values objectAtIndex:i];
                if(current.type.intValue != 1)
                {
                    oneMinusLoop *= [current.value doubleValue];
                }
            });
        }
    });
    dispatch_group_wait(loopGroup, DISPATCH_TIME_FOREVER); // wait for them all to be processed
    oneMinusLoop = 1-oneMinusLoop;
    loopCache = oneMinusLoop;
    return oneMinusLoop;
}

#pragma mark - publicInterfaceMethods
- (void)addBlockDevicesWithForwardDevices:(NSArray *)forwardDevices WithLoopDevices:(NSArray *)loopDevices
{
    loopCache = forwardCache = 0;
    for(int i=0; i<[forwardDevices count]; i++)
    {
        if(((BlockDevice *)[forwardDevices objectAtIndex:i]).type.intValue == 0)
            [self addBlockDevice:[forwardDevices objectAtIndex:i] onLevel:0]; // this is the forward
        else [self setLimitValue:((BlockDevice *)[forwardDevices objectAtIndex:i]).value.doubleValue];
            }
    for(int i=0; i<[loopDevices count]; i++)
    {
        [self addBlockDevice:[loopDevices objectAtIndex:i] onLevel:1]; // this is the loop
    }
}


- (void)addBlockDevice:(BlockDevice *)device onLevel:(int)level
{
    loopCache = forwardCache = 0;
    if(level == 0)
        [self.forwardDict setObject:device forKey:device.name];
    else
        [self.loopDict setObject:device forKey:device.name];
    NSLog(@"added blockDevice: %@", [device name]);
}

- (void)setBlockDeviceWithName:(NSString *)name value:(double)value onLevel:(int)level
{
    forwardCache = loopCache = 0; // make the cache stale
    // first get the block
    BlockDevice *current = level?[self.loopDict objectForKey:name]:[self.forwardDict objectForKey:name];
    if(current.value.doubleValue != value)
    {
        current.value = [NSNumber numberWithDouble:value]; // update the value
        level?[self.loopDict setObject:current forKey:name]:[self.forwardDict setObject:current forKey:name]; // save the updated value
        NSLog(@"Block value updated to %f for device %@", current.value.doubleValue, current.name);
        
    }
}

- (BlockDevice *)getBlockDeviceWithName:(NSString *)name onLevel:(int)level
{
    if (level == 0) {
        return [self.forwardDict objectForKey:name];
    } else if(level == 1) {
        return [self.loopDict objectForKey:name];
    }
    return nil; // Swift like, biatch
}

/*
 * resetModel
 * this resets the global variables for the model ready for a new feedback system to be modeled
 */
- (void)resetModel
{
    NSLog(@"-------------- Model has been reset --------------");
    forwardCache = loopCache = limit = 0; // set limit back to zero and make cache stale
    [self setForwardDict:nil]; // this will cause it to be re-alloced
    [self setLoopDict:nil]; // this will cause it to be re-alloced
}

- (void)resetCache
{
#ifdef DEBUG
    NSLog(@"-------------- Cache has been reset --------------");
#endif
    forwardCache = loopCache = 0;
}

- (double)calculateOutputForInput:(float)input withDistrubance:(float)disturbance
{
#ifdef VERBOSE
    NSLog(@"calculating output for input %.2f",input);
#endif
    double output, forward=[self calculateForwardValue], oneMinusLoop;
    if([self.forwardDict count] == 0 && [self.loopDict count] == 0)
    {
        NSLog(@"Empty model, returning input");
        return input;
    }
    oneMinusLoop = [self calculateOneMinusLoopValueWithForward:forward];
#ifdef VERBOSE
    NSLog(@"oneMinusLoop is: %.2f", oneMinusLoop);
#endif
    output = (forward/oneMinusLoop)*input;
    if(limit == 0 && disturbance == 0) return output; // this will speed things up a little
    if(limit != 0)
    {
        if(output >= limit || output <= -1*limit)
        {
            output = (output > limit)?limit:-1*limit;
            output += disturbance; // this ONLY applies at the limit
#ifdef VERBOSE
            NSLog(@"Calculated output: %.2f", output);
#endif
            return output;
        }
    }
    if(disturbance != 0.0)
        output += (1/oneMinusLoop)*disturbance; // add the disturbance when input=0
#ifdef VERBOSE
    NSLog(@"Calculated output: %.2f", output);
#endif
    return output;
}

- (double)minOutputWithDisturbance:(float)disturbance;
{
    return limit==0?[self calculateOutputForInput:-10 withDistrubance:disturbance]:-1*limit*pow([self calculateOutputForInput:1 withDistrubance:0],-1);
}

- (double)maxOutputWithDisturbance:(float)disturbance
{
    return limit==0?[self calculateOutputForInput:10 withDistrubance:disturbance]:limit*pow([self calculateOutputForInput:1 withDistrubance:0],-1);
}

- (double)outputVdisturbanceGradient
{
    return (1/[self calculateOneMinusLoopValueWithForward:[self calculateForwardValue]]);
}

- (BOOL)isFeedbackNegative
{
    // this is to determin via calculation if the feedback type is negative... oh Joy!
    double forward = [self calculateForwardValue], oneMinusLoop = [self calculateOneMinusLoopValueWithForward:forward];
    if(fabs((forward/oneMinusLoop)) < fabs(forward))
        return true; // the close loop gain is less than the open loop gain
    if(fabs(oneMinusLoop) > 1)
        return true; // reduces effect of change and disturbances
    return false;
}

- (BOOL)isLimitingAtInput:(float)input
{
    double output, forward=[self calculateForwardValue], oneMinusLoop;
    if([self.forwardDict count] == 0 || [self.loopDict count] == 0) return input;
    oneMinusLoop = [self calculateOneMinusLoopValueWithForward:forward];
    NSLog(@"oneMinusLoop is: %.2f", oneMinusLoop);
    output = (forward/oneMinusLoop)*input;
    if(limit != 0)
    {
        if(output >= limit || output <= -1*limit)
        {
            return YES;
        }
    }
    return NO;
}

@end
