//
//  UILoopBarView.swift
//  Feedback
//
//  Created by Oliver Hayman on 09/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

import Foundation
import UIKit

class UILoopBarView: UIView {
    init(frame: CGRect)  {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: (231.0/255.0), alpha: 1)
    }
    
    override func drawRect(rect: CGRect) {
        // here we're going to draw a line the middle of the way down the rect
        var context = UIGraphicsGetCurrentContext()
        UIColor.blackColor().setStroke()
        CGContextSetLineWidth(context, 4.0)
        CGContextMoveToPoint(context, 2, 0)
        CGContextAddLineToPoint(context, 2, rect.size.height-2)
        CGContextAddLineToPoint(context, rect.size.width-2, rect.size.height-2)
        CGContextAddLineToPoint(context, rect.size.width-2, 0)
        CGContextStrokePath(context)
    }
}