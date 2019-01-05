//
//  ViewController.swift
//  SWDownloadPlayButton
//
//  Created by jr00n on 01/05/2019.
//  Copyright (c) 2019 jr00n. All rights reserved.
//

import UIKit
import SWDownloadPlayButton

class ViewController: UIViewController {

    var downloadTimer: Timer?
    let playButton = SWDownloadPlayButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let width: CGFloat = 120
        let size = CGSize(width: width, height: width )
        let origin = CGPoint(x: view.center.x - size.width / 2, y: view.center.y - size.height / 2)
        playButton.frame = CGRect(origin: origin, size: size)
        view.addSubview(playButton)
        playButton.delegate = self
    }
    
    
    func simulateDownloading() {
        downloadTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            guard self.playButton.progress < 1 else {
                self.playButton.state = .downloaded
                timer.invalidate()
                return
            }
            self.playButton.progress += CGFloat(timer.timeInterval/2)
            print("percentage: \(self.playButton.progress)")
        }
        downloadTimer?.fire()
    }
    
    
}

extension ViewController: SWDownloadPlayButtonDelegate {
    
    func didTapPlayButton(withState state: SWDownloadPlayButton.State) {
        switch state {
        case .startDownload:
            downloadTimer?.invalidate()
            playButton.progress = 0
            playButton.state = .pending
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.playButton.state = .downloading
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.simulateDownloading()
                }
            }
            
            
        case .pending:
            break
        case .downloading:
            downloadTimer?.invalidate()
            playButton.progress = 0
            playButton.state = .startDownload
        case .downloaded:
            playButton.state = .playing
        case .playing:
            playButton.state = .paused
            break
        case .paused:
            playButton.state = .playing
        }
    }
    
}

