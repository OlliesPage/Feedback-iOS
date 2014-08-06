//
//  SelectModelTableViewController.swift
//  Feedback
//
//  Created by Oliver Hayman on 28/07/2014.
//  Copyright (c) 2014 OlliesPage. All rights reserved.
//

import UIkit

protocol SelectModalTableViewControllerDelegate
{
    func changeToModelWithJSONatPath(path: String)
}

class customUITableViewCell: UITableViewCell
{
    var pathName:String?
}

class SelectModelTableViewController: UITableViewController
{
    var delegate:SelectModalTableViewControllerDelegate?
    private let jsonModelLoader = JSONModelLoader()
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        //jsonModelLoader.getUserSystemModels() debugging
        let numberOfCells = jsonModelLoader.countPrivateModels()
        return numberOfCells > 0 ? jsonModelLoader.countPrivateModels() : 1
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        var cell = customUITableViewCell()
        if tableView == self.tableView
        {
            cell = tableView.dequeueReusableCellWithIdentifier("sysModelCell") as customUITableViewCell
            if cell != nil {
                if(jsonModelLoader.countPrivateModels() > 1)
                {
                    NSLog("Could not find cell for sysModelCell")
                    let path = jsonModelLoader.getPrivateSystemModels(atIndex: indexPath.item) as String!
                    let name = path.lastPathComponent.stringByDeletingPathExtension
                    cell.textLabel.text = name
                    cell.pathName = path
                } else {
                    cell.textLabel.text = "No models found"
                    cell.textLabel.textColor = UIColor.grayColor()
                    cell.userInteractionEnabled = false
                }
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var cell: customUITableViewCell = tableView.cellForRowAtIndexPath(indexPath) as customUITableViewCell
        NSLog("Selected model is \(cell.textLabel.text) with path: \(cell.pathName)")
        if cell.pathName != nil && delegate != nil // check against nil
        {
            delegate?.changeToModelWithJSONatPath(cell.pathName!)
        }
    }
}
