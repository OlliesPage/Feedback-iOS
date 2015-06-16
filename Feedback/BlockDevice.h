//
//  BlockDevice.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlockDevice : NSObject
@property (strong) NSString *name;
@property (null_unspecified, strong) NSNumber *value;
@property (strong, nonatomic) NSNumber *type;

+ (instancetype)blockWithName:(NSString *)name andValue:(NSNumber *)value;

-(instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;
-(instancetype)initWithName:(NSString *)name andValue:(NSNumber *)value;
@end

NS_ASSUME_NONNULL_END