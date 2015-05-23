//
//  FeedbackViewControllerProtocol.h
//  Feedback
//
//  Created by Oliver Hayman on 22/07/2012.
//  Copyright (c) 2012 OlliesPage.
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

#ifndef Feedback_FeedbackViewControllerDelegateProtocol_h
#define Feedback_FeedbackViewControllerDelegateProtocol_h

@protocol FeedbackViewControllerDelegate
- (void)setModelForwardDevices:(NSArray *)forwardDevices loopDevices:(NSArray *)loopDevices;
- (void)setDeviceValue:(NSNumber *)value forDevice:(NSString *)name onLevel:(int)level;
- (void)setLimitValue:(double)value;
- (double)calculateOutputForInput:(float)input withDisturbance:(float)disturbance;
- (BOOL)isLimitAtInput:(float)input;
@end

#endif
