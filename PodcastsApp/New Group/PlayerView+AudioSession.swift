//
//  PlayerView+AudioSession.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/14/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import MediaPlayer // for command center

extension PlayerDetailsView {
        
    //MARK:- Enable Background
    
    // to make the audio work in background
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to activate session : ", sessionErr)
        }
    }
    
    //MARK:- Command Center

    // to control the player from command center
    func setupRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // play
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            //print("should play podcast ...")
            self.player.play()
            self.playOrPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
            self.miniPlayerPlayOrPauseButton.setImage(#imageLiteral(resourceName: "mini_pause").withRenderingMode(.alwaysOriginal), for: .normal)
            self.setupLockScreenDuration(playbackRate: 1)
            return .success
        }
        
        // pause
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            //print("should pause podcast ...")
            self.player.pause()
            self.playOrPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
            self.miniPlayerPlayOrPauseButton.setImage(#imageLiteral(resourceName: "mini_play").withRenderingMode(.alwaysOriginal), for: .normal)
            self.setupLockScreenDuration(playbackRate: 0)
            return .success
        }
        
        // to play and pause audio from headphone button
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayOrPause()
//            if self.player.timeControlStatus == .playing {
//            } else {
//            }
            return .success
        }
        
        
        // pervious track
        commandCenter.previousTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePreviousTrack()
            return .success
        }
        
        
        // next track
        commandCenter.nextTrackCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handleNextTrack()
            return .success
        }
        
    }
    
    
    func handleNextTrack() {
        //self.playlistEpisodes.forEach({ print($0.title ?? "") }) // print all episodes
        if self.playlistEpisodes.count == 0 {
           return // list is empty
        }
        
        let currentEpisodeIndex = self.playlistEpisodes.firstIndex { (ep) -> Bool in
            return  self.episode?.title == ep.title && self.episode?.author == ep.author
        }
        
        guard  let index = currentEpisodeIndex else { return }
        let nextEpisode: Episode
        
        if index == playlistEpisodes.count - 1 {
            nextEpisode = playlistEpisodes[0]
        } else {
            nextEpisode = playlistEpisodes[index + 1 ]
        }
        
        print("go to episode : ", nextEpisode.title!)
        self.episode = nextEpisode
    }
    
    func handlePreviousTrack() {
        
        if self.playlistEpisodes.count == 0 {
           return // list is empty
        }
        
        let currentEpisodeIndex = self.playlistEpisodes.firstIndex { (ep) -> Bool in
            return  self.episode?.title == ep.title && self.episode?.author == ep.author
        }
        
        guard  let index = currentEpisodeIndex else { return }
        let perviousTrack: Episode
        
        if index == 0 {
            perviousTrack = playlistEpisodes[playlistEpisodes.count - 1]
        } else {
            perviousTrack = playlistEpisodes[index - 1 ]
        }
        
        print("go to episode : ", perviousTrack.title!)
        self.episode = perviousTrack
    }
    
    //MARK:- LockScreen

    // put episode info in the lock screen
    func setupNowPlayingInfo(title: String, author: String, image: UIImage) {
        var nowPlayingInfo = [String: Any]()
       
        let artworkItem = MPMediaItemArtwork(boundsSize: .zero) { (size) -> UIImage in
            return image
        }
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = author
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artworkItem
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    
    }
    
    // lock screen duration
    func setupLockScreenDuration(playbackRate: Float) {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        guard let currentItem = player.currentItem else { return }
        
        // fix bug : the operating system still calculating the time
        nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate

        // progress time
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        
        // duration time
        let durationInSeconds = CMTimeGetSeconds(currentItem.duration)
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    //MARK:- Interruptions

    // phone calls or other audio apps works
    func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption),
                                               name: AVAudioSession.interruptionNotification,
                                               object: nil)
    }
    
    @objc func handleInterruption(notification: Notification) {
        print("Interruption observed")
        guard let userInfo = notification.userInfo else { return }
        // we cast it ... bec the raw value is UInt
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        
        if type == AVAudioSession.InterruptionType.began.rawValue {
            print("Interruption began ...")
            playOrPauseButton.setImage(#imageLiteral(resourceName: "play").withRenderingMode(.alwaysOriginal), for: .normal)
            miniPlayerPlayOrPauseButton.setImage(#imageLiteral(resourceName: "mini_play").withRenderingMode(.alwaysOriginal), for: .normal)
            shrinkEpisodeImageView()
            player.pause()
            
        } else {
            print("Interruption ended ...")
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                playOrPauseButton.setImage(#imageLiteral(resourceName: "pause").withRenderingMode(.alwaysOriginal), for: .normal)
                miniPlayerPlayOrPauseButton.setImage(#imageLiteral(resourceName: "mini_pause").withRenderingMode(.alwaysOriginal), for: .normal)
                enlargeEpisodeImageView()
                player.play()
            }
        }
    }
}
