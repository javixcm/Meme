//
//  ViewController.swift
//  Meme
//
//  Created by Javier C. Melendrez on 1/11/16.
//  Copyright © 2016 com.javier. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTitleMeme: UITextField!
    @IBOutlet weak var bottomTitleMeme: UITextField!
    @IBOutlet weak var camButton: UIBarButtonItem!
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    
    
    var meme:Meme!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTitleMeme.defaultTextAttributes = memeTextAttributes
        topTitleMeme.text = "TOP"
        topTitleMeme.textAlignment = .Center
        topTitleMeme.delegate = self
        
        bottomTitleMeme.defaultTextAttributes = memeTextAttributes
        bottomTitleMeme.text = "BOTTOM"
        bottomTitleMeme.textAlignment = .Center
        bottomTitleMeme.delegate = self
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        camButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    
    @IBAction func cleanMeme(sender: AnyObject) {
        imagePickerView.image = nil
        topTitleMeme.text = "TOP"
        bottomTitleMeme.text = "BOTTOM"
        
        showNavTool(true)
    }
    
    func showNavTool(status :Bool){
    
        if(status){
            navigationBar.hidden=false
            toolBar.hidden=false
        }else{
            navigationBar.hidden=true
            toolBar.hidden=true
        }
    }
    
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        
       
        
        if (imagePickerView.image == nil) {
            
            let imageNotSavedAlert = UIAlertController(title: "Empty Image", message: "Select Image", preferredStyle: UIAlertControllerStyle.Alert)
            imageNotSavedAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(imageNotSavedAlert, animated: true, completion: nil)
            
        } else {
            let memedImage = generateMemedImage()
            meme = Meme(topMemeText: topTitleMeme.text!, bottomMemeText: bottomTitleMeme.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
            let shareActivityView = UIActivityViewController(activityItems:[meme.memedImage!], applicationActivities: nil)
            shareActivityView.completionWithItemsHandler = { (activity: String?, success: Bool, items: [AnyObject]?, error: NSError?) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if (success) {
                       
                        self.unsubscribeFromKeyboardNotifications()
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
            }
            presentViewController(shareActivityView, animated: true, completion: nil)
            
        }
    }
    
    func generateMemedImage() -> UIImage {
        showNavTool(false)
        
        let defaultBackGroundColor = imagePickerView.backgroundColor
        imagePickerView.backgroundColor = UIColor.whiteColor()
        
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        // do error handling here
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imagePickerView.backgroundColor = defaultBackGroundColor
        
        showNavTool(true)
        
        return memedImage
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        pickImageGeneric("cam")
    }
    
  
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        pickImageGeneric("album")
    }
    
    
    func pickImageGeneric(type :String){

        let imagePickerController = UIImagePickerController()
        
        if(type=="album"){
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            presentViewController(imagePickerController, animated: true, completion: nil)
            
        
        }else{
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        showNavTool(true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topTitleMeme && textField.text! == "TOP") || (textField == bottomTitleMeme && textField.text! == "BOTTOM") {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        
        return false
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTitleMeme.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTitleMeme.isFirstResponder() {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
  
}

