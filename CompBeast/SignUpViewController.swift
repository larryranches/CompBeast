//
//  SignUpViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 11/19/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var profilePhotoImageView: UIImageView!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectPhoto(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    @IBAction func signUp(sender: AnyObject) {
        
        let userName = emailTF.text
        let userPassword = passwordTF.text
        let userFirstName = firstNameTF.text
        let userLastName = lastNameTF.text
        
        if (userName?.isEmpty == true || userPassword?.isEmpty == true || userFirstName?.isEmpty == true || userLastName?.isEmpty == true) {
            
            let errorAlert = UIAlertController(title: "All Fields Required",
                message: "Please Enter Your Information to Register",
                preferredStyle: UIAlertControllerStyle.Alert)

            let okAction = UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Default,
                handler: nil)
            
            errorAlert.addAction(okAction)
            
            self.presentViewController(errorAlert, animated: true, completion: nil)
            
            return
        }
        
        let newUser:PFUser = PFUser()
        newUser.username = userName
        newUser.password = userPassword
        newUser.email = userName
        newUser.setObject(userFirstName!, forKey: "first_name")
        newUser.setObject(userLastName!, forKey: "last_name")
        newUser.setObject("", forKey: "user_bio")
        
        if (profilePhotoImageView.image != nil) {
            
            let size = CGSize(width: 120, height: 120)
            let scaledPhoto = scaleUIImageToSize(profilePhotoImageView.image!, size: size)

            let profileImageData = UIImageJPEGRepresentation(scaledPhoto, 1)
            let profileImageFile = PFFile(data: profileImageData!)
            newUser.setObject(profileImageFile!, forKey: "profile_picture")
            
        }
        
        // Load Activity Indicator
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Signing Up..."
        
        newUser.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            
            loadingNotification.hide(true)
            
            var userMessage = "Registration Complete. Thank you!"
            
            if(!success){
                
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
    
    func scaleUIImageToSize(let image: UIImage, let size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true;
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
