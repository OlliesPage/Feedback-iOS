//
//  EmbeddedFeedbackModelViewController.swift
//  Feedback
//
//  Created by Ollie Hayman on 05/08/2014.
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

import UIKit
import FeedbackUIFramework

class EmbeddedFeedbackModelViewController: UIViewController, UILimitBlockDelegate {
    // MARK: Instance variables
    var sysModel: feedbackModel?
    
    var blocksOnScreen = Array<Dictionary<Int,String>>()
    let textFieldDelegate = TextFieldDelegate()
    var disturbSlider:UISlider?
    var disturbLabel: UILabel? // only the disturbance needs a label
    
    var limitBlock: UILimitBlock? = nil // not sure if I'm going to use this one or not.
    
    @IBOutlet weak var feedbackTypeLabel: UILabel!
    
    
    // MARK:- ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(sysModel != nil, "System model not set, you probably are in the wrong class")
        
        // set the feedback type for the model currently being displayed
        var fbType: String = "PLACEHOLDER"
        if sysModel!.isFeedbackNegative()
        {
            fbType = NSLocalizedString("Negative", comment:"")
        } else {
            fbType =  NSLocalizedString("Positive", comment:"")
        }
        
        feedbackTypeLabel.text = String(format: "%@: %@", NSLocalizedString("TOF", comment: "Type of feedback being modeled"), fbType )
        
        // setup the variables that are going to be used later for drawing
        let numberOfLoopBlocks = sysModel!.getLoopDictionary().count
        let hasLoop:Bool = numberOfLoopBlocks > 0
        let hasDisturbance = false
        let numberOfForwardBlocks = sysModel!.getForwardDictionary().count + (hasLoop ? 1 : 0) + (hasDisturbance ? 1 : 0)
        
        let space = self.view.frame.width-62.0 // this is the amount of room between the two sliders
        // the padding is the distance at which each element should be from each other to be uniformly spaced
        let forwardPadding:Double = Double(space)/Double(numberOfForwardBlocks+1)
        let loopPadding = Double(space)/Double(numberOfLoopBlocks+1)
        var position = 1.0
        
        if hasLoop { // if there is a loop, add a circle (and a loop bit?
            let loopBarView = UILoopBarView(frame: CGRectMake(CGFloat(forwardPadding+29), 91, CGFloat(forwardPadding*Double(numberOfForwardBlocks-1)+54), 45))
            self.view.addSubview(loopBarView)
            let circleView = UICircleView(frame: CGRectMake(CGFloat(forwardPadding-1), 57, 64.0, 64.0))
            circleView.hasBottomPlus = true
            self.view.addSubview(circleView)
            position++;
        } // fi
        
        blocksOnScreen.append(Dictionary<Int, String>()) // create a new array for this level
        
