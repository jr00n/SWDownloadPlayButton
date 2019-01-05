//
//  SWPlayButton+StateTransitionAnimation.swift
//  SWPlayButton
//
//  Created by Jeroen Wolff on 03/01/2019.
//  Copyright © 2019 StudioWolff. All rights reserved.
//

import UIKit
import os.log


extension SWDownloadPlayButton {

    func animateTransition(from oldState: State, to newState: State) {
        
        let completion: (Bool) -> Void = { completed in
            guard completed else { return }
            self.resetStateViews(except: newState)
            self.animationDispatchGroup.leave()
        }
        
        switch (oldState, newState) {
        case (.startDownload, .pending):
            animateTransitionFromStartDownloadToPending(completion: completion)
            
        case (.startDownload, .downloading):
            animateTransitionFromStartDownloadToDownloading(completion: completion)
            
        case (.pending, .startDownload):
            animateTransitionFromPendingToStartDownload(completion: completion)
            
        case (.pending, .downloading):
            animateTransitionFromPendingToDownloading(completion: completion)
            
        case (.downloading, .downloaded):
            animateTransitionFromDownloadingToDownloaded(completion: completion)
            
        case (.downloaded, .playing):
            animateTransitionFromDownloadedToPlaying(completion: completion)
        
        case (.playing, .paused):
            animateTransitionFromPlayingtoPaused(completion: completion)
            
        case (.paused, .playing):
            animateTransitionFromPausedtoPlaying(completion: completion)
            
        case (.downloading, .startDownload):
            animateTransitionFromDownloadingToStartDownload(completion: completion)
            
        default:
            handleUnsupportedTransitionAnimation(toState: newState)
        }
    }
    
    private func animateTransitionFromStartDownloadToPending(completion: @escaping (Bool) ->  Void) {
        
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.layoutIfNeeded()
        }, completion: { completed in
            completion(completed)
            guard completed else { return }
            self.pendingCircleView.alpha = 1
            self.pendingCircleView.startSpinning()
        })
        
    }
    
    private func animateTransitionFromStartDownloadToDownloading(completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.layoutIfNeeded()
        }, completion: { completed in
            completion(completed)
            guard completed else { return }
            self.startDownloadButton.alpha = 0
            self.downloadingButton.alpha = 1
        })
    }
    
    private func animateTransitionFromPendingToStartDownload(completion: @escaping (Bool) -> Void) {
 
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.pendingCircleView.alpha = 0
            self.startDownloadButton.alpha = 1
            self.layoutIfNeeded()
        }, completion: completion)
        
    }
    
    private func animateTransitionFromPendingToDownloading(completion: @escaping (Bool) -> Void) {

        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.pendingCircleView.alpha = 0
            self.downloadingButton.alpha = 1
        }, completion: completion)
    }
    
    private func animateTransitionFromDownloadingToDownloaded(completion: @escaping (Bool) -> Void) {
        
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.downloadingButton.alpha = 0
            self.playControlButton.alpha = 1
            self.playControlButton.isPlaying = false
        }, completion: completion)
        
    }
    
    private func animateTransitionFromDownloadedToPlaying(completion: @escaping (Bool) -> Void) {
        /*
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.downloadingButton.alpha = 0
            self.playControlButton.alpha = 1
            self.playControlButton.isPlaying = true
        }, completion: completion)
        */
        UIView.transition(with: playControlButton, duration: transitionAnimationDuration, options: .transitionCrossDissolve, animations: {
            self.downloadingButton.alpha = 0
            self.playControlButton.alpha = 1
            self.playControlButton.isPlaying = true
        }, completion: completion)
        
    }
   
    private func animateTransitionFromPlayingtoPaused(completion: @escaping (Bool) -> Void) {
        /*
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.playControlButton.alpha = 1
            self.playControlButton.isPlaying = false
        }, completion: completion)
        */
        UIView.transition(with: playControlButton, duration: transitionAnimationDuration, options: .transitionCrossDissolve, animations: {
            self.playControlButton.alpha = 1
            self.playControlButton.isPlaying = false
        }, completion: completion)
    }

    private func animateTransitionFromPausedtoPlaying(completion: @escaping (Bool) -> Void) {
        /*
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.playControlButton.alpha = 1
            self.playControlButton.isPlaying = true
        }, completion: completion)
        */
        UIView.transition(with: playControlButton, duration: transitionAnimationDuration, options: .transitionCrossDissolve, animations: {
            self.playControlButton.alpha = 1
            self.playControlButton.isPlaying = true
        }, completion: completion)
        
    }

    
    private func animateTransitionFromDownloadingToStartDownload(completion: @escaping (Bool) -> Void) {
        
        UIView.animate(withDuration: transitionAnimationDuration, animations: {
            self.downloadingButton.alpha = 0
            self.startDownloadButton.alpha = 1
        }, completion: completion)
        
    }
    
    private func handleUnsupportedTransitionAnimation(toState newState: State) {
        switch newState {
        case .startDownload:
            startDownloadButton.alpha = 1
        case .pending:
            pendingCircleView.alpha = 1
        case .downloading:
            downloadingButton.alpha = 1
        case .downloaded:
            playControlButton.alpha = 1
        case .playing:
            playControlButton.alpha = 1
            playControlButton.isPlaying = true
        case .paused:
            playControlButton.alpha = 1
            playControlButton.isPlaying = false
        }
        resetStateViews(except: newState)
        animationDispatchGroup.leave()
    }
    
    private func resetStateViews(except state: State) {
        if state != .startDownload {
            startDownloadButton.alpha = 0
        }
        
        if state != .pending {
            pendingCircleView.alpha = 0
        }
        
        if state != .downloading {
            downloadingButton.alpha = 0
            progress = 0
        }
        
        if state != .downloaded && state != .playing && state != .paused {
            playControlButton.alpha = 0
        }
        
    }

}
