//
//  simpleFeedbackModel.m
//  Feedback
//
//  Created by Oliver Hayman on 05/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "simpleFeedbackModel.h"

@interface simpleFeedbackModel()
@property (nonatomic, strong) NSMutableDictionary *feedbackSystem;
@end;

@implementation simpleFeedbackModel

@synthesize feedbackSystem = _feedbackSystem;

- (NSDictionary *)feedbackSystem
{
    if(_feedbackSystem == nil) _feedbackSystem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[NSNumber alloc] initWithInt:11],@"controller",[[NSNumber alloc] initWithInt:9],@"device",[[NSNumber alloc] initWithDouble:-0.2],@"sensor", nil];
    return _feedbackSystem;
}

- (void)setVariables:(NSString *)variable value:(NSNumber *)value
{
    // if value for key does not return nil, it exists, therefore replace it
    if([[self.feedbackSystem valueForKey:variable] isKindOfClass:[NSNumber class]])
    {
        [self.feedbackSystem setValue:value forKey:variable];
    }
}

- (double)calculateOutput:(float)input withDistrubance:(float)disturbance;
{
    double output;
    double oneMinusLoop;
    oneMinusLoop = 1-([[self.feedbackSystem valueForKey:@"controller"] doubleValue]*[[self.feedbackSystem valueForKey:@"device"] doubleValue]*[[self.feedbackSystem valueForKey:@"sensor"] doubleValue]);
    output = ([[self.feedbackSystem valueForKey:@"controller"] doubleValue]*[[self.feedbackSystem valueForKey:@"device"] doubleValue]/oneMinusLoop)*input;
    output += (1/oneMinusLoop)*disturbance; // add the disturbance when input=0
    return output;
}

- (double)minOutputWithDisturbance:(float)disturbance
{
    return [self calculateOutput:-10 withDistrubance:disturbance];
}

- (double)maxOutputWithDisturbance:(float)disturbance
{
    return [self calculateOutput:10 withDistrubance:disturbance];
}

@end
