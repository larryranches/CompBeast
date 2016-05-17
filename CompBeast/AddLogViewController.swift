//
//  AddLogViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 12/8/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class AddLogViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var roundsTF: UITextField!
    @IBOutlet var minutesTF: UITextField!
    @IBOutlet var notesTF: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTF.delegate = self

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddLogViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveLog(sender: AnyObject) {
        
        let notes = notesTF.text
        let rounds = roundsTF.text
        let minutes = minutesTF.text
        
        if (rounds?.isEmpty == true || minutes?.isEmpty == true || notes?.isEmpty == true) {
            
            let errorAlert = UIAlertController(title: "All Fields Required",
                message: "Please Enter All Log Information",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Default,
                handler: nil)
            
            errorAlert.addAction(okAction)
            
            self.presentViewController(errorAlert, animated: true, completion: nil)
            
            return
        }
        
        let user = PFUser.currentUser()
        let logs = PFObject(className:"Logs")
        
        logs["rounds"] = Int(rounds!)
        logs["minutes"] = Int(minutes!)
        logs["notes"] = notes
        logs["username"] = user
        
        // Load Activity Indicator
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Saving Log..."
        
        logs.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            
            loadingNotification.hide(true)
            
            var userMessage = "Training Log Saved!"
            
            if (!success) {
                
                userMessage = error!.localizedDescription
                
            }
            
            let registerAlert = UIAlertController(title: "",
                message: userMessage,
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Default){ action in
                    
                    if(success){
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
            }
            
            registerAlert.addAction(okAction)
            
            self.presentViewController(registerAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 480
        let currentString: NSString = notesTF.text
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: text)
        return newString.length <= maxLength
    }
    
    // Keyboard Stuff Below
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
    }
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

}
