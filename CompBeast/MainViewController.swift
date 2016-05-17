//
//  MainViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 12/4/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class MainViewController: PFQueryTableViewController {

    let user = PFUser.currentUser()!
    
    override func queryForTable() -> PFQuery {
        
        let getAllLogsQuery = PFQuery(className:"Logs")
        getAllLogsQuery.whereKey("username", notEqualTo: user)
        getAllLogsQuery.includeKey("username")
        getAllLogsQuery.orderByDescending("createdAt")

        
        return getAllLogsQuery
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        loadObjects()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("mainLogCell", forIndexPath: indexPath) as! MainLogTableViewCell
        
        if let userPicture = object!["username"]["profile_picture"]! as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    cell.profileImage.image = UIImage(data:imageData!)
                }
            }
        }
        
        let logFirstName = object!["username"]["first_name"]! as! String
        let logLastName = object!["username"]["last_name"]! as! String
        
        let displayName = logFirstName + " " + logLastName
        
        cell.userNameLabel.text = displayName
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM'-'dd'-'yyyy'"
        let date = String(dateFormatter.stringFromDate(object!.updatedAt! as NSDate))
        
        let rounds = String(object!.objectForKey("rounds")!)
        let minutes = String(object!.objectForKey("minutes")!)
        
        let logString = date + ":" + " " + rounds + " rounds per " + minutes + " minutes"
        
        cell.logLabel.text = String(logString)
        cell.logLabel.numberOfLines = 0
        cell.logLabel.sizeToFit()
        
        self.tableView.rowHeight = 75.0
        
        return cell
    }
}
