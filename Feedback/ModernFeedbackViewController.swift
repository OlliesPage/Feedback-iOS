//
//  ModernFeedbackViewController.swift
//  FeedbackGUITest
//
//  Created by Oliver Hayman on 18/05/2015.
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

class ModernFeedbackViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    // MARK: Variable defintions
    
    let inputSlider = UIVerticalSlider.new()
    let outputSlider = UIVerticalSlider.new()
    let defaultModelPath = NSBundle.mainBundle().pathForResource("Basic Feedback Model", ofType: "json")
    
    var disturbSlider: UISlider?
    var limitBlock: UILimitBlock?
    var jsonParser:JSONFeedbackModel?
    
    var blocksOnScreen = Array<Dictionary<Int,String>>()
    let blockDelegate = TextFieldDelegate()
    
    // MARK: Private variables
    private let inputLabel: UILabel
    private let outputLabel: UILabel
    private var disturbLabel: UILabel? // use a let and only display if the slider != nil?
    private var descriptionLabel: UITextView?
    private let sysModel = feedbackModel()
    
    @IBOutlet weak private var infoButton: UIButton!
    @IBOutlet weak private var selectModelButton: UIButton!
    @IBOutlet weak private var showGraphButton: UIButton!
    @IBOutlet weak private var feedbackTypeLabel: UILabel!
    
    // MARK:- Initalization and setup functions
    
    required init(coder aDecoder: NSCoder)  {
        // setup the input label on init
        inputLabel = UILabel(frame: CGRectMake(31, 57, 45.0, 21.0))
        inputLabel.text = String(format:NSLocalizedString("InputLabel", comment: "Input Label"), 0.0)
        inputLabel.adjustsFontSizeToFitWidth = true
        inputLabel.userInteractionEnabled = true // this is required to allow the guesture recognizer to work
        outputLabel = UILabel.new()
        outputLabel.adjustsFontSizeToFitWidth = true
        
        super.init(coder: aDecoder)
    }
    
    func setupUIElements() {
        // crete the inputTapGesture for the inputLabel and then put the label on screen
        let inputTapGestuer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "resetInputSlider")
        inputLabel.addGestureRecognizer(inputTapGestuer)
        
        // set outputLabel text value for the current model with all params set to zero
        let outputValue = sysModel.calculateOutputForInput(0, withDistrubance: 0)
        outputLabel.text = String(format:NSLocalizedString("OutputLabel", comment: "Output Label"), outputValue)
        
        //infoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // setup for the graph button
        showGraphButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showGraphButton.titleLabel?.minimumScaleFactor = 0.5
        
        // if there is a model description, setup a text view to contain it
        if let modelDescription = jsonParser?.modelDescrip {
            descriptionLabel = UITextView()
            //descriptionLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
            descriptionLabel!.text = modelDescription
            descriptionLabel!.editable = false
            descriptionLabel!.selectable = false
            descriptionLabel!.userInteractionEnabled = true
            descriptionLabel!.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
            descriptionLabel!.textAlignment = .Justified
            descriptionLabel!.scrollEnabled = true
            descriptionLabel!.bounces = true
            descriptionLabel!.backgroundColor = UIColor(red: 1, green: 1, blue: (231/255), alpha: 1)
        }
    }

    // MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if there is a model to be displayed, else, revert to the default
        if jsonParser == nil {
            jsonParser = JSONFeedbackModel(sysModel: sysModel, pathToModel: defaultModelPath!)
        }
        
        // Update the type of feedback label to show the if the feedback is positive or negative
        var fbType = "PLACEHOLDER"
        if sysModel.isFeedbackNegative() {
            fbType = NSLocalizedString("Negative", comment: "Negative")
        } else {
            fbType = NSLocalizedString("Positive", comment: "Positive")
        }
        feedbackTypeLabel.text = String(format:"%@: %@", NSLocalizedString("TOF", comment: "Type of feedback being modelled"), fbType)
        
        // setup the UIElements to be used
        setupUIElements()
        
        // Initalise a layout controller to handle laying out the class
        let layoutController = LayoutFeedbackView(parentController: self, systemModel: sysModel)
        
        // Layout the basics:
        layoutController.layoutBasicUI(inputSlider: inputSlider, outputSlider: outputSlider, infoButton: infoButton, selectModelButton: selectModelButton, descriptionLabel: descriptionLabel)
        layoutController.layoutIOLabels(inputLabel: inputLabel, outputLabel: outputLabel)
        
        layoutController.layoutFeedbackModel(usingJsonModel: jsonParser!)
        view.bringSubviewToFront(inputLabel)
        view.bringSubviewToFront(outputLabel)
        
        // next comes the blocks, and these are important, do we setup the blocks in this controller then pass them back to the layoutController
        // or set them up in the layout controller and pass them back to this class?
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkGraphButtonLabel()
        // Make the graphButton update on app switching (so that setting changes take effect when moving from the background
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkGraphButtonLabel", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self) // remove all observers that are held.
    }
    
    // MARK:- UI interaction methods
    
    func inputChanged(sender: UIVerticalSlider) {
        inputLabel.text = String(format:NSLocalizedString("InputLabel", comment: "Input Label"), sender.value)
        var disturbance: Float = 0
        if disturbSlider != nil {
            disturbance = disturbSlider!.value
        }
        let outputValue = sysModel.calculateOutputForInput(sender.value, withDistrubance: disturbance)
        outputLabel.text = String(format:NSLocalizedString("OutputLabel", comment: "Output Label"), outputValue)
        outputSlider.value = Float(outputValue)
        
        if let limitBlockUI = limitBlock {
            if abs(outputValue) >= sysModel.getLimitValue() {
                if !limitBlockUI.limiting {
                    limitBlockUI.limiting = true
                    limitBlockUI.setNeedsDisplay()
                }
            } else {
                if limitBlockUI.limiting {
                    limitBlockUI.limiting = false
                    limitBlockUI.setNeedsDisplay()
                }
            }
        }
    }
    
    private func blockValueChanged(sender: UITextField, level: Int32)
    {
        if let name = blocksOnScreen[Int(level)][sender.tag] {
            print("\(name) was tapped")
            sysModel.setBlockDeviceWithName(name, value: (sender.text! as NSString).doubleValue, onLevel: level)
            var fbType: String
            if sysModel.isFeedbackNegative() {
                fbType = NSLocalizedString("Negative", comment: "")
            } else {
                fbType = NSLocalizedString("Positive", comment: "")
            }
            // Update the display as required
            feedbackTypeLabel.text = String(format:"%@: %@", NSLocalizedString("TOF", comment:"Type of feedback being modelled"), fbType)
            inputChanged(inputSlider)
        }
    }
    
    func forwardBlockChanged(sender: UITextField)
    {
        return blockValueChanged(sender, level:0)
    }
    
    func loopBlockChanged(sender: UITextField)
    {
        return blockValueChanged(sender, level: 1)
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
    
    @IBAction func showGraphs(sender: AnyObject) {
        let use_sin = NSUserDefaults.standardUserDefaults().boolForKey("use_sin")
        if use_sin {
            performSegueWithIdentifier("sineGraphSegue", sender: self)
        } else {
            performSegueWithIdentifier("lineGraphSegue", sender: self)
        }
    }
    
    // MARK:- UI Gesture interaction
    
    func resetInputSlider()
    {
        // do something to respond to the tap
        inputSlider.value = 0.0
        inputLabel.text = String(format:NSLocalizedString("InputLabel", comment: "Input Label"), 0.0)
        // get the disturance value (if there is one, else assume zero)
        var disturbance: Float = 0
        if disturbSlider != nil {
            disturbance = disturbSlider!.value
        }
        // set the output based on the reset input and current disturbence value
        let outputValue = sysModel.calculateOutputForInput(0, withDistrubance: disturbance)
        outputLabel.text = String(format:NSLocalizedString("OutputLabel", comment: "Output Label"), outputValue)
        outputSlider.value = Float(outputValue)
        
        if let limitBlockUI = limitBlock {
            if abs(outputValue) >= sysModel.getLimitValue() {
                if !limitBlockUI.limiting {
                    limitBlockUI.limiting = true
                    limitBlockUI.setNeedsDisplay()
                }
            } else {
                if limitBlockUI.limiting {
                    limitBlockUI.limiting = false
                    limitBlockUI.setNeedsDisplay()
                }
            }
        }
    }
    
    // MARK:- Segue management
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // This controls the segue for the model selection popover
        if segue.identifier == "selectModel" {
            let selectModelVC = segue.destinationViewController as UIViewController//as! SelectModelTableViewController
            selectModelVC.preferredContentSize = CGSizeMake(260, 200);
            selectModelVC.modalPresentationStyle = UIModalPresentationStyle.Popover;
            //selectModelVC.delegate = self
            selectModelVC.popoverPresentationController!.delegate = self
        }
        
        if segue.identifier == "lineGraphSegue" {
            // setup the line graph view
            let graphView = segue.destinationViewController as! iPhoneGraphViewController
            if let disturbance = disturbSlider?.value {
                graphView.min = sysModel.minOutputWithDisturbance(disturbance)
                graphView.max = sysModel.maxOutputWithDisturbance(disturbance)
            } else {
                graphView.min = sysModel.minOutputWithDisturbance(0)
                graphView.max = sysModel.maxOutputWithDisturbance(0)
            }
            graphView.limit = sysModel.getLimitValue()
            graphView.gradient = sysModel.outputVdisturbanceGradient()
        }
        
        if segue.identifier == "sineGraphSegue" {
            let dest = segue.destinationViewController as! OpenGLESGraphsViewController
            dest.systemModel = sysModel // send the system model
        }
        
    }
    
    // MARK:- UIPopoverPresentationControllerDelegate methods
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .None
    }

}

