//
//  FeedbackSystemBlockDevice.swift
//  Feedback
//
//  Created by Oliver Hayman on 08/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

import Foundation

@objc class FeedbackSystemBlockDevice: BlockDevice {
    let systemModel: feedbackModel?
    override var value: NSNumber! {
        get {
            return NSNumber.numberWithDouble(systemModel!.calculateOutputForInput(1, withDistrubance: 0))
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