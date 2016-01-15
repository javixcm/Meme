//
//  Meme.swift
//  Meme
//
//  Created by Javier C. Melendrez on 1/15/16.
//  Copyright © 2016 com.javier. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText : String
    var bottomText : String
    var originalImage : UIImage?
    var memedImage : UIImage?

    init(topMemeText: String, bottomMemeText:String, originalImage: UIImage, memedImage : UIImage){
        topText = topMemeText
        bottomText = bottomMemeText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}