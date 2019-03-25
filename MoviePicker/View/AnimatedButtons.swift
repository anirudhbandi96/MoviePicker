//
//  UIButtonExt.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/27/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class AnimatedButtons : UIButton {
    var starView : LOTAnimationView!
    
    public func addStarView(){
        self.starView = LOTAnimationView(name: "star")
        print(self.starView)
        self.starView.frame = CGRect(x: 0, y: 0, width: self.frame.width * 2.2, height: self.frame.height * 2.2)
        starView.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        self.starView.contentMode = .scaleAspectFill
        self.starView.animationSpeed = 1.0
        self.starView.alpha = 0.0
        self.starView.loopAnimation = false
        self.starView.isUserInteractionEnabled = false
        self.starView.isExclusiveTouch = false
        self.addSubview(starView)
    }
    
    override func awakeFromNib() {
        print("new button created")
        addStarView()
    }
    
    
}


