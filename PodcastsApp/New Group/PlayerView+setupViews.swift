//
//  PlayerView+setupViews.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/14/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit

extension PlayerDetailsView {
    
     func setupViews() {
        
        view.addSubview(maximizedView)
        maximizedView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                             right: view.rightAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0)
        
        // dismiss button
        maximizedView.addSubview(dismissButton)
        dismissButton.anchor(top: maximizedView.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil,
                         paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                         width: 0, height: 0)
        dismissButton.centerXAnchor.constraint(equalTo: maximizedView.centerXAnchor).isActive = true
        
        
        // episode image view
        maximizedView.addSubview(episodeImageView)
        //let scale: CGFloat = 0.7
        //self.episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        episodeImageView.transform = shrunkenTransform // make the image smaller .. very cool trick
        episodeImageView.anchor(top: dismissButton.bottomAnchor, left: maximizedView.leftAnchor, bottom: nil,
                                right: maximizedView.rightAnchor,
                                paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20,
                                width: 0, height: view.frame.width - 40 )
        
        // audio progress bar
        maximizedView.addSubview(currentTimeSlider)
        currentTimeSlider.anchor(top: episodeImageView.bottomAnchor, left: episodeImageView.leftAnchor, bottom: nil,
                                right: episodeImageView.rightAnchor,
                                paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                width: 0, height: 0)
        
        
        // player labels stack view
        let labelsStackView = UIStackView(arrangedSubviews: [currentTimeLabel, durationLabel ])
        labelsStackView.axis = .horizontal
        //labelsStackView.distribution = .fillEqually
        
        maximizedView.addSubview(labelsStackView)
        labelsStackView.anchor(top: currentTimeSlider.bottomAnchor, left: currentTimeSlider.leftAnchor, bottom: nil,
                                right: currentTimeSlider.rightAnchor,
                                paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                width: 0, height: 0)
        
        
        // episode title label
        maximizedView.addSubview(titleLabel)
        titleLabel.anchor(top: durationLabel.bottomAnchor, left: currentTimeSlider.leftAnchor, bottom: nil,
                          right: currentTimeSlider.rightAnchor,
                         paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                         width: 0, height: 0)
        
        
        // episode author label
        maximizedView.addSubview(authorLabel)
        authorLabel.anchor(top: titleLabel.bottomAnchor, left: currentTimeSlider.leftAnchor, bottom: nil,
                         right: currentTimeSlider.rightAnchor,
                         paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                         width: 0, height: 0)
        
        
        // player buttons stack view
        let buttonsStackView = UIStackView(arrangedSubviews: [rewindButton, playOrPauseButton, fastForwardButton] )
        buttonsStackView.axis = .horizontal
        buttonsStackView.distribution = .fillEqually
        
        maximizedView.addSubview(buttonsStackView)
        buttonsStackView.anchor(top: authorLabel.bottomAnchor, left: maximizedView.leftAnchor,
                         bottom: nil, right:maximizedView.rightAnchor,
                         paddingTop: 10, paddingLeft: 60, paddingBottom: 0, paddingRight: 60,
                         width: 0, height: 70)
        
        // sound buttons stack view
        let soundStackView = UIStackView(arrangedSubviews: [mutedButton, soundVolumeSlider, maxButton] )
        soundStackView.axis = .horizontal
        soundStackView.spacing = 10.0
        //soundStackView.distribution = .fillEqually
        
        maximizedView.addSubview(soundStackView)
        soundStackView.anchor(top: buttonsStackView.bottomAnchor, left: maximizedView.leftAnchor,
                         bottom: nil, right: maximizedView.rightAnchor,
                         paddingTop: 10, paddingLeft: 50, paddingBottom: 0, paddingRight: 50,
                         width: 0, height: 30)
        
    }
    
    
     func setupMiniPlayer() {
        
        //view.insertSubview(miniPlayer, belowSubview: dismissButton)
        view.addSubview(miniPlayer)
        miniPlayer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor,
                          paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                          width: 0, height: 64)
        
        // seperator
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.1)
        miniPlayer.addSubview(separatorView)
        separatorView.anchor(top: miniPlayer.topAnchor, left: miniPlayer.leftAnchor, bottom: nil,
                             right: miniPlayer.rightAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                             width: 0, height: 0.5)
        
        miniPlayer.addSubview(miniPlayerImageView)
        miniPlayerImageView.anchor(top: miniPlayer.topAnchor, left: miniPlayer.leftAnchor,
                                   bottom: miniPlayer.bottomAnchor, right: nil,
                                   paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0,
                                   width: 48, height: 48 )
        
        miniPlayer.addSubview(miniPlayerTitleLabel)
        miniPlayerTitleLabel.anchor(top: miniPlayer.topAnchor, left: miniPlayerImageView.rightAnchor,
                                    bottom: miniPlayer.bottomAnchor, right: nil,
                                    paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8,
                                    width: 0, height: 48)
        
        miniPlayer.addSubview(miniPlayerPlayOrPauseButton)
        miniPlayerPlayOrPauseButton.anchor(top: miniPlayer.topAnchor, left: miniPlayerTitleLabel.rightAnchor,
                                           bottom: miniPlayer.bottomAnchor, right: nil,
                                           paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0,
                                           width: 48, height: 48)
        
        miniPlayer.addSubview(miniPlayerFastForwardButton)
        miniPlayerFastForwardButton.anchor(top: miniPlayer.topAnchor, left: miniPlayerPlayOrPauseButton.rightAnchor,
                                           bottom: miniPlayer.bottomAnchor, right: miniPlayer.rightAnchor,
                                           paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8,
                                           width: 48, height: 48)
        
    }
}
