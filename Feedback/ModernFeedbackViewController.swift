//
//  ModernFeedbackViewController.swift
//  FeedbackGUITest
//
//  Created by Oliver Hayman on 18/05/2015.
//  Copyright (c) 2015 OlliesPage. All rights reserved.
//

import UIKit
import FeedbackUIFramework

class ModernFeedbackViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    // MARK: Variable defintions
    
    let inputSlider = UIVerticalSlider.new()
    let outputSlider = UIVerticalSlider.new()
    
    private let inputLabel: UILabel
    private let sysModel = feedbackModel()
    
    @IBOutlet weak private var infoButton: UIButton!
    @IBOutlet weak private var selectModelButton: UIButton!
    @IBOutlet weak private var showGraphButton: UIButton!
    
    // MARK:- Initalization and setup functions
    
    required init(coder aDecoder: NSCoder)  {
        // setup the input label on init
        inputLabel = UILabel(frame: CGRectMake(31, 57, 54.0, 21.0))
        inputLabel.text = "I=0.00"
        inputLabel.adjustsFontSizeToFitWidth = true
        inputLabel.userInteractionEnabled = true // this is required to allow the guesture recognizer to work
        super.init(coder: aDecoder)
    }
    
    func setupUIElements() {
        // crete the inputTapGesture for the inputLabel and then put the label on screen
        let inputTapGestuer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "resetInputSlider")
        inputLabel.addGestureRecognizer(inputTapGestuer)
        
        // Setup the sliders for input and output.
        inputSlider.maximumValue = 10
        inputSlider.minimumValue = -10
        inputSlider.value = 0
        // This allows the programmatic constraints to be the only constrains :)
        inputSlider.setTranslatesAutoresizingMaskIntoConstraints(false)
        // Finally connect the input slider to the inputChanged action!
        inputSlider.addTarget(self, action: "inputChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Now setup the outputSlider
        outputSlider.maximumValue = 100
        outputSlider.minimumValue = -100
        outputSlider.value = 0
        outputSlider.enabled = false
        outputSlider.tintColor = UIColor.lightGrayColor() // trying a light gray for the tracking
        outputSlider.setTranslatesAutoresizingMaskIntoConstraints(false)
        //outputSlider.thumbTintColor = UIColor.grayColor()
        
        infoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    }

    // MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup the UIElements to be used
        setupUIElements()
        
        // Initalise a layout controller to handle laying out the class
        let layoutController = LayoutFeedbackView(aView: view, aModel: sysModel)
        
        // Layout the basics:
        layoutController.layoutIOSliders(inputSlider: inputSlider, outputSlider: outputSlider)
        layoutController.layoutInputLabel(inputLabel)
        layoutController.layoutInfoButton(infoButton, rightOf: outputSlider)
        layoutController.layoutSelectModelButton(selectModelButton, leftOf: inputSlider)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkGraphButtonLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- UI interaction methods
    func inputChanged(sender: UIVerticalSlider) {
        inputLabel.text = "I="+String(format: "%.2f", sender.value)
        outputSlider.value = 10*sender.value
    }
    
    func checkGraphButtonLabel()
    {
        let use_sin = true //NSUserDefaults.standardUserDefaults().boolForKey("use_sin")
        if !use_sin {
            showGraphButton.setTitle(NSLocalizedString("PlotG", comment: "show graphs of input v output and output v disturbance"), forState: UIControlState.Normal) // change the button's text
        } else {
            showGraphButton.setTitle(NSLocalizedString("ShowSinG", value: "Show Sine Graphs", comment: "show the graphs of sine input and output"), forState: UIControlState.Normal)
            // hide input and output sliders?
        }
    }
    
    // MARK:- UI Gesture interaction
    
    func resetInputSlider()
    {
        // do something to respond to the tap
        inputSlider.value = 0.0
        outputSlider.value = 0.0
        inputLabel.text = "I=0.00"
    }
    
    // MARK:- Segue management
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // This controls the segue for the model selection popover
        if segue.identifier == "selectModel" {
            let selectModelVC = segue.destinationViewController as! UIViewController//as! SelectModelTableViewController
            selectModelVC.preferredContentSize = CGSizeMake(260, 200);
            selectModelVC.modalPresentationStyle = UIModalPresentationStyle.Popover;
            //selectModelVC.delegate = self
            selectModelVC.popoverPresentationController!.delegate = self
        }
        
    }
    
    // MARK:- UIPopoverPresentationControllerDelegate methods
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!, traitCollection: UITraitCollection!) -> UIModalPresentationStyle {
        return .None
    }

}

