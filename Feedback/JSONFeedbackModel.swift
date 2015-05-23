//
//  JSONFeedbackModel.swift
//  Feedback
//
//  Created by Oliver Hayman on 07/07/2014.
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

import Foundation

enum BlockDeviceType: Int { case Block=0, LimitBlock, SysModelBlock }

// refactored to remove NSObject subclass as Objc no longer needs to use this class
class JSONFeedbackModel {
    // MARK: Private properties
    private let json:NSData
    private let jsonDict:Dictionary<String, AnyObject>
    private var error: NSError?
    
    // MARK: Public properties
    let hasDisturbance: Bool
    let modelName: String
    let modelDescrip: String?
    
    var forward = [(String?, BlockDeviceType?, Double?)]()
    var loop = Array<(String?, BlockDeviceType?, Double?)>()
    
    // MARK:- Initializer function
    init(sysModel: feedbackModel, pathToModel:NSString) {
        json = NSData(contentsOfFile: pathToModel as String, options:.DataReadingMappedIfSafe, error: &error)!
        jsonDict = NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments, error: &error) as! Dictionary<String, AnyObject>
        // read the boolean for disturbance, if it exists
        if let distVal: AnyObject = jsonDict["hasDisturbance"] {
            hasDisturbance = distVal as! Bool
        } else {
            hasDisturbance = false
        }
        
        // read the name of the model if it exists
        if let name: AnyObject = jsonDict["name"] {
            modelName = name as! String
        } else {
            modelName = "Unknown"
        }
        
        // read the description from the model and set it if appropriate
        if let jsonDescription: AnyObject = jsonDict["description"] {
            modelDescrip = jsonDescription as? String
        } else {
            modelDescrip = nil;
        }
        
        // ensure system is empty
        sysModel.resetModel()
        
        if let model: AnyObject = jsonDict["model"] {
            parseModel(model, systemModel: sysModel, addToScreen: true)
        } else {
            println("Model error: Model not found")
            abort() // cannot run in this condition, so crash
        }
    }
    
    // MARK:- Private member functions
    private func instantiateBlockFromDictionary(inputDictionary inDict:Dictionary<String, AnyObject>) -> BlockDevice?
    {
        var outputBD: BlockDevice?
        for (blockName, subDict: AnyObject) in inDict {
            if(blockName == "model") {
                let newModel = feedbackModel();
                parseModel(subDict, systemModel: newModel, addToScreen: false)
                outputBD = FeedbackSystemBlockDevice(name: "subModel", andSystem: newModel)
                return outputBD
            }// special case
            
            if subDict is NSDictionary && outputBD == nil {
                for (blockType: String, val: Double) in subDict as! Dictionary<String, Double> {
                    if blockType == "block"
                    {
                        outputBD = BlockDevice(name: blockName, andValue: val)
                        outputBD!.type = BlockDeviceType.Block.rawValue
                    } else if blockType == "limitBlock" {
                        outputBD = BlockDevice(name: blockName, andValue: val)
                        outputBD!.type = BlockDeviceType.LimitBlock.rawValue
                    }
                }
            }
        }
        return outputBD;
    }
    
    // the array that holds blocks for fwrd/loop needs to either be made to hold BlockDevices or
    // should there must be a way to convert from int to string for types
    private func parseModel(jsonModel: AnyObject, systemModel:feedbackModel, addToScreen: Bool) {
        for element: AnyObject in jsonModel as! NSArray {
            // Check if the element is a dictionary
            if element is NSDictionary {
                // a dictionary will have a string and a dictionary, this is the name and blocktype/value
                let nBlock = instantiateBlockFromDictionary(inputDictionary: element as! Dictionary)
                //let forwardVal = ()
                if addToScreen == true
                {
                    let fname:String? = nBlock?.name;
                    forward.append((fname, BlockDeviceType(rawValue: nBlock!.type.integerValue), nBlock?.value.doubleValue))
                }
                let bType = BlockDeviceType(rawValue: nBlock!.type.integerValue)
                if bType == BlockDeviceType.LimitBlock {
                    systemModel.setLimitValue(nBlock!.value.doubleValue) // set the limit
                } else {
                    systemModel.addBlockDevice(nBlock, onLevel: 0)
                }
                println("\(nBlock!.name) has type \(nBlock?.type) and value: \(nBlock?.value)") // this causes it to crash
            } else if element is NSArray {
                for subelement: AnyObject in element as! NSArray {
                    // and again
                    println("Entering Loop")
                    if subelement is NSDictionary {
                        let nBlock = instantiateBlockFromDictionary(inputDictionary: subelement as! Dictionary)
                        //let loopVal = (nBlock?.name, BlockDeviceType.fromRaw(nBlock?.type), nBlock?.value)
                        if addToScreen == true
                        {
                            let lname:String? = nBlock?.name;
                            loop.append(lname, BlockDeviceType(rawValue: nBlock!.type.integerValue), nBlock?.value.doubleValue)
                        }
                        systemModel.addBlockDevice(nBlock, onLevel: 1)
                        println("\(nBlock!.name) has type \(nBlock?.type) and value: \(nBlock?.value)")
                    } else {
                        println("Badly formed model - does it have a sub model?")
                    }
                }
            }
        }
        systemModel.resetCache() // try just clearing it out after
    }
}


