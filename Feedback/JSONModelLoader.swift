//
//  JSONModelLoader.swift
//  Feedback
//
//  Created by Oliver Hayman on 28/07/2014.
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
import UIKit

class JSONModelLoader: NSObject
{
    let privatePaths = NSBundle.mainBundle().pathsForResourcesOfType("json", inDirectory: "")
    let userPaths: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
    override init()
    {
        super.init()
    }
    
    func countPrivateModels() -> Int
    {
        return privatePaths.count
    }
    
    func getPrivateSystemModels(atIndex index: Int) -> String?
    {
        if countPrivateModels() >  index
        {
            return privatePaths[index] as? String
        } else {
            return nil
        }
    }
    
    func getUserSystemModels()
    {
        NSLog("\(userPaths)")
        var error: NSError?
        let results = NSFileManager.defaultManager().contentsOfDirectoryAtPath(userPaths, error: &error)!
        for item in results
        {
            println(item) // lets see what we've got
        }
//        NSArray *libraryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:libraryPath error:nil];
    }
    // detect JSON models in both the bundle and documents
   
}
