//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Akshay Gangwar on 29/03/16.
//  Copyright © 2016 Akshay Gangwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMeme: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UINavigationBar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    struct  Meme {
        var topString: String = ""
        var bottomString: String = ""
        var image: UIImage
        var memedImage: UIImage
    }
    
    @IBAction func createMeme(sender: AnyObject) {
        let generatedMeme = generateMemedImage()
        save(generatedMeme)
        //imagePicker.image = generatedMeme //Testing to see if a uiimage meme is created properly without toolbar/navbar.
        let activityController = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        topToolBar.hidden = false
        bottomToolBar.hidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topString: topTextField.text!, bottomString: bottomTextField.text!, image: imagePicker.image!, memedImage: memedImage)
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: NSNumber(float: -3.0)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        topTextField.adjustsFontSizeToFitWidth = true
        let tapGesture = UITapGestureRecognizer(target: self, action: "tap:")
        view.addGestureRecognizer(tapGesture)
        if (imagePicker.image == nil){
            shareMeme.enabled = false
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeToKeyboardNotifications()
    }
    
    func tap(gesture: UITapGestureRecognizer) {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print ("function called")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePicker.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        shareMeme.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //if cancelled by user, simply dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("Keyboard will show called")
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        //self.bottomTextField.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("Keyboard will hide called")
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

