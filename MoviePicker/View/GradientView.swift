//
//  GradientView.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 3/6/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var topColor : UIColor = #colorLiteral(red: 0.2470588235, green: 0.1647058824, blue: 0.6980392157, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor : UIColor = #colorLiteral(red: 0.7333333333, green: 0.4, blue: 0.8274509804, alpha: 1){
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer =  CAGradientLayer()
        gradientLayer.colors = [ topColor.cgColor , bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    
}
