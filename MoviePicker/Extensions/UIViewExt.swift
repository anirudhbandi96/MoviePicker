//
//  UIViewExt.swift
//  MoviePicker
//
//  Created by Anirudh Bandi on 2/24/18.
//  Copyright © 2018 Anirudh Bandi. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    private struct AnimationKey {
        static let Rotation = "rotation"
        static let Bounce = "bounce"
    }
    
   
    
    public func startWiggle(){
        
        let wiggleBounceY = 2.0
        let wiggleBounceDuration = 0.18
        let wiggleBounceDurationVariance = 0.025
        
        let wiggleRotateAngle = 0.02
        let wiggleRotateDuration = 0.14
        let wiggleRotateDurationVariance = 0.025
        
        guard // If the view is already animating rotation or bounce, return
            let keys = layer.animationKeys(),
            keys.contains(AnimationKey.Rotation) == false,
            keys.contains(AnimationKey.Bounce) == false
            else {
                return
        }
        
        //Create rotation animation
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [-wiggleRotateAngle, wiggleRotateAngle]
        rotationAnimation.autoreverses = true
        rotationAnimation.duration = randomize(interval: wiggleRotateDuration, withVariance: wiggleRotateDurationVariance)
        rotationAnimation.repeatCount = .infinity
        
        //Create bounce animation
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceAnimation.values = [wiggleBounceY, 0]
        bounceAnimation.autoreverses = true
        bounceAnimation.duration = randomize(interval: wiggleBounceDuration, withVariance: wiggleBounceDurationVariance)
        bounceAnimation.repeatCount = .infinity
        
        //Apply animations to view
        UIView.animate(withDuration: 0) {
            self.layer.add(rotationAnimation, forKey: AnimationKey.Rotation)
            self.layer.add(bounceAnimation, forKey: AnimationKey.Bounce)
            self.transform = .identity
        }
    }
    
    public func stopWiggle(){
        layer.removeAnimation(forKey: AnimationKey.Rotation)
        layer.removeAnimation(forKey: AnimationKey.Bounce)
    }
    
    // Utility
    
    private func randomize(interval: TimeInterval, withVariance variance: Double) -> Double{
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }
}
