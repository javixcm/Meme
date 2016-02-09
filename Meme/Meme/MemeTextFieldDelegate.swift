//
//  MemeTextFieldDelegate.swift
//  Meme
//
//  Created by Javier C. Melendrez on 2/8/16.
//  Copyright © 2016 com.javier. All rights reserved.
//


import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var isDefaultText: Bool = true
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if isDefaultText {
            textField.text = ""
            isDefaultText = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
}

