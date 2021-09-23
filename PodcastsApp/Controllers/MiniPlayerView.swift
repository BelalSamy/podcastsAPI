//
//  MiniPlayerView.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/14/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit


    //- -------------------------------------------
    let miniPlayer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let miniPlayerImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        //UIColor(white: 0, alpha: 0.1)
        // make teh image round corners
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    let miniPlayerTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode Title"
        label.numberOfLines = 0
        label.textColor = .black
        //label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 14                                                                                        , weight: .bold)
        return label
    }()
    
    let miniPlayerFastForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "fast_forward_15").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let miniPlayerPlayOrPauseButton: UIButton = {
           let button = UIButton(type: .system)
              button.addTarget(self, action: #selector(handlePlayOrPause), for: .touchUpInside)
              button.setImage(#imageLiteral(resourceName: "mini_pause").withRenderingMode(.alwaysOriginal), for: .normal)
              return button
          }()


    
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

