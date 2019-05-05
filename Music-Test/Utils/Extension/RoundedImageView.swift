//
//  RoundedImageView.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/5/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedImageView : UIImageView {
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0.0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
