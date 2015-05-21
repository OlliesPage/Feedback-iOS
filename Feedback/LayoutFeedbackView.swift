//
//  LayoutFeedbackView.swift
//  Feedback
//
//  Created by Oliver Hayman on 20/05/2015.
//  Copyright (c) 2015 OlliesPage. All rights reserved.
//

import UIKit
import FeedbackUIFramework


class LayoutFeedbackView {
    // MARK: Variable definitions
    
    private let view: UIView
    private let sysModel: feedbackModel
    
    // MARK:- Initalizer methods
    
    required init(aView: UIView, aModel: feedbackModel)
    {
        view = aView
        sysModel = aModel
    }
    
}