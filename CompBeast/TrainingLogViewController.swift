//
//  PostViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 12/6/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse

class TrainingLogViewController: UIViewController {

    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var firstAndLastNameTF: UILabel!
    @IBOutlet var userLogTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let user = PFUser.currentUser()
        
        if let userPicture = PFUser.currentUser()?["profile_picture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.userPhoto.image = UIImage(data:imageData!)
                }
            }
        }
        
        let displayName = String(user!["first_name"]) + " " + String(user!["last_name"])
        
        firstAndLastNameTF.text = displayName
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let user = PFUser.currentUser()
        
        if let userPicture = PFUser.currentUser()?["profile_picture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.userPhoto.image = UIImage(data:imageData!)
                }
            }
        }
        
        let displayName = String(user!["first_name"]) + " " + String(user!["last_name"])
        
        firstAndLastNameTF.text = displayName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
