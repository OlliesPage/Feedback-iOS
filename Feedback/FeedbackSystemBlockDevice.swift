//
//  FeedbackSystemBlockDevice.swift
//  Feedback
//
//  Created by Oliver Hayman on 08/07/2014.
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

import Foundation

@objc class FeedbackSystemBlockDevice: BlockDevice {
    let systemModel: feedbackModel?
    override var value: NSNumber! {
        get {
            return NSNumber(double: systemModel!.calculateOutputForInput(1, withDistrubance: 0))
        }
        set {
            // we should never be setting this value, therefore it's always going to raise an exception when you try
            NSException(name: "FeedbackSystemBlockDeviceValueException", reason: "Attempted to set a value for a read-only property", userInfo: nil).raise()
        }
    } // this overrides the value property, making it return the gain of the feedback model
    
    @objc init(name: String!, andSystem model: feedbackModel!) {
        systemModel = model // setup the system model
        super.init(name: name) // we're going to init with name, but value is not used yet so.
        type = 2 // this is a SysModelBlock
    }
}