//
//  PlayerDetailsView.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/9/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit
import AVKit // audio and video
import MediaPlayer // comand center

class PlayerDetailsView: UIViewController {
    
     var episode: Episode? {
           didSet {
            
               // title
               titleLabel.text = episode?.title
               miniPlayerTitleLabel.text = episode?.title
            
               // author
               authorLabel.text = episode?.author
            
               // image
               guard let url = URL(string: episode?.imageUrl?.toSecureHTTPS() ?? "") else { return }
               episodeImageView.sd_setImage(with: url, completed: nil)
               miniPlayerImageView.sd_setImage(with: url, completed: nil)
            
               // Episode Auto Play
               setupAudioSession()
               playEpisode()
            
               // lock screen info
               self.setupNowPlayingInfo(title: self.episode?.title ?? "Episode Title",
                                     author: self.episode?.author ?? "Author",
                                     image: self.episodeImageView.image ?? UIImage() )
         }
     }
    
    let maximizedView: UIView = {
           let view = UIView()
           view.backgroundColor = .white
           return view
       }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let episodeImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor(white: 0, alpha: 0.1)
        // make teh image round corners
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Episode Title"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        //label.backgroundColor = .yellow
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "Unknown Author"
        label.textAlignment = .center
        label.textColor = UIColor.customPurpleColor()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    
    
    // audio progress bar
    let currentTimeSlider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(handleTimeSliderChange), for: .valueChanged)
        return slider
    }()
    
    
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = .darkGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    
    
    // rewind / play / fast forward
    let rewindButton: UIButton = {
           let button = UIButton(type: .system)
           button.addTarget(self, action: #selector(handleRewind), for: .touchUpInside)
           button.setImage(#imageLiteral(resourceName: "rewind_15").withRenderingMode(.alwaysOriginal), for: .normal)
           return button
       }()
    
    let playOrPauseButton: UIButton = {
        let button = UIButton(type: .system)
           button.addTarget(self, action: #selector(handlePlayOrPause), for: .touchUpInside)
           button.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
           return button
       }()
    
    let fastForwardButton: UIButton = {
           let button = UIButton(type: .system)
           button.addTarget(self, action: #selector(handleFastForward), for: .touchUpInside)
           button.setImage(#imageLiteral(resourceName: "fast_forward_15").withRenderingMode(.alwaysOriginal), for: .normal)
           return button
       }()
    
    
    
    // sound buttons
    let mutedButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "muted_volume"), for: .normal)
        return button
    }()
    
    let soundVolumeSlider: UISlider = {
       let slider = UISlider()
        slider.value = 1
       slider.addTarget(self, action: #selector(handleVolumeChanged), for: .valueChanged)
       return slider
   }()
    
    let maxButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "max_volume"), for: .normal)
        return button
    }()
    
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
    
    
    var avPlayer : AVPlayer = AVPlayer() // to reduce errors
    
    // closure / block / anonumus function for player
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false // to make audio works fast without any delay
        return avPlayer
    }()
    
    // shrunk transform
    let shrunkenTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
    // to able to access pan gesture
    var panGesture: UIPanGestureRecognizer!

    var playlistEpisodes = [Episode]()
    
    
    //MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // UI
        setupViews()
        setupMiniPlayer()
        setupGestures()
        
        //funcs
        observeBoundryTime()
        observePlayerCurrentTime()
        setupRemoteControl()
        setupInterruptionObserver()
        
    }
    
    // MARK:- Minimize and Maximize Funcs
    
       func maxView() {
            UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
       }
       
        func minView() {
            UIApplication.mainTabBarController()?.minmizePlayerDetails()
            //panGesture.isEnabled = true // we want to enable it agian  at min mode
       }
       
    //MARK:- Target Actions
    
    @objc func handleDismiss() {
        print("dismiss")
        //dismiss(animated: true, completion: nil)
        minView()
    }
    
    @objc func handleRewind() {
       seekToTime(value: -15)
    }
    
    @objc func handleFastForward() {
       seekToTime(value: 15)
    }
    
    @objc func handleVolumeChanged() {
     player.volume = soundVolumeSlider.value
    }
    
    
   @objc func handleTimeSliderChange() {
       //print("Slider Value : ",currentTimeSlider.value)
       let percentage = currentTimeSlider.value
       
       guard let duration = player.currentItem?.duration else { return }
       let durationInSeconds = CMTimeGetSeconds(duration)
       let seekTimeInSeconds = Float64(percentage) * durationInSeconds
       
       let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
    
       // update lock screen elapsed time ( progress time )
       MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
    
       player.seek(to: seekTime)
   }
       
    
    @objc func handlePlayOrPause() {
        if player.timeControlStatus == .paused {
            
            print("Trying to play")
            player.play()
            playOrPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
            miniPlayerPlayOrPauseButton.setImage(#imageLiteral(resourceName: "mini_pause").withRenderingMode(.alwaysOriginal), for: .normal)
            enlargeEpisodeImageView()
            self.setupLockScreenDuration(playbackRate: 1)
        } else {
            
            print("Trying to pause")
            player.pause()
            playOrPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
            miniPlayerPlayOrPauseButton.setImage(#imageLiteral(resourceName: "mini_play").withRenderingMode(.alwaysOriginal), for: .normal)
            shrinkEpisodeImageView()
            self.setupLockScreenDuration(playbackRate: 0)
        }
    }
    
       
    
    // MARK:- Player Funcs
    
   // to test that retain cycle stops
   deinit {
       print("PlayerDetailsView memory being reclaimed ...")
   }
    
    
}
