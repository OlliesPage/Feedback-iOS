//
//  LayoutFeedbackView.swift
//  Feedback
//
//  Created by Oliver Hayman on 20/05/2015.
//  Copyright (c) 2015 OlliesPage.
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

import UIKit
import FeedbackUIFramework


class LayoutFeedbackView {
    // MARK: Variable definitions
    
    private let parentController:UIViewController
    private let view: UIView
    private let sysModel: feedbackModel
    private let traitCollection: UITraitCollection
    private var ioSliders = false
    
    // hold onto weak copies of these
    private weak var inputSlider: UIVerticalSlider?
    private weak var outputSlider: UIVerticalSlider?
    private let backBarView = UIBackBarView()
    
    // MARK:- Initalizer methods
    
    required init(parentController aController: UIViewController, systemModel aModel: feedbackModel)
    {
        parentController = aController
        view = aController.view
        sysModel = aModel
        self.traitCollection = aController.traitCollection
    }
    
    // MARK:- Layout basic UI
    
    func layoutBasicUI(inputSlider inputSlider: UIVerticalSlider, outputSlider: UIVerticalSlider, infoButton: UIButton, selectModelButton: UIButton, descriptionLabel: UITextView? = nil)
    {
        self.inputSlider = inputSlider
        self.outputSlider = outputSlider
        layoutIOSliders(inputSlider: inputSlider, outputSlider: outputSlider)
        layoutInfoButton(infoButton, rightOf: outputSlider)
        layoutSelectModelButton(selectModelButton, leftOf: inputSlider)
        
        // add a backBar
        view.addSubview(backBarView)
        view.sendSubviewToBack(backBarView)
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 64))
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 57))
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Left, relatedBy: .Equal, toItem: (ioSliders ? inputSlider : view), attribute: (ioSliders ? .CenterX : .Left), multiplier: 1.0, constant: (ioSliders ? 0.0 : inputSlider.bounds.height)))
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Right, relatedBy: .Equal, toItem: (ioSliders ? outputSlider : view), attribute: (ioSliders ? .CenterX : .Right), multiplier: 1.0, constant: (ioSliders ? 0.0 : -1*outputSlider.bounds.height)))
        
        // If there is a description, add the label to the screen
        if let descripLabel = (ioSliders ? descriptionLabel : nil) {
            view.addSubview(descripLabel)
            view.sendSubviewToBack(descripLabel)
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Left, relatedBy: .Equal, toItem: inputSlider, attribute: .CenterX, multiplier: 1.0, constant: 0.5*inputSlider.bounds.height-5))
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Right, relatedBy: .Equal, toItem: outputSlider, attribute: .CenterX, multiplier: 1.0, constant: -0.5*outputSlider.bounds.height+5))
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoButton, attribute: .Top, multiplier: 1.0, constant: -10.0))
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 20.0))
        }
    }
    
    // MARK: Layout individual IO and buttons
    
    func layoutIOSliders(inputSlider inputSlider: UIVerticalSlider, outputSlider: UIVerticalSlider)
    {
        // Setup the sliders for input and output.
        inputSlider.maximumValue = 10
        inputSlider.minimumValue = -10
        inputSlider.value = 0
        // Finally connect the input slider to the inputChanged action!
        inputSlider.addTarget(parentController, action: "inputChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Now setup the outputSlider
        outputSlider.maximumValue = 10
        outputSlider.minimumValue = -10
        outputSlider.value = 0
        outputSlider.enabled = false
        outputSlider.tintColor = UIColor.lightGrayColor()
        
        view.addSubview(inputSlider)
        view.addSubview(outputSlider)
        // Ok, now we do some magic to make these bad boys look right... and this is before the logic to make the
        // feedback model get laid out... This "Modern" method seems a lot more cluttered than the old resizing
        // masks ever did. Oh well... We must do what we must do.
        view.addConstraint(NSLayoutConstraint(item: inputSlider, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.90, constant: 0.0))
        let constant:CGFloat = -1.0*((0.90*view.bounds.size.height/2)-(inputSlider.intrinsicContentSize().height/2))
        NSLog("height: %f", constant);
        view.addConstraint(NSLayoutConstraint(item: inputSlider, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier:1.0, constant: constant))
        view.addConstraint(NSLayoutConstraint(item: inputSlider, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // Now we need to fix the output slider. Again, we use the same principles as above.
        view.addConstraint(NSLayoutConstraint(item: outputSlider, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.90, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: outputSlider, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -1.0*constant))
        view.addConstraint(NSLayoutConstraint(item: outputSlider, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        // mark that the ioSliders have been layed out
        ioSliders = true
    }
    
    func layoutInfoButton(infoButton: UIButton, rightOf outputSlider: UIVerticalSlider? = nil)
    {
        if ioSliders && outputSlider != nil {
            // Now position the infoButton relative to the slider. Due to the height of the slider really being it's width, we want half this value which is actually the center in the X axis (by auto-layout) so that's used to position the button on top of the slider just off center. Then by using the height (the fixed height of a normal UISlider) the button can be adjusted to sit nicely at the side.
            view.addConstraint(NSLayoutConstraint(item: infoButton, attribute: .Right, relatedBy: .Equal, toItem: outputSlider, attribute: .CenterX, multiplier: 1.0, constant: -0.75*outputSlider!.bounds.height))
        } else {
            view.addConstraint(NSLayoutConstraint(item: infoButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -15.0))
        }
    }
    
    func layoutSelectModelButton(selectModelButton: UIButton, leftOf inputSlider: UIVerticalSlider? = nil)
    {
        if ioSliders && inputSlider != nil {
            view.addConstraint(NSLayoutConstraint(item: selectModelButton, attribute: .Left, relatedBy: .Equal, toItem: inputSlider, attribute: .CenterX, multiplier: 1.0, constant: 0.75*inputSlider!.bounds.height))
        } else {
            view.addConstraint(NSLayoutConstraint(item: selectModelButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1.0, constant: 15.0))
        }
    }
    
    func layoutIOLabels(inputLabel inputLabel: UILabel, outputLabel: UILabel)
    {
        // verify it makes sence to add teh labels
        if ioSliders {
            view.addSubview(inputLabel)
            outputLabel.frame = CGRectMake(view.frame.width-75, 57, 50.0, 21.0)
            view.addSubview(outputLabel)
        }
    }
    
    // MARK:- Layout the feedback model
    func layoutFeedbackModel(usingJsonModel jsonModel:JSONFeedbackModel)
    {
        // ok, we're going to try setting them up here, and then using target action to pass them back
        let hasLoop = jsonModel.loop.count > 0
        let hasDisturbance = jsonModel.hasDisturbance
        
        // create an array to hold the inputs
        var viewArray = Array<UIView>()
        
        if hasLoop {
            // setup the loop
            let loopBarView = UILoopBarView()
            view.addSubview(loopBarView)
            // setup the loop bar view
            view.addConstraint(NSLayoutConstraint(item: loopBarView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: -UIScreen.mainScreen().scale*10))
            view.addConstraint(NSLayoutConstraint(item: loopBarView, attribute: .Top, relatedBy: .Equal, toItem: backBarView, attribute: .Top, multiplier: 1.0, constant: 33.0))
            view.addConstraint(NSLayoutConstraint(item: loopBarView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1.0, constant: -54.0))
            
            // next setup the circle view
            let circleView = UICircleView()
            circleView.hasBottomPlus = true
            view.addSubview(circleView)
            view.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 64))
            view.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 64))
            view.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Top, relatedBy: .Equal, toItem: backBarView, attribute: .Top, multiplier: 1.0, constant: 0.0))
            viewArray.append(circleView)
            
            view.addConstraint(NSLayoutConstraint(item: loopBarView, attribute: .Left, relatedBy: .Equal, toItem: circleView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        }
        
        var forwardDict = Dictionary<Int, String>()
        var position: Int = 2
        for (name, type, value) in jsonModel.forward {
            if type == .Block {
                let blockUI = UITextField()
                view.addSubview(blockUI)
                setupBlockUI(blockUI, withTag: position++, andText: "\(value!)") // effective usage of post increment
                blockUI.addTarget(parentController, action: "forwardBlockChanged:", forControlEvents: .EditingDidEnd)
                forwardDict.updateValue(name!, forKey: Int(blockUI.tag))
                viewArray.append(blockUI)
            }
        }
        (parentController as! ModernFeedbackViewController).blocksOnScreen.append(forwardDict)
        
        if hasDisturbance {
            let circleView = UICircleView()
            circleView.hasTopPlus = true
            view.addSubview(circleView)
            view.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 64))
            view.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 64))
            view.addConstraint(NSLayoutConstraint(item: circleView, attribute: .Top, relatedBy: .Equal, toItem: backBarView, attribute: .Top, multiplier: 1.0, constant: 0.0))
            viewArray.append(circleView)
        }
        
        if let constraints = generateHorizontalSpacingConstraints(viewArray) {
            view.addConstraints(constraints)
        }
    }
    
    func generateHorizontalSpacingConstraints(viewsToLayout: Array<UIView>) -> [NSLayoutConstraint]? {
        // generate and add "invisible" views that to layout the system.
        // H:[inputSlider][spacer1(>=0)][circle][spacer2(==spacer1)][block][spacer3(==spacer1)]
        if inputSlider == nil || outputSlider == nil {
            return nil  // only let this run if there are sliders
        }
        let viewsDictionary = NSMutableDictionary()
        viewsDictionary.setObject(inputSlider!, forKey: "inputSlider")
        viewsDictionary.setObject(outputSlider!, forKey: "outputSlider")
        var constraint = "|-\(inputSlider!.bounds.height)-"
        
        // create a spacer for each input
        for var i=0; i < viewsToLayout.count; i++ {
            let spacerView = UIView.new()
            spacerView.hidden = true
            //spacerView.setTranslatesAutoresizingMaskIntoConstraints(false) DEPRECATED?
            view.addSubview(spacerView)
            // constrain the view's height to zero
            view.addConstraint(NSLayoutConstraint(item: spacerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0))
            // add the spacer and view to the dictionary
            viewsDictionary.setObject(spacerView, forKey: "spacer\(i)")
            viewsDictionary.setObject(viewsToLayout[i], forKey: "view\(i)")
            if i == 0
            {
                constraint += "[spacer\(i)(>=0)]"
            } else {
                constraint += "[spacer\(i)(==spacer0)]"
            }
            constraint += "[view\(i)]"
        }
        let spacerView = UIView.new()
        spacerView.hidden = true
        //spacerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(spacerView)
        // constrain the view's height to zero
        view.addConstraint(NSLayoutConstraint(item: spacerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 0))
        // add the spacer and view to the dictionary
        viewsDictionary.setObject(spacerView, forKey: "spacer\(viewsToLayout.count+1)")
        constraint += "[spacer\(viewsToLayout.count+1)(==spacer0)]-\(outputSlider!.bounds.height)-|"
        
        print(constraint)
        
        return NSLayoutConstraint.constraintsWithVisualFormat(constraint, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary.copy() as! Dictionary<String, AnyObject>)
    }
    
    // MARK:- Setup the text fields for blocks
    
    func setupBlockUI(blockUI: UITextField, withTag tag: Int, andText text: String) {
        blockUI.borderStyle = .RoundedRect
        blockUI.textAlignment = .Center
        blockUI.contentVerticalAlignment = .Center
        blockUI.returnKeyType = .Done
        blockUI.keyboardType = .NumbersAndPunctuation
        blockUI.enablesReturnKeyAutomatically = true
        blockUI.autocorrectionType = .No
        blockUI.tag = tag
        blockUI.text = text
        //blockUI.setTranslatesAutoresizingMaskIntoConstraints(false)
        blockUI.delegate = (parentController as! ModernFeedbackViewController).blockDelegate // connect to a new text field delegate
        view.addConstraint(NSLayoutConstraint(item: blockUI, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 31))
        view.addConstraint(NSLayoutConstraint(item: blockUI, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 49))
        view.addConstraint(NSLayoutConstraint(item: blockUI, attribute: .Top, relatedBy: .Equal, toItem: backBarView, attribute: .Top, multiplier: 1.0, constant: 15.0))
    }
    
}