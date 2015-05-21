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
    
    required init(coder aDecoder: NSCoder)  {
        // setup the input label on init
        inputLabel = UILabel(frame: CGRectMake(31, 57, 54.0, 21.0))
        inputLabel.text = "I=0.00"
        inputLabel.adjustsFontSizeToFitWidth = true
        inputLabel.userInteractionEnabled = true // this is required to allow the guesture recognizer to work
        super.init(coder: aDecoder)
    }

    // MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // crete the inputTapGesture for the inputLabel and then put the label on screen
        let inputTapGestuer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "resetInputSlider")
        inputLabel.addGestureRecognizer(inputTapGestuer)
        self.view.addSubview(inputLabel)
        
        // Setup the sliders for input and output.
        inputSlider.maximumValue = 10
        inputSlider.minimumValue = -10
        inputSlider.value = 0
        view.addSubview(inputSlider)
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
        view.addSubview(outputSlider)
        outputSlider.setTranslatesAutoresizingMaskIntoConstraints(false)
        //outputSlider.thumbTintColor = UIColor.grayColor()
        
        infoButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Ok, now we do some magic to make these bad boys look right... and this is before the logic to make the
        // feedback model get laid out... This "Modern" method seems a lot more cluttered than the old resizing
        // masks ever did. Oh well... We must do what we must do.
        view.addConstraint(NSLayoutConstraint(item: inputSlider, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.90, constant: 0.0))
        let constant:CGFloat = -1.0*((0.90*view.bounds.size.height/2)-(inputSlider.intrinsicContentSize().height/2))
        NSLog("height: %f", constant);
        view.addConstraint(NSLayoutConstraint(item: inputSlider, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier:1.0, constant: constant))
        view.addConstraint(NSLayoutConstraint(item: inputSlider, attribute:NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        
        // Now we need to fix the output slider. Again, we use the same principles as above.
        view.addConstraint(NSLayoutConstraint(item: outputSlider, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Height, multiplier: 0.90, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: outputSlider, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -1.0*constant))
        view.addConstraint(NSLayoutConstraint(item: outputSlider, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        
        // Now position the infoButton relative to the slider. Due to the height of the slider really being it's width, we want half this value which is actually the center in the X axis (by auto-layout) so that's used to position the button on top of the slider just off center. Then by using the height (the fixed height of a normal UISlider) the button can be adjusted to sit nicely at the side.
        view.addConstraint(NSLayoutConstraint(item: infoButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: outputSlider, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -0.75*outputSlider.bounds.height))
        
        view.addConstraint(NSLayoutConstraint(item: selectModelButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: inputSlider, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.75*inputSlider.bounds.height))
        
        let layoutController = LayoutFeedbackView(aView: view, aModel: sysModel)
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

