//
//  PlayerView+EpisodeImageAnimation.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/14/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit

extension PlayerDetailsView {
    
    func enlargeEpisodeImageView() {
        // animation ... the function with spring
        // curveWithout >> quick accelaration in the beginning and at the end it slows off
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // the most important part
            self.episodeImageView.transform = .identity // back to the original state before transform
        }, completion: nil)
    }
    
    
    //let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
     func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = self.shrunkenTransform
        }, completion: nil)
    }
    
}
