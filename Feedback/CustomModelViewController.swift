//
//  CustomModelViewController.swift
//  Feedback
//
//  Created by Oliver Hayman on 07/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

import Foundation
import UIkit
import FeedbackUIFramework

class CustomModelViewController:UIViewController {
// MARK: Variable defintions
    let sysModel = feedbackModel()
    let pathToFile = NSBundle.mainBundle().pathForResource("basic", ofType: "json")
    let jsonParser:JSONFeedbackModel
    var blocksOnScreen = Array<Dictionary<Int,String>>() //Dictionary<Int, Dictionary<UITextView,String>>(minimumCapacity: 1)
    let textFieldDelegate = TextFieldDelegate()
    var disturbanceSlider:UISlider?
    var inputLabel: UILabel?
    var outputLabel: UILabel?
    
    @IBOutlet weak var inputSlider: VerticalUISlider!
    @IBOutlet weak var outputSlider: VerticalUISlider!
    @IBOutlet weak var showGraphButton: UIButton!
    @IBOutlet weak var feedbackTypeLabel: UILabel!
    
// MARK:- Initalizer methods
    // this is for storyboards
    init(coder aDecoder: NSCoder!)  {
        jsonParser = JSONFeedbackModel(sysModel: sysModel, pathToModel: pathToFile)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()  {
        let hasLoop:Bool = jsonParser.loop.count > 0
        let hasDisturbance = jsonParser.hasDisturbance
        let numberOfForwardBlocks = jsonParser.forward.count + (hasLoop ? 1 : 0 ) + (hasDisturbance ? 1 : 0 )
        let numberOfLoopBlocks = jsonParser.loop.count
        
        // set the feedback type for the model currently being displayed
        var fbType: String
        if sysModel.isFeedbackNegative()
        {
            fbType = NSLocalizedString("Negative", comment:nil)
        } else {
            fbType = NSLocalizedString("Positive", comment:nil)
        }
        
        feedbackTypeLabel.text = String(format: "%@: %@", NSLocalizedString("TOC", comment: "Type of feedback being modeled"), fbType )
        
        // some just in-case tweaking of the button - let it shrink it's title, but not by more than 1/2 the size
        showGraphButton.titleLabel.adjustsFontSizeToFitWidth = true;
        showGraphButton.titleLabel.minimumScaleFactor = 0.5;
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkGraphButtonLabel", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        println("there are \(numberOfForwardBlocks) devices")
        
        let backBarView = UIBackBarView(frame: CGRectMake(31, 57, view.frame.width-62, 64))
        self.view.addSubview(backBarView)
        inputLabel = UILabel(frame: CGRectMake(31, 57, 54.0, 21.0))
        inputLabel!.text = "I=0.00"
        inputLabel!.adjustsFontSizeToFitWidth = true
        inputLabel!.userInteractionEnabled = true // this is required to allow the guesture recognizer to work
        let inputTapGestuer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "inputTapped")
        inputLabel!.addGestureRecognizer(inputTapGestuer)
        self.view.addSubview(inputLabel)
        
        outputLabel = UILabel(frame: CGRectMake(view.frame.width-85, 57, 54.0, 21.0))
        outputLabel!.text = "O=0.00"
        outputLabel!.adjustsFontSizeToFitWidth = true
        self.view.addSubview(outputLabel)
        
        // add description at 31, 141, width-31, height-41 (button height + 5 for buffering) - my y pos
        let descrOrigin = CGPointMake(34, 154) // this is the position of the description text box
        let description = UITextView(frame: CGRectMake( descrOrigin.x, // where I start in X
                                                        descrOrigin.y, // where I start in Y
                                                        view.frame.width-31-descrOrigin.x, // width-right slider - my offset
                                                        view.frame.height-41-descrOrigin.y)) // height-bottom button- my offset
        description.editable = false
        description.userInteractionEnabled = true
        description.font = UIFont.systemFontOfSize(14)
        description.scrollEnabled = true
        description.bounces = true
        description.text = jsonParser.modelDescrip
        description.backgroundColor = UIColor(red: 1, green: 1, blue: (231.0/255.0), alpha: 1)
        self.view.addSubview(description)
        
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
        
        blocksOnScreen.append(Dictionary<Int, String>())
        
        // add the forward blocks to the screen
        for (name, type, value) in jsonParser.forward {
            if type == "block" { // woo for effective use of post increment!
                let newTextField = UITextField(frame: CGRectMake(CGFloat(6.5+(position++)*forwardPadding), 73, 49.0, 31.0))
                setupTextField(newTextField, withTag: Int(position), andText: "\(value!)")
                newTextField.addTarget(self, action: "forwardBlockChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
                self.view.addSubview(newTextField)
                blocksOnScreen[0].updateValue(name!, forKey: newTextField.tag)
            } // fi
        } // rof
        
        if hasDisturbance { // if there is disturbance in the system, add another circle and the slider
            let secondCircleView = UICircleView(frame: CGRectMake(CGFloat(position*forwardPadding-1), 57, 64.0, 64.0))
            secondCircleView.hasTopPlus = true
            self.view.addSubview(secondCircleView)
            // 193, 29
            disturbanceSlider = UISlider(frame: CGRectMake(view.frame.width-224, 21, 193, 23))
            disturbanceSlider!.maximumValue = 100
            disturbanceSlider!.minimumValue = -100
            disturbanceSlider!.value = 0.0
            disturbanceSlider!.addTarget(self, action: "disturbanceChanged:", forControlEvents: UIControlEvents.ValueChanged)
            self.view.addSubview(disturbanceSlider)
        } // fi
        
        blocksOnScreen.append(Dictionary<Int, String>())
        // add the loop block
        position = 1.0
        for (name,type, value) in jsonParser.loop {
            if(type == "block") {
                let newTextField = UITextField(frame: CGRectMake(CGFloat(6.5+(position++)*loopPadding), 118, 49.0, 31.0))
                setupTextField(newTextField, withTag:Int(position), andText: "\(value!)")
                newTextField.addTarget(self, action: "loopBlockChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
                self.view.addSubview(newTextField)
                blocksOnScreen[1].updateValue(name!, forKey: newTextField.tag)
            } // fi
        } // rof
    }
    
    override func viewWillAppear(animated: Bool)
    {
// FIXME: this should run when the application returns after being in the background
        super.viewWillAppear(animated)
        self.checkGraphButtonLabel() // it's the same function so why not
    }
    
    func checkGraphButtonLabel()
    {
        let use_sin = NSUserDefaults.standardUserDefaults().boolForKey("use_sin")
        if !use_sin {
            showGraphButton.setTitle(NSLocalizedString("PlotG", comment: "show graphs of input v output and output v disturbance"), forState: UIControlState.Normal) // change the button's text
        } else {
            showGraphButton.setTitle(NSLocalizedString("ShowSinG", value: "Show Sine Graphs", comment: "show the graphs of sine input and output"), forState: UIControlState.Normal)
            // hide input and output sliders?
        }
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
    
    override func viewWillDisappear(animated: Bool)
    {
        NSNotificationCenter.defaultCenter().removeObserver(self) // remove any observers that are held
    }

// MARK:- UI interaction methods
    
    @IBAction func inputChanged(sender: VerticalUISlider) {
        inputLabel!.text = "I="+String(format: "%.2f", sender.value) // set the input label
        var distVal: Float = 0;
        if disturbanceSlider {
            distVal = disturbanceSlider!.value
        }
        var output = sysModel.calculateOutputForInput(sender.value, withDistrubance: distVal)
        outputLabel!.text = "O="+String(format:"%.2f", output) // set the output label
        if output > 10.0 { output = 10.0 }
        if output < -10.0 { output = -10.0 }
        outputSlider.value = Float(output)
    }
    
    func blockValueChanged(sender: UITextField, level: Int32) {
        if let name = blocksOnScreen[Int(level)][sender.tag] {
            println("\(name) was tapped")
            sysModel.setBlockDeviceWithName(name, value: sender.text.bridgeToObjectiveC().doubleValue, onLevel: level)
            var fbType: String?
            if sysModel.isFeedbackNegative()
            {
                fbType = NSLocalizedString("Negative", comment:nil)
            } else {
                fbType = NSLocalizedString("Positive", comment:nil)
            }
            
            feedbackTypeLabel.text = String(format: "%@: %@", NSLocalizedString("TOC", comment: "Type of feedback being modeled"), fbType! )
            inputChanged(inputSlider)
        }
    }
    
    func disturbanceChanged(sender: UISlider)
    {
        var output = sysModel.calculateOutputForInput(inputSlider.value, withDistrubance: sender.value);
        outputLabel!.text = "O="+String(format:"%.2f", output) // set the output label
        if output > 10.0 { output = 10.0 }
        if output < -10.0 { output = -10.0 }
        outputSlider.value = Float(output)
    }
    
// MARK:-
    
    func inputTapped()
    {
        // do something to respond to the tap
        inputSlider.value = 0.0;
        inputLabel!.text = "I=0.00"
        // update teh output (use the model for this, just incase
        var output = sysModel.calculateOutputForInput(0, withDistrubance: disturbanceSlider!.value)
        outputLabel!.text = "O="+String(format:"%.2f", output) // set the output label
        if output > 10.0 { output = 10.0 }
        if output < -10.0 { output = -10.0 }
        outputSlider.value = Float(output)
    }
    
    @IBAction func showGraphs()
    {
        let use_sin = NSUserDefaults.standardUserDefaults().boolForKey("use_sin")
        if use_sin {
            self.performSegueWithIdentifier("sineGraphSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("graphSegue", sender: self)
        }
    }
// WARNING: - this doesn't allow for multiple levels of loop
    func forwardBlockChanged(sender:UITextField) {
        return blockValueChanged(sender, level: 0)
    }
    
    func loopBlockChanged(sender: UITextField) {
        return blockValueChanged(sender, level: 1)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "graphSegue" {
            // setup the regular graph view
            let graphView: iPhoneGraphViewController = segue.destinationViewController as iPhoneGraphViewController
            if disturbanceSlider { // if we have a disturbance slider use it's value
                graphView.min = self.sysModel.minOutputWithDisturbance(disturbanceSlider!.value)
                graphView.max = self.sysModel.maxOutputWithDisturbance(disturbanceSlider!.value)
            } else { // if we don't (i.e. it's nil) use zero
                graphView.min = self.sysModel.minOutputWithDisturbance(0)
                graphView.max = self.sysModel.maxOutputWithDisturbance(0)
            }
            graphView.gradient = self.sysModel.outputVdisturbanceGradient()
        }
        
        if segue.identifier == "sineGraphSegue" {
            // if usingSin {
            let dest:OpenGLESGraphsViewController = segue.destinationViewController as OpenGLESGraphsViewController
            dest.systemModel = sysModel // set the model
            // }
            // else setup the line view controller.
            // note that the graph segue is defined by the input type (two different segues?)
        }
        NSLog("Segue has been called \(segue.identifier)");
    }
}