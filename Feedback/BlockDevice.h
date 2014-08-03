//
//  BlockDevice.h
//  Feedback
//
//  Created by Oliver Hayman on 16/07/2012.
//  Updated by Oliver Hayman on 01/08/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockDevice : NSObject
@property (strong) NSString *name;
@property (strong) NSNumber *value;
@property (strong, nonatomic) NSNumber *type;

+ (instancetype)blockWithName:(NSString *)name andValue:(NSNumber *)value;

-(instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithName:(NSString *)name andValue:(NSNumber *)value;
@end
