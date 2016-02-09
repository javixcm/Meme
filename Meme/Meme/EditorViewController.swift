//
//  EditorViewController.swift
//  Meme
//
//  Created by Javier C. Melendrez on 2/8/16.
//  Copyright © 2016 com.javier. All rights reserved.
//



import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var welcomeMessage: UITextView!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var pickImageFromCameraButton: UIBarButtonItem!
    @IBOutlet weak var pickImageFromAlbumButton: UIBarButtonItem!
    @IBOutlet weak var shareMemedImageButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbarTop: UIToolbar!
    
    let keyboardMoveListener = KeyboardMoveListener()
    let textTopDelegate = MemeTextFieldDelegate()
    let textBottomDelegate = MemeTextFieldDelegate()
    
    var meme = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initToolbars()
        initTextField(textTop, text: meme.topText, delegate: textTopDelegate)
        initTextField(textBottom, text: meme.bottomText, delegate: textBottomDelegate)
        
       
        welcomeMessage.hidden = false
        shareMemedImageButton.enabled = false
        
       
        if let image = meme.originalImage {
            loadPreviewImage(image)
            (textTop.delegate as! MemeTextFieldDelegate).isDefaultText = false
            (textBottom.delegate as! MemeTextFieldDelegate).isDefaultText = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        keyboardMoveListener.subscribe(view, elements: [textBottom])
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        keyboardMoveListener.unsubscribe()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
   
    func initToolbars() {
        pickImageFromCameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        pickImageFromAlbumButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
    }
    
   
    func initTextField(element: UITextField, text: String, delegate: UITextFieldDelegate) {
        let attributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
        ]
        
        element.text = text
        element.delegate = delegate
        element.defaultTextAttributes = attributes
        element.textAlignment = NSTextAlignment.Center
        element.hidden = true
    }
   
    func initPickAnImageButton(sourceType: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = sourceType
        presentViewController(controller, animated: true, completion: nil)
    }
    
   
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            loadPreviewImage(image)
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func loadPreviewImage(image: UIImage) {
        imagePreview.image = image
        textBottom.hidden = false
        textTop.hidden = false
        welcomeMessage.hidden = true
        shareMemedImageButton.enabled = true
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        shareMemedImageButton.enabled = (imagePreview.image != nil)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    func generateMemedImage() -> UIImage
    {
        var image = UIImage() ;
        
        for view in self.view.subviews {
            if view.restorationIdentifier == "meme" {
               
                UIGraphicsBeginImageContext(view.frame.size)
                
               
                let statusBarHeight = (view.window?.convertRect(UIApplication.sharedApplication().statusBarFrame, fromView: view))!.height
                let toolbarHeight = toolbarTop.frame.height
                let context = UIGraphicsGetCurrentContext() ;
                CGContextTranslateCTM(context, 0, -(statusBarHeight + toolbarHeight)) ;
                
              
                view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        
        return image
    }
    
    /*
    * Save Meme model to presistent storage
    */
    func saveMemedImage(image: UIImage) {
        meme.topText = textTop.text!
        meme.bottomText = textBottom.text!
        meme.originalImage = imagePreview.image!
        meme.memedImage = image
        
        // Save Meme to "presistent storage" in AppDelegate :))
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        initPickAnImageButton(.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        initPickAnImageButton(.Camera)
    }
    
    @IBAction func shareMemedImage(sender: UIBarButtonItem) {
        let image = generateMemedImage() ;
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> () in
            if (completed) {
                self.saveMemedImage(image)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelEdit(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Do you really want to cancel editing?", message: nil, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction!) in
            self.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        alert.addAction(UIAlertAction(title: "Keep editing", style: .Default) { (action: UIAlertAction!) in
            alert.dismissViewControllerAnimated(true, completion: nil)
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

