//
//  ProfileViewController.swift
//  CompBeast
//
//  Created by Larry Ranches on 12/6/15.
//  Copyright © 2015 Larry Ranches. All rights reserved.
//

import UIKit
import Parse
import MobileCoreServices
import MBProgressHUD

class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var firstNameTF: UITextField!
    @IBOutlet var lastNameTF: UITextField!
    @IBOutlet var userBio: UITextView!
    @IBOutlet var profilePhoto: UIImageView!
    @IBOutlet var editPhotoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        userBio.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        let user = PFUser.currentUser()!
        
        firstNameTF.text = String(user["first_name"])
        lastNameTF.text = String(user["last_name"])
        userBio.text = String(user["user_bio"])
        

        if let userPicture = PFUser.currentUser()?["profile_picture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePhoto.image = UIImage(data:imageData!)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func editPhoto(sender: AnyObject) {
        pickMediaFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func submitChanges(sender: AnyObject) {
        
        // Check if textfields are not empty
        if (firstNameTF.text?.isEmpty == true || lastNameTF.text?.isEmpty == true) {
            
            let errorAlert = UIAlertController(title: "Error",
                message: "You must Enter a First and Last Name",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Default,
                handler: nil)
            
            errorAlert.addAction(okAction)
            
            self.presentViewController(errorAlert, animated: true, completion: nil)
            
            return
        }
        
        // Set Updated Fields
        let currentUser = PFUser.currentUser()

        currentUser?.setObject(firstNameTF.text!, forKey: "first_name")
        currentUser?.setObject(lastNameTF.text!, forKey: "last_name")
        currentUser?.setObject(userBio.text!, forKey: "user_bio")
        
        if (profilePhoto.image != nil) {
            
            let size = CGSize(width: 120, height: 120)
            let scaledPhoto = scaleUIImageToSize(profilePhoto.image!, size: size)
            
            let profileImageData = UIImageJPEGRepresentation(scaledPhoto, 1)
            let profileImageFile = PFFile(data: profileImageData!)
            currentUser?.setObject(profileImageFile!, forKey: "profile_picture")
        }
        
        // Load Activity Indicator
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.labelText = "Please wait.."
        
        // Save Updated Data
        currentUser?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            
            loadingNotification.hide(true)
            
            if (error != nil) {
                
                let errorAlert = UIAlertController(title: "Error",
                    message: error!.localizedDescription,
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok",
                    style: UIAlertActionStyle.Default,
                    handler: nil)
                
                errorAlert.addAction(okAction)
                
                self.presentViewController(errorAlert, animated: true, completion: nil)
                
                return
            }
            
            if (success) {
                
                let successAlert = UIAlertController(title: "Success",
                    message: "Profile has been Updated!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                    
                })
                
                successAlert.addAction(okAction)
                self.presentViewController(successAlert, animated: true, completion: nil)
                
            }
        })
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let maxLength = 280
        let currentString: NSString = userBio.text
        let newString: NSString =
        currentString.stringByReplacingCharactersInRange(range, withString: text)
        return newString.length <= maxLength
    }
    
    
    // User Photo Stuff Below
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType) {
        let mediaTypes: [String]? =
        UIImagePickerController.availableMediaTypesForSourceType(sourceType)
        guard mediaTypes != nil && mediaTypes?.count > 0 else {return}
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.mediaTypes = [kUTTypeImage as String]
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = sourceType
            presentViewController(picker, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo  editingInfo: [String : AnyObject]) {
        
        let mediaType = editingInfo[UIImagePickerControllerMediaType] as! String
        guard mediaType == kUTTypeImage as String else { return }
        if let image = editingInfo[UIImagePickerControllerEditedImage] as? UIImage {
            
            let size = CGSize(width: 120, height: 120)
            let resizedImage = scaleUIImageToSize(image, size: size)
            profilePhoto.image = resizedImage
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signout(sender: AnyObject) {
        
        PFUser.logOutInBackground()
        
        let loginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginView")
        UIApplication.sharedApplication().keyWindow?.rootViewController = loginViewController
        
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
