//
//  InsetTextField.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/24/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {
        
        private var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return UIEdgeInsetsInsetRect(bounds, padding)
        }
        override func awakeFromNib() {
            print(self.placeholder!)
            let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
            self.attributedPlaceholder = placeholder
            super.awakeFromNib()
        }
        
    }


