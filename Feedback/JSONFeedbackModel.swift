//
//  JSONFeedbackModel.swift
//  Feedback
//
//  Created by Oliver Hayman on 07/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

import Foundation

// refactored to remove NSObject subclass as Objc no longer needs to use this class
class JSONFeedbackModel {
    let json:NSData
    let jsonDict:Dictionary<String, AnyObject>
    let hasDisturbance: Bool
    let modelName: String
    let modelDescrip: String?
    
    var error: NSError?
    var forward = Array<(String?, String?, Double?)>()
    var loop = Array<(String?, String?, Double?)>()
    
    init(sysModel: feedbackModel, pathToModel:NSString) {
        json = NSData.dataWithContentsOfFile(pathToModel, options:NSDataReadingOptions.DataReadingMappedIfSafe, error: &error)
        jsonDict = NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments, error: &error) as Dictionary<String, AnyObject>
        // read the boolean for disturbance, if it exists
        if let distVal: AnyObject = jsonDict["hasDisturbance"] {
            hasDisturbance = distVal as Bool
        } else {
            hasDisturbance = false
        }
        
        // read the name of the model if it exists
        if let name: AnyObject = jsonDict["name"] {
            modelName = name as String
        } else {
            modelName = "Unknown"
        }
        
        // read the description from the model and set it if appropriate
        if let jsonDescription: AnyObject = jsonDict["description"] {
            modelDescrip = jsonDescription as? String
        }
        
        // ensure system is empty
        sysModel.resetModel()
        
        if let model: AnyObject = jsonDict["model"] {
            parseModel(model, systemModel: sysModel)
        } else {
            println("Model error: Model not found")
            abort() // cannot run in this condition, so crash
        }
    }
    
    func enumerateFromDictionary(inputDictionary:Dictionary<String,AnyObject>) -> (String?, String?, Double?) {
        var name:String?, type:String?, value:Double?
        for (blockName, subDict : AnyObject) in inputDictionary {
            if(blockName == "model") {
                println("There is a new model to process")
            }
            name = blockName
            // sanity check
            if subDict is NSDictionary {
                for (blockType: String, val: Double) in subDict as Dictionary<String, Double> {
                    type = blockType
                    value = val
                }
            }
        }
        return (name, type, value)
    }
    
    // look at the java version, could this be made better with recursion?
    func parseModel(jsonModel: AnyObject, systemModel:feedbackModel) {
        for element: AnyObject in jsonModel as NSArray {
            // Check if the element is a dictionary
            if element is NSDictionary {
                // a dictionary will have a string and a dictionary, this is the name and blocktype/value
                var (name:String?, type:String?, value:Double?) = enumerateFromDictionary(element as Dictionary)
                let forwarVal = (name, type, value)
                forward.append(forwarVal)
                if type == "block" {
                    let newBlock = NSBlockDevice.blockWithName(name, andValue: value)
                    systemModel.addBlockDevice(newBlock, onLevel: 0)
                } else if type == "limitBlock" {
                    systemModel.setLimitValue(value!) // set the limit
                }
                println("\(name!) has type \(type!) and value: \(value!)")
            } else if element is NSArray {
                for subelement: AnyObject in element as NSArray {
                    // and again
                    println("Entering Loop")
                    if subelement is NSDictionary {
                        var (name:String?, type:String?, value:Double?) = enumerateFromDictionary(subelement as Dictionary)
                        let loopVal = (name,type, value)
                        loop.append(loopVal)
                        let newBlock = NSBlockDevice.blockWithName(name, andValue: value)
                        systemModel.addBlockDevice(newBlock, onLevel: 1)
                        println("\(name!) has type \(type!) and value: \(value!)")
                    } else {
                        println("Badly formed model - does it have a sub model?")
                    }
                }
            }
        }
    }
}


