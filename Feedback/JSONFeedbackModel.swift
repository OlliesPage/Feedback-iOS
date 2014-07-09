//
//  JSONFeedbackModel.swift
//  Feedback
//
//  Created by Oliver Hayman on 07/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

import Foundation

@objc class JSONFeedbackModel: NSObject {
    let json:NSData
    let jsonDict:Dictionary<String, AnyObject>
    var error: NSError?
    var forward = Array<(String?, String?, Double?)>()
    var loop = Array<(String?, String?, Double?)>()
    
    @objc init(sysModel: feedbackModel, pathToModel:NSString) {
        json = NSData.dataWithContentsOfFile(pathToModel, options:NSDataReadingOptions.DataReadingMappedIfSafe, error: &error)
        jsonDict = NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments, error: &error) as Dictionary<String, AnyObject>
        
        super.init();
        
        // ensure system is empty
        sysModel.resetModel()
        
        for (key: String, value: AnyObject) in jsonDict as Dictionary<String, AnyObject> {
            if(key == "model") {
                parseModel(value, systemModel: sysModel)
                continue
            }
            println("\(key) has value: \(value)")
            
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
                let newBlock = NSBlockDevice.blockWithName(name, andValue: value)
                systemModel.addBlockDevice(newBlock, onLevel: 0)
                println("\(name) has type \(type) and value: \(value)")
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
                        println("\(name) has type \(type) and value: \(value)")
                    } else {
                        println("Badly formed model - does it have a sub model?")
                    }
                }
            }
        }
    }
}


