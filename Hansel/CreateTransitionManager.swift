//
//  TransitionManager.swift
//  Insights
//
//  Created by Adrian le Bas on 29/12/14.
//  Copyright (c) 2014 Adrian le Bas. All rights reserved.
//

import UIKit

class CreateTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    private var presenting = false
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView()
        
        
        // create a tuple of our screens
        let screens : (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        // assign references to our menu view controller and the 'bottom' view controller from the tuple
        // remember that our menuViewController will alternate between the from and to view controller depending if we're presenting or dismissing
        let createViewController = !self.presenting ? screens.from as CreateViewController : screens.to as CreateViewController
        let mainViewController = !self.presenting ? screens.to as UINavigationController : screens.from as UINavigationController
        
//        let menuView = menuViewController.view
//        let bottomView = bottomViewController.view
        
        // prepare menu items to slide in
        if (self.presenting){
//            self.offStageMenuController(menuViewController)
        }
        
        // add the both views to our view controller
        container.addSubview(mainViewController.view)
        container.addSubview(createViewController.view)
        
        let duration = self.transitionDuration(transitionContext)
        
        // perform the animation!
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: nil, animations: {
            
            if (self.presenting){
                self.onStageMenuController(createViewController, mainViewController: mainViewController) // onstage items: slide in
            }
            else {
                self.offStageMenuController(createViewController, mainViewController: mainViewController) // offstage items: slide out
            }
            
            }, completion: { finished in
                
                // tell our transitionContext object that we've finished animating
                transitionContext.completeTransition(true)
                
                // bug: we have to manually add our 'to view' back http://openradar.appspot.com/radar?id=5320103646199808
                UIApplication.sharedApplication().keyWindow?.addSubview(screens.to.view)
                
        })
        
    }
    
    func offStage(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeScale(x, y)
//        return CGAffineTransformMakeTranslation(x, y)
    }
    
    func offStageMenuController(createViewController: CreateViewController, mainViewController : UINavigationController){
        
        createViewController.view.alpha = 0
        createViewController.view.transform = self.offStage(1.1, y: 1.1)
        var viewController = mainViewController.viewControllers[0] as MainViewController
        viewController.overallBlur.alpha = 0
        mainViewController.navigationBar.alpha = 1
        viewController.tableView.transform = CGAffineTransformIdentity
        mainViewController.navigationBar.transform = CGAffineTransformIdentity
        
//        
//        // setup paramaters for 2D transitions for animations
//        let topRowOffset  :CGFloat = 300
//        let middleRowOffset :CGFloat = 150
//        let bottomRowOffset  :CGFloat = 50
//        
//        menuViewController.textPostIcon.transform = self.offStage(-topRowOffset)
//        menuViewController.textPostLabel.transform = self.offStage(-topRowOffset)
//        
//        menuViewController.quotePostIcon.transform = self.offStage(-middleRowOffset)
//        menuViewController.quotePostLabel.transform = self.offStage(-middleRowOffset)
//        
//        menuViewController.chatPostIcon.transform = self.offStage(-bottomRowOffset)
//        menuViewController.chatPostLabel.transform = self.offStage(-bottomRowOffset)
//        
//        menuViewController.photoPostIcon.transform = self.offStage(topRowOffset)
//        menuViewController.photoPostLabel.transform = self.offStage(topRowOffset)
//        
//        menuViewController.linkPostIcon.transform = self.offStage(middleRowOffset)
//        menuViewController.linkPostLabel.transform = self.offStage(middleRowOffset)
//        
//        menuViewController.audioPostIcon.transform = self.offStage(bottomRowOffset)
//        menuViewController.audioPostLabel.transform = self.offStage(bottomRowOffset)
        
        
        
    }
    
    func onStageMenuController(createViewController: CreateViewController, mainViewController : UINavigationController){
        
        // prepare menu to fade in
        createViewController.view.alpha = 1
        createViewController.view.transform = CGAffineTransformIdentity
        var viewController = mainViewController.viewControllers[0] as MainViewController
        viewController.overallBlur.alpha = 1
        
        mainViewController.navigationBar.alpha = 0
        viewController.tableView.transform = self.offStage(0.99, y:0.99)
//        mainViewController.navigationBar.transform = self.offStage(1, y:1)

        
//        menuViewController.textPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.textPostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.quotePostIcon.transform = CGAffineTransformIdentity
//        menuViewController.quotePostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.chatPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.chatPostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.photoPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.photoPostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.linkPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.linkPostLabel.transform = CGAffineTransformIdentity
//        
//        menuViewController.audioPostIcon.transform = CGAffineTransformIdentity
//        menuViewController.audioPostLabel.transform = CGAffineTransformIdentity
        
    }
    
    // return how many seconds the transiton animation will take
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // rememeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}