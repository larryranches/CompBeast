//
//  ViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 11/19/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet var emailLoginTF: UITextField!
    @IBOutlet var passwordLoginTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        UINavigationBar.appearance().barTintColor = UIColor(red: 150.0/255, green: 190.0/255, blue: 40.0/255, alpha: 1.0)
        
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        
        UITabBar.appearance().tintColor = UIColor(red: 150.0/255, green: 190.0/255, blue: 40.0/255, alpha: 1.0)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginUser(sender: AnyObject) {
        
        // Load Activity Indicator
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Logging In..."
        
        let emailLogin = emailLoginTF.text
        let passwordLogin = passwordLoginTF.text
        
        PFUser.logInWithUsernameInBackground(emailLogin!, password: passwordLogin!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                // Authenticated: Send to Main View
                self.performSegueWithIdentifier("authenticatedSegue", sender: self)
                
                
            } else {
                
                let errorAlert = UIAlertController(title: "Login Failed",
                    message: "Please try again",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok",
                    style: UIAlertActionStyle.Default,
                    handler: nil)
                
                errorAlert.addAction(okAction)
                
                loadingNotification.hide(true)
                
                self.presentViewController(errorAlert, animated: true, completion: nil)
                
                return
                
            }
        }
    }
    
    // Keyboard Stuff Below
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

