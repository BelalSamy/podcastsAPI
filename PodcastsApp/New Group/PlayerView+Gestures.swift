//
//  PlayerView+Gestures.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/14/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit

extension PlayerDetailsView {
    
    func setupGestures() {
        // tap gesture
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        // pan gesture
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        // so pan gesture will only work on mini player view and thats fix the bug
        miniPlayer.addGestureRecognizer(panGesture)
        maximizedView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    //MARK:- TAP
    @objc func handleTapMaximize() {
        maxView()
        //panGesture.isEnabled = false
    }
    
    //MARK:- main player PAN
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = .identity
                
                if translation.y > 50 {
                    self.minView()
                } else {
                    
                }
                
            })
        }
    }
    
    
    //MARK:- mini player PAN
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        // to get the current state of the gesture
        if gesture.state == .began {
            //print("Began")
        } else if gesture.state == .changed {
            self.handlePanChanged(gesture: gesture)
            
        } else if gesture.state == .ended {
            self.handlePanEnded(gesture: gesture)
        }
    }
    
    fileprivate func handlePanChanged(gesture: UIPanGestureRecognizer) {
        //print("Changed")
           let translation = gesture.translation(in: view)
           view.transform = CGAffineTransform(translationX: 0, y: translation.y) // -200 to move up
           //print(translation.y)
           self.miniPlayer.alpha = 1 + translation.y / 200 //fadding effect
           self.maximizedView.alpha = -translation.y / 200
    }
    
    fileprivate func handlePanEnded(gesture: UIPanGestureRecognizer) {
        //print("Ended")
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        print("Ended: ", velocity.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                // if it less than 200
                self.maxView()
                //gesture.isEnabled = false // we want to disable gesture at max mode to fix ui bug
            } else {
                self.miniPlayer.alpha = 1
                self.maximizedView.alpha = 0
            }
        })
    }
    
}
