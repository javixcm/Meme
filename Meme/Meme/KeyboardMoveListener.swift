//
//  KeyboardMoveListener.swift
//  Meme
//
//  Created by Javier C. Melendrez on 2/8/16.
//  Copyright © 2016 com.javier. All rights reserved.
//

import Foundation
import UIKit

class KeyboardMoveListener: NSObject {
    
    var view: UIView?
    var elements: [UIResponder] = []
    let notificationCenter = NSNotificationCenter.defaultCenter()
    
   
    func subscribe(view: UIView, elements: [UIResponder]) {
        self.view = view
        self.elements = elements
        
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
   
    func unsubscribe() {
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
   
    func keyboardWillShow(notification: NSNotification) {
        for element in elements {
            if element.isFirstResponder() {
                view!.frame.origin.y = -(notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
                return
            }
        }
    }
    
  
    func keyboardWillHide(notification: NSNotification) {
        view!.frame.origin.y = 0
    }
}