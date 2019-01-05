//
//  ProgressButton.swift
//  SWPlayButton
//
//  Created by Jeroen Wolff on 03/01/2019.
//  Copyright © 2019 StudioWolff. All rights reserved.
//

import UIKit

class ProgressButton: UIControl {

    // MARK: Properties
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let trackCircleView: CircleView = {
        let circleView = CircleView()
        circleView.lineWidth = 3
        circleView.isUserInteractionEnabled = false
        return circleView
    }()
    
    let progressCircleView: ProgressCircleView = {
        let view = ProgressCircleView()
        view.lineWidth = 6
        view.isUserInteractionEnabled = false
        return view
    }()
    
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
    
    var nonhighlightedProgressCircleColor: UIColor = Color.Blue.medium {
        didSet {
            updateColors()
        }
    }
    
    var highlightedProgressCircleColor: UIColor = Color.Blue.light {
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
    
    var progress: CGFloat = 0 {
        didSet {
            if progress < 0 {
                progress = 0
            } else if progress > 1 {
                progress = 1
            }
            progressCircleView.progress = progress
        }
    }
    
    override var isHighlighted: Bool {
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
    
    // MARK: Helper methods
    
    private func commonInit() {
        centerImage = (UIImage(podAssetName: "stop_icon")?.withRenderingMode(.alwaysTemplate))!
        
        backgroundColor = .clear
        addSubview(trackCircleView)
        trackCircleView.pinToSuperview()
        
        addSubview(progressCircleView)
        progressCircleView.pinToSuperview()
        
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
        progressCircleView.circleColor = isHighlighted ? highlightedProgressCircleColor : nonhighlightedProgressCircleColor
        imageView.tintColor = isHighlighted ? highlightedImageViewColor : nonhighlightedImageViewColor
    }
    
    private func updateImage() {
        imageView.image = centerImage
    }

}
