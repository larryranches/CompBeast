//
//  UserLogTableViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 12/11/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserLogTableViewController: PFQueryTableViewController {
    
    let user = PFUser.currentUser()!
    
    override func queryForTable() -> PFQuery {
        
        let getUserLogsQuery = PFQuery(className:"Logs")
        getUserLogsQuery.orderByDescending("createdAt")
        getUserLogsQuery.whereKey("username", equalTo: user)
        
        
        return getUserLogsQuery
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Refresh the table to ensure any data changes are displayed
        loadObjects()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("userLogCell", forIndexPath: indexPath) as! UserLogTableViewCell
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM'-'dd'-'yyyy'"
        let date = String(dateFormatter.stringFromDate(object!.updatedAt! as NSDate))
        
        let rounds = String(object!.objectForKey("rounds")!)
        let minutes = String(object!.objectForKey("minutes")!)
        
        let logLabel = date + ":" + " " + rounds + " rounds per " + minutes + " minutes"
        
        cell.roundsLabel.text = String(logLabel)
        
        cell.backgroundColor = UIColor(red: 49.0/255, green: 49.0/255, blue: 40.0/255, alpha: 1.0)

        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row + 1 > self.objects?.count
        {
            self.loadNextPage()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else
        {
            self.performSegueWithIdentifier("logDetail", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logDetail" {
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let detailVC = segue.destinationViewController as! LogDetailViewController
            
            let object = self.objectAtIndexPath(indexPath)!
        
            //print(object["notes"])
            detailVC.notes = object["notes"]! as! String
            detailVC.roundsString = String(object["rounds"]!)
            detailVC.minutesString = String(object["minutes"]!)
            
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
}
