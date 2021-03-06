//
//  BlockDevice.m
//  Feedback
//
//  Created by Oliver Hayman on 16/07/2012.
//  Updated by Oliver Hayman on 01/08/2014.
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

#import "BlockDevice.h"

@implementation BlockDevice
@synthesize name = _name;
@synthesize value = _value;
@synthesize type = _type;

+ (BlockDevice *)blockWithName:(NSString *)name andValue:(NSNumber *)value
{
    return [[BlockDevice alloc] initWithName:name andValue:value];
}

- (instancetype)init
{
    return [self initWithName:@"Unknown"]; // give a default name
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
    if(type.intValue < 3)
    {
        _type = type;
    }
}
@end
