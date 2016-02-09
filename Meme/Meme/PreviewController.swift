//
//  PreviewController.swift
//  Meme
//
//  Created by Javier C. Melendrez on 2/8/16.
//  Copyright © 2016 com.javier. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
 var meme: Meme!

    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imagePreview.image = meme.memedImage
    }

    
    @IBAction func edit(sender: UIBarButtonItem) {
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("EditorViewController") as! MemeEditorViewController
        
        controller.meme = meme
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
}
