//
//  CustomAnimationPresentor.swift
//  Habit
//
//  Created by Ali Sanaknaki on 2020-04-21.
//  Copyright © 2020 Ali Sanaknaki. All rights reserved.
//

import UIKit

class CustomAnimationPresentor: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        containerView.addSubview(toView)
        
        let startingFrame = CGRect(x: 0, y: -toView.frame.height, width: toView.frame.width, height: toView.frame.height)
        toView.frame = startingFrame
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // Animation
            
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = CGRect(x: 0, y: fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
        }) { (_) in
            // Notify system that transition is done and interact with the toView
            transitionContext.completeTransition(true)
        }
    }
}

