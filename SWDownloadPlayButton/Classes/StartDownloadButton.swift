//
//  StartDownloadButton.swift
//  SWPlayButton
//
//  Created by Jeroen Wolff on 03/01/2019.
//  Copyright © 2019 StudioWolff. All rights reserved.
//

import UIKit

class StartDownloadButton: UIControl {

    // MARK: Properties
    let imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let trackCircleView: CircleView = {
        let circleView = CircleView()
        circleView.lineWidth = 4
        circleView.isUserInteractionEnabled = false
        return circleView
    }()
    
    var lineWidth: CGFloat = 1 {
        didSet {
            trackCircleView.lineWidth = lineWidth
        }
    }
    
    /*
    var centerImage: UIImage = ImagesHelper.download_icon.withRenderingMode(.alwaysTemplate) {
        didSet {
            updateImage()
        }
    }
    */
    
    var centerImage: UIImage = UIImage() {
        didSet {
            updateImage()
        }
    }
    
    var nonhighlightedTrackCircleColor: UIColor = Color.Gray.medium {
        didSet {
            updateColors()
        }
    }
    
    var highlightedTrackCircleColor: UIColor = Color.Gray.light {
        didSet {
            updateColors()
        }
    }
    
    
    
    var nonhighlightedImageViewColor: UIColor = Color.Blue.medium {
        didSet {
            updateColors()
        }
    }
    
    var highlightedImageViewColor: UIColor = Color.Blue.light {
        didSet {
            updateColors()
        }
    }
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateColors()
        }
    }
    
    // MARK: Helper methods
    
    private func commonInit() {
        backgroundColor = .clear
        centerImage = (UIImage(podAssetName: "download_icon")?.withRenderingMode(.alwaysTemplate))!
        addSubview(trackCircleView)
        trackCircleView.pinToSuperview()
        
        addSubview(imageView)
        imageView.centerToSuperview()
       
        let heightConstraint = NSLayoutConstraint(item: imageView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: imageView,
                                              attribute: .width,
                                              multiplier: 1,
                                              constant: 0)
    
        let widthConstraint = NSLayoutConstraint(item: imageView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .width,
                                             multiplier: 0.7,
                                             constant: 0)
        
        NSLayoutConstraint.activate([heightConstraint, widthConstraint])
        
        updateColors()
        updateImage()
    }
    
    private func updateColors() {
        trackCircleView.circleColor = isHighlighted ? highlightedTrackCircleColor : nonhighlightedTrackCircleColor
        imageView.tintColor = isHighlighted ? highlightedImageViewColor : nonhighlightedImageViewColor
    }
    
    private func updateImage() {
        imageView.image = centerImage
    }
}
