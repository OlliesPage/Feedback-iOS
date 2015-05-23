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
    private var ioSliders = false
    
    // hold onto weak copies of these
    private weak var inputSlider: UIVerticalSlider?
    private weak var outputSlider: UIVerticalSlider?
    
    // MARK:- Initalizer methods
    
    required init(aView: UIView, aModel: feedbackModel)
    {
        view = aView
        sysModel = aModel
    }
    
    // MARK:- Layout basic UI
    
    func layoutBasicUI(#inputSlider: UIVerticalSlider, outputSlider: UIVerticalSlider, infoButton: UIButton, selectModelButton: UIButton, descriptionLabel: UITextView? = nil)
    {
        self.inputSlider = inputSlider
        self.outputSlider = outputSlider
        layoutIOSliders(inputSlider: inputSlider, outputSlider: outputSlider)
        layoutInfoButton(infoButton, rightOf: outputSlider)
        layoutSelectModelButton(selectModelButton, leftOf: inputSlider)
        
        // add a backBar
        let backBarView = UIBackBarView()
        //backBarView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(backBarView)
        view.sendSubviewToBack(backBarView)
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 64))
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 57))
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Left, relatedBy: .Equal, toItem: inputSlider, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: backBarView, attribute: .Right, relatedBy: .Equal, toItem: outputSlider, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        // If there is a description, add the label to the screen
        if let descripLabel = descriptionLabel {
            view.addSubview(descripLabel)
            view.sendSubviewToBack(descripLabel)
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Left, relatedBy: .Equal, toItem: inputSlider, attribute: .CenterX, multiplier: 1.0, constant: 0.5*inputSlider.bounds.height-5))
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Right, relatedBy: .Equal, toItem: outputSlider, attribute: .CenterX, multiplier: 1.0, constant: -0.5*outputSlider.bounds.height+5))
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Bottom, relatedBy: .Equal, toItem: infoButton, attribute: .Top, multiplier: 1.0, constant: -10.0))
            view.addConstraint(NSLayoutConstraint(item: descripLabel, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 20.0))
        }
    }
    
    // MARK: Layout individual IO and buttons
    
    func layoutIOSliders(#inputSlider: UIVerticalSlider, outputSlider: UIVerticalSlider)
    {
        
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
    
    func layoutIOLabels(#inputLabel: UILabel, outputLabel: UILabel)
    {
        // verify it makes sence to add teh labels
        if ioSliders {
            view.addSubview(inputLabel)
            outputLabel.frame = CGRectMake(view.frame.width-85, 57, 54.0, 21.0)
            view.addSubview(outputLabel)
        }
    }
    
    // MARK:- Layout the feedback model
    func layoutFeedbackModel(sysModel: feedbackModel)
    {
        
    }
    
    func generateHorizontalSpacingConstraints(viewsToLayout: Array<UIView>) -> NSArray? {
        // generate and add "invisible" views that to layout the system.
        // H:[inputSlider][spacer1(>=0)][circle][spacer2(==spacer1)][block][spacer3(==spacer1)]
        if inputSlider == nil || outputSlider == nil {
            return nil // only let this run if there are sliders
        }
        let viewsDictionary = NSMutableDictionary()
        viewsDictionary.setObject(inputSlider!, forKey: "inputSlider")
        viewsDictionary.setObject(outputSlider!, forKey: "outputSlider")
        var constraint = "[inputSlider]"
        
        // create a spacer for each input
        for var i=0; i < viewsToLayout.count; i++ {
            let spacerView = UIView.new()
            spacerView.hidden = true
            spacerView.setTranslatesAutoresizingMaskIntoConstraints(false)
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
        constraint += "[spacer\(viewsToLayout.count+1)(==spacer0)][outputSlider]"
        
        return NSLayoutConstraint.constraintsWithVisualFormat(constraint, options: nil, metrics: nil, views: viewsDictionary as [NSObject : AnyObject])
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
        blockUI.delegate = TextFieldDelegate() // connect to a new text field delegate
    }
    
}