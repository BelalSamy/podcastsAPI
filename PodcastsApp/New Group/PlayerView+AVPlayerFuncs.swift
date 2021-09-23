//
//  PlayerView+AVPlayerFuncs.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/14/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension PlayerDetailsView {
    
     func playEpisode() {
        if episode?.fileUrl != nil {
            playEpisodeOffline()
        } else {
            playEpisodeOnline()
        }
    }
    
    fileprivate func playEpisodeOnline() {
        print("Trying to play episode online from stream url : ", episode?.streamUrl ?? "" )
        guard let url = URL(string: episode?.streamUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    fileprivate func playEpisodeOffline() {
        print("Trying to play episode offline from file url : ", episode?.fileUrl ?? "" )
        
        // lets figure out the file name for our episode file url
        guard let fileURL = URL(string: episode?.fileUrl ?? "") else { return }
        let fileName = fileURL.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        trueLocation.appendPathComponent(fileName)
        print("True Location of episode : ",trueLocation.absoluteString)
        
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }

       
       
    func seekToTime(value: Int64) {
       let fifteenSeconds = CMTimeMake(value: value, timescale: 1)
       let seekTime = CMTimeAdd( player.currentTime(), fifteenSeconds )
       player.seek(to: seekTime )
   }
   
   
    func observePlayerCurrentTime() {
       // to notify when the player slowly update -------------------
       let interval = CMTimeMake(value: 1, timescale: 2)
       
       // [weak self] in >>> to stop the retain cycle to make player stops when dismiss
       // make sure you put it before closure parameter
       player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self]  (time) in
           self?.currentTimeLabel.text = time.toDisplayString()
           guard let durationTime = self?.player.currentItem?.duration else { return }
           self?.durationLabel.text = durationTime.toDisplayString()
           self?.updateCurrentTimeSlider()
       }
   }
   
   
   /* to test that retain cycle stops
   deinit {
       print("PlayerDetailsView memory being reclaimed ...")
   }*/
   
   
    func updateCurrentTimeSlider() {
       let currentTimeSeconds = CMTimeGetSeconds( player.currentTime() )
       let durationSeconds = CMTimeGetSeconds( player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1) )
       let percentage = currentTimeSeconds / durationSeconds
       self.currentTimeSlider.value = Float(percentage)
   }
   
   
    func observeBoundryTime() {
       // to detect when the player starts ---------------------------
       let time = CMTimeMake(value: 1, timescale: 3)
       let times = [ NSValue(time: time) ]         // array of time objects
       
       // player has reference to self
       // also self has a reference to player
       // [weak self] in >>> we going to break the retain cycle to make player stop when dismiss
       player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
           print("Episode started playing")
           // show duration in lock screen
           self?.setupLockScreenDuration(playbackRate: 1)
           self?.enlargeEpisodeImageView()
       }
   }
}
