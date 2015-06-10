//
//  UILoopBarView.swift
//  Feedback
//
//  Created by Oliver Hayman on 09/07/2014.
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
import UIKit

class UILoopBarView: UIView {
    override init(frame: CGRect)  {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: (231.0/255.0), alpha: 0)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: (231.0/255.0), alpha: 0)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func drawRect(rect: CGRect) {
        // here we're going to draw a line the middle of the way down the rect
        let context = UIGraphicsGetCurrentContext()
        UIColor.blackColor().setStroke()
        CGContextSetLineWidth(context, UIScreen.mainScreen().scale*1.5)
        CGContextMoveToPoint(context, 2, 0)
        CGContextAddLineToPoint(context, 2, rect.size.height-2)
        CGContextAddLineToPoint(context, rect.size.width-2, rect.size.height-2)
        CGContextAddLineToPoint(context, rect.size.width-2, 0)
        CGContextStrokePath(context)
    }
}