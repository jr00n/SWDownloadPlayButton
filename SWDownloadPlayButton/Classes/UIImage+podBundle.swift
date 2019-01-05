//
//  UIVImage+podBundle.swift
//  SWPDownloadlayButton
//
//  Created by Jeroen Wolff on 03/01/2019.
//  Copyright © 2019 studioWolff. All rights reserved.
//
extension UIImage {
    convenience init?(podAssetName: String) {
        let podBundle = Bundle(for: SWDownloadPlayButton.self)
        
        /// A given class within your Pod framework
        guard let url = podBundle.url(forResource: "SWDownloadPlayButton",
                                      withExtension: "bundle") else {
                                        return nil
                                        
        }
        
        self.init(named: podAssetName,
                  in: Bundle(url: url),
                  compatibleWith: nil)
    }
}
