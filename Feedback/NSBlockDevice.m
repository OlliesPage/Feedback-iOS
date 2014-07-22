//
//  NSBlockDevice.m
//  Feedback
//
//  Created by Oliver Hayman on 16/07/2012.
//  Copyright (c) 2012 OlliesPage. All rights reserved.
//

#import "NSBlockDevice.h"

@implementation NSBlockDevice
@synthesize name = _name;
@synthesize value = _value;
@synthesize type = _type;

+ (NSBlockDevice *)blockWithName:(NSString *)name andValue:(NSNumber *)value
{
    return [[NSBlockDevice alloc] initWithName:name andValue:value];
}

- (instancetype)init
{
    return [self initWithName:@""];
}

-(instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.type = [NSNumber numberWithInt:0]; // zero is the default type
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name andValue:(NSNumber *)value
{
    self = [self initWithName:name];
    if(self)
    {
        self.value = value;
    }
    return self;
}

-(void)setType:(NSNumber *)type
{
    // here we check if the type is valid
    if(type.intValue < 2)
    {
        _type = type;
    }
}
@end