        // add the forward blocks to the screen
        for block in (sysModel!.getForwardDictionary() as! Dictionary<String, BlockDevice>).values {
            if block.type == BlockDeviceType.Block.rawValue { // woo for effective use of post increment!
                let newTextField = UITextField(frame: CGRectMake(CGFloat(6.5+(position++)*forwardPadding), 73, 49.0, 31.0))
                setupTextField(newTextField, withTag: Int(position), andText: "\(block.value!)")
                newTextField.addTarget(self, action: "forwardBlockChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
                self.view.addSubview(newTextField)
                blocksOnScreen[0].updateValue(block.name!, forKey: newTextField.tag)
            } else if block.type == BlockDeviceType.LimitBlock.rawValue {
                if limitBlock == nil
                {
                    // this limit block has it's own UITextField now so I don't need to add one, it will pop it up
                    // on touch. If the delegate is set it will use delegate methods to inform the delegate of a value
                    // change
                    limitBlock = UILimitBlock(frame: CGRectMake(CGFloat(6.5+(position++)*forwardPadding), 73, 70.0, 31.0))
                    limitBlock!.value = sysModel!.getLimitValue();
                    limitBlock!.clearsContextBeforeDrawing = true
                    limitBlock!.tag = Int(position)
                    limitBlock!.delegate = self
                    self.view.addSubview(limitBlock!)
                    blocksOnScreen[0].updateValue(block.name!, forKey: limitBlock!.tag)
                }
            } else if block.type == BlockDeviceType.SysModelBlock.rawValue {
                // why not just sove something on the screen thar kids
                let sysModelBlock = UIFeedbackModelBlock(frame: CGRectMake(CGFloat(6.5+(position++)*forwardPadding), 73, 70.0, 31.0))
                let sysModelTap = UITapGestureRecognizer(target: self, action: "showEmbeddedModel:")
                sysModelBlock.addGestureRecognizer(sysModelTap)
                sysModelBlock.tag = Int(position)
                self.view.addSubview(sysModelBlock)
                blocksOnScreen[0].updateValue(block.name!, forKey: sysModelBlock.tag)
            } // fi
        } // rof
        
        if hasDisturbance { // if there is disturbance in the system, add another circle and the slider
            let secondCircleView = UICircleView(frame: CGRectMake(CGFloat(position*forwardPadding-1), 57, 64.0, 64.0))
            secondCircleView.hasTopPlus = true
            self.view.addSubview(secondCircleView)
            // 193, 29
            disturbSlider = UISlider(frame: CGRectMake(view.frame.width-224, 21, 193, 23))
            disturbSlider!.maximumValue = 100
            disturbSlider!.minimumValue = -100
            disturbSlider!.value = 0.0
            disturbSlider!.addTarget(self, action: "disturbanceChanged:", forControlEvents: UIControlEvents.ValueChanged)
            self.view.addSubview(disturbSlider!)
            
            // create the disturbLabel and it's gesture
            let disturbTapGest = UITapGestureRecognizer(target: self, action: "resetDisturbSlider")
            disturbLabel = UILabel(frame: CGRectMake(CGFloat(position*forwardPadding-50), 45, 60, 21))
            disturbLabel!.userInteractionEnabled = true
            disturbLabel!.adjustsFontSizeToFitWidth = true
            disturbLabel!.text = "D=0.00"
            disturbLabel!.addGestureRecognizer(disturbTapGest)
            view.addSubview(disturbLabel!)
        } // fi
        
        blocksOnScreen.append(Dictionary<Int, String>())
        // add the loop block
        position = 1.0
        for block in (sysModel!.getLoopDictionary() as! Dictionary<String, BlockDevice>).values {
            if(block.type == BlockDeviceType.Block.rawValue) {
                let newTextField = UITextField(frame: CGRectMake(CGFloat(6.5+(position++)*loopPadding), 118, 49.0, 31.0))
                setupTextField(newTextField, withTag:Int(position), andText: "\(block.value)")
                newTextField.addTarget(self, action: "loopBlockChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
                self.view.addSubview(newTextField)
                blocksOnScreen[1].updateValue(block.name, forKey: newTextField.tag)
            } else if block.type == BlockDeviceType.LimitBlock.rawValue {
                if limitBlock == nil
                {
                    limitBlock = UILimitBlock(frame: CGRectMake(CGFloat(6.5+(position++)*forwardPadding), 73, 70.0, 31.0))
                    limitBlock!.value = sysModel!.getLimitValue();
                    limitBlock!.clearsContextBeforeDrawing = true
                    limitBlock!.tag = Int(position)
                    limitBlock!.delegate = self
                    self.view.addSubview(limitBlock!)
                    blocksOnScreen[0].updateValue(block.name, forKey: limitBlock!.tag)
                }
            }// fi
        } // rof
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doReturn() {
        println("Returning")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupTextField(newTextField: UITextField, withTag tag: Int, andText text: String) {
        newTextField.borderStyle = UITextBorderStyle.RoundedRect
        newTextField.textAlignment = NSTextAlignment.Center
        newTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        newTextField.returnKeyType = UIReturnKeyType.Done
        newTextField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        newTextField.enablesReturnKeyAutomatically = true
        newTextField.autocorrectionType = UITextAutocorrectionType.No
        newTextField.delegate = textFieldDelegate
        newTextField.tag = tag
        newTextField.text = text
    }
    
    // MARK:- UILimitBlockDelegate
    func limitChange(sender: AnyObject!)
    {
        sysModel!.setLimitValue(sender.value);
    }
    
    func forwardBlockChanged(sender:UITextField) {
        return blockValueChanged(sender, level: 0)
    }
    
    func loopBlockChanged(sender: UITextField) {
        return blockValueChanged(sender, level: 1)
    }
    
    func blockValueChanged(sender: UITextField, level: Int32) {
        if let name = blocksOnScreen[Int(level)][sender.tag] {
            println("\(name) was tapped")
            sysModel!.setBlockDeviceWithName(name, value: (sender.text as NSString).doubleValue, onLevel: level)
            var fbType: String = "PLACEHOLDER"
            if sysModel!.isFeedbackNegative()
            {
                fbType = NSLocalizedString("Negative", comment:"")
            } else {
                fbType =  NSLocalizedString("Positive", comment:"")
            }
            
            feedbackTypeLabel.text = String(format: "%@: %@", NSLocalizedString("TOF", comment: "Type of feedback being modeled"), fbType )
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
