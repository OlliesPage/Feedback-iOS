//
//  simpleFeedbackModel.h
//  Feedback
//
//  Created by Oliver Hayman on 05/02/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface simpleFeedbackModel : NSObject

- (void)setVariables:(NSString *)variable value:(NSNumber *)value;
- (double)calculateOutput:(float)input withDistrubance:(float)disturbance;
- (double)minOutputWithDisturbance:(float) disturbance;
- (double)maxOutputWithDisturbance:(float) disturbance;
@end
