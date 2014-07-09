//
//  CustomModelViewController.swift
//  Feedback
//
//  Created by Oliver Hayman on 07/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

import Foundation
import UIkit

class CustomModelViewController:UIViewController {
    let sysModel = feedbackModel()
    let pathToFile = NSBundle.mainBundle().pathForResource("basic", ofType: "json")
    let jsonParser:JSONFeedbackModel
    var blocksOnScreen = Array<Dictionary<Int,String>>() //Dictionary<Int, Dictionary<UITextView,String>>(minimumCapacity: 1)
    let textFieldDelegate = TextFieldDelegate()
    
    @IBOutlet var inputSlider: VerticalUISlider
    @IBOutlet var outputSlider: VerticalUISlider
    
    // this is for storyboards
    init(coder aDecoder: NSCoder!)  {
        jsonParser = JSONFeedbackModel(sysModel: sysModel, pathToModel: pathToFile)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()  {
        let hasLoop:Bool = jsonParser.loop.count > 0
        let usesDisturbance = true
        let numberOfForwardBlocks = jsonParser.forward.count + (hasLoop ? 1 : 0 )
        let numberOfLoopBlocks = jsonParser.loop.count
        
        println("there are \(numberOfForwardBlocks) devices")
        
        let space = self.view.frame.width-62.0 // this is the amount of room between the two sliders
        // the padding is the distance at which each element should be from each other to be uniformly spaced
        let forwardPadding:Double = Double(space)/Double(numberOfForwardBlocks+2)
        let loopPadding = Double(space)/Double(numberOfLoopBlocks+1)
        
        if hasLoop { // if there is a loop, add a circle (and a loop bit?
            let circleView = UICircleView(frame: CGRectMake(CGFloat(forwardPadding-1), 57, 64.0, 64.0))
            circleView.hasBottomPlus = true
            self.view.addSubview(circleView)
        } // fi
        
        blocksOnScreen.append(Dictionary<Int, String>())
        
        // add the forward blocks to the screen
        var position = 2.0
        for (name, type, value) in jsonParser.forward {
            if type == "block" { // woo for effective use of post increment!
                let newTextField = UITextField(frame: CGRectMake(CGFloat(6.5+(position++)*forwardPadding), 73, 49.0, 31.0))
                setupTextField(newTextField, withTag: Int(position), andText: String(value!))
                newTextField.addTarget(self, action: "forwardBlockChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
                self.view.addSubview(newTextField)
                blocksOnScreen[0].updateValue(name!, forKey: newTextField.tag)
            } // fi
        } // rof
        
        if usesDisturbance { // if there is disturbance in the system, add another circle and the slider
            let secondCircleView = UICircleView(frame: CGRectMake(CGFloat(position*forwardPadding-1), 57, 64.0, 64.0))
            secondCircleView.hasTopPlus = true
            self.view.addSubview(secondCircleView)
        } // fi
        
        blocksOnScreen.append(Dictionary<Int, String>())
        // add the loop block
        position = 1.0
        for (name,type, value) in jsonParser.loop {
            if(type == "block") {
                let newTextField = UITextField(frame: CGRectMake(CGFloat(6.5+(position++)*loopPadding), 118, 49.0, 31.0))
                setupTextField(newTextField, withTag:Int(position), andText: String(value!))
                newTextField.addTarget(self, action: "loopBlockChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
                self.view.addSubview(newTextField)
                blocksOnScreen[1].updateValue(name!, forKey: newTextField.tag)
            } // fi
        } // rof
    }
    
    func setupTextField(newTextField: UITextField, withTag tag: Int, andText text: String) {
        newTextField.borderStyle = UITextBorderStyle.RoundedRect
        newTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        newTextField.returnKeyType = UIReturnKeyType.Done
        newTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        newTextField.enablesReturnKeyAutomatically = true
        newTextField.autocorrectionType = UITextAutocorrectionType.No
        newTextField.delegate = textFieldDelegate
        newTextField.tag = tag
        newTextField.text = text
    }
    
    @IBAction func inputChanged(sender: VerticalUISlider) {
        var output = sysModel.calculateOutputForInput(sender.value, withDistrubance: 0)
        if output > 10.0 { output = 10.0 }
        if output < -10.0 { output = -10.0 }
        outputSlider.value = Float(output)
    }
    
    func blockValueChanged(sender: UITextField, level: Int32) {
        if let name = blocksOnScreen[Int(level)][sender.tag] {
            println("\(name) was tapped")
            sysModel.setBlockDeviceWithName(name, value: sender.text.bridgeToObjectiveC().doubleValue, onLevel: level)
            inputChanged(inputSlider)
        }
    }
    
//WARNING - this doesn't allow for multiple levels of loop
    func forwardBlockChanged(sender:UITextField) {
        return blockValueChanged(sender, level: 0)
    }
    
    func loopBlockChanged(sender: UITextField) {
        return blockValueChanged(sender, level: 1)
    }
}