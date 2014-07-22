//
//  NSBlockDevice.h
//  Feedback
//
//  Created by Oliver Hayman on 16/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBlockDevice : NSObject
@property (strong) NSString *name;
@property (strong) NSNumber *value;
@property (strong, nonatomic) NSNumber *type;

+ (instancetype)blockWithName:(NSString *)name andValue:(NSNumber *)value;

-(instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithName:(NSString *)name andValue:(NSNumber *)value;
@end
