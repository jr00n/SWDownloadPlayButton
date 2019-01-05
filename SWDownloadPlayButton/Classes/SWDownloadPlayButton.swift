//
//  SWPlayButton.swift
//  SWPlayButton
//
//  Created by Jeroen Wolff on 03/01/2019.
//  Copyright © 2019 StudioWolff. All rights reserved.
//

import UIKit
import os.log

public protocol SWDownloadPlayButtonDelegate: class {
    func didTapPlayButton(withState state: SWDownloadPlayButton.State)
}

public class SWDownloadPlayButton: UIView {
    
    public enum State : String {
        case startDownload
        case pending
        case downloading
        case downloaded
        case playing
        case paused
    }
    
    // MARK: Private properties
    let startDownloadButton: StartDownloadButton = {
        let button = StartDownloadButton()
        button.addTarget(self, action: #selector(currentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let pendingCircleView: CircleView = {
        let view = CircleView()
        view.endAngleRadians = view.startAngleRadians + 12 * .pi / 7
        return view
    }()
    
    let downloadingButton: ProgressButton = {
        let button = ProgressButton()
        button.addTarget(self, action: #selector(currentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let playControlButton: PlayControlButton = {
        let button = PlayControlButton()
        button.addTarget(self, action: #selector(currentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Animation
    let animationDispatchGroup = DispatchGroup()
    let animationQueue = DispatchQueue(label: "com.amerhukic.animation")
    
    // MARK: Public properties
    public var progress: CGFloat = 0 {
        didSet {
            downloadingButton.progress = progress
        }
    }
    
    /// State transformation
    
    // default state is .startDownload
    public var state: State = .startDownload {
        didSet {
            animationQueue.async { [currentState = state] in
                self.animationDispatchGroup.enter()
                
                var delay: TimeInterval = 0
                if oldValue == .downloading && currentState == .downloaded && self.downloadingButton.progress == 1 {
                    delay = self.downloadingButton.progressCircleView.progressAnimationDuration
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    self.animateTransition(from: oldValue, to: currentState)
                }
                self.animationDispatchGroup.wait()
            }
        }
    }
    
    /// Pending view customisation properties
    public var pendingCircleColor: UIColor = Color.Gray.dark {
        didSet {
            pendingCircleView.circleColor = pendingCircleColor
        }
    }
    public var pendingCircleLineWidth: CGFloat = 4 {
        didSet {
            pendingCircleView.lineWidth = pendingCircleLineWidth
            startDownloadButton.lineWidth = pendingCircleLineWidth
        }
    }

    
    /// Downloading button customisation properties
    
    public var downloadingButtonNonhighlightedTrackCircleColor: UIColor = Color.Gray.medium {
        didSet {
            downloadingButton.nonhighlightedTrackCircleColor = downloadingButtonNonhighlightedTrackCircleColor
        }
    }
    
    public var downloadingButtonHighlightedTrackCircleColor: UIColor = Color.Gray.light {
        didSet {
            downloadingButton.highlightedTrackCircleColor = downloadingButtonHighlightedTrackCircleColor
        }
    }
    
    public var downloadingButtonNonhighlightedProgressCircleColor: UIColor = Color.Blue.medium {
        didSet {
            downloadingButton.nonhighlightedProgressCircleColor = downloadingButtonNonhighlightedProgressCircleColor
        }
    }
    
    public var downloadingButtonHighlightedProgressCircleColor: UIColor = Color.Blue.light {
        didSet {
            downloadingButton.highlightedProgressCircleColor = downloadingButtonHighlightedProgressCircleColor
        }
    }
    
    public var downloadingButtonNonhighlightedImageViewColor: UIColor = Color.Blue.medium {
        didSet {
            downloadingButton.nonhighlightedImageViewColor = downloadingButtonNonhighlightedImageViewColor
        }
    }
    
    public var downloadingButtonHighlightedImageViewColor: UIColor = Color.Blue.light {
        didSet {
            downloadingButton.highlightedImageViewColor = downloadingButtonHighlightedImageViewColor
        }
    }
    
    public var playControlButtonNonhighlightedTrackCircleColor: UIColor = Color.Blue.medium {
        didSet {
            playControlButton.nonhighlightedTrackCircleColor = playControlButtonNonhighlightedTrackCircleColor
        }
    }
    
    public var playControlButtonHighlightedTrackCircleColor: UIColor = Color.Blue.light {
        didSet {
            playControlButton.highlightedTrackCircleColor = playControlButtonHighlightedTrackCircleColor
        }
    }
    
    public var playControlButtonNonhighlightedImageViewColor: UIColor = Color.Blue.medium {
        didSet {
            playControlButton.nonhighlightedImageViewColor = playControlButtonNonhighlightedImageViewColor
        }
    }
    
    public var playControlButtonHighlightedImageViewColor: UIColor = Color.Blue.light {
        didSet {
            playControlButton.highlightedImageViewColor = playControlButtonHighlightedImageViewColor
        }
    }
    
    
    public var transitionAnimationDuration: TimeInterval = 0.1
    
    /// Callbacks
    public weak var delegate: SWDownloadPlayButtonDelegate?
    public var didTapPlayButtonAction: ((_ currentState: State) -> Void)?

    
    // MARK: Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(startDownloadButton)
        setUpStartDownloadButtonProperties()
        setupConstraints(for: startDownloadButton)
        //setUpStartDownloadButtonConstraints()
        
        addSubview(pendingCircleView)
        setUpPendingCircleViewProperties()
        //setUpPendingButtonConstraints()
        setupConstraints(for: pendingCircleView)
        
        addSubview(downloadingButton)
        setUpDownloadingButtonProperties()
        //setUpDownloadingButtonConstraints()
        setupConstraints(for: downloadingButton)
        
        addSubview(playControlButton)
        setUpPlayControlButtonProperties()
        setupConstraints(for: playControlButton)
        
    }
    
    // MARK: Style customisation
    
    private func setUpPendingCircleViewProperties() {
        // bij het aanmaken van de CircleView de alpha op 0 zetten
        // zodat deze view er wel is, maar (nog) niet getoond wordt
        pendingCircleView.circleColor = pendingCircleColor
        pendingCircleView.lineWidth = pendingCircleLineWidth
        pendingCircleView.alpha = 0
    }
    
    private func setUpStartDownloadButtonProperties() {
        // hier het plaatje zetten?
    }
    
    private func setUpDownloadingButtonProperties() {
        downloadingButton.highlightedTrackCircleColor = downloadingButtonHighlightedTrackCircleColor
        downloadingButton.nonhighlightedTrackCircleColor = downloadingButtonNonhighlightedTrackCircleColor
        downloadingButton.highlightedProgressCircleColor = downloadingButtonHighlightedProgressCircleColor
        downloadingButton.nonhighlightedProgressCircleColor = downloadingButtonNonhighlightedProgressCircleColor
        downloadingButton.highlightedImageViewColor = downloadingButtonHighlightedImageViewColor
        downloadingButton.nonhighlightedImageViewColor = downloadingButtonNonhighlightedImageViewColor
        downloadingButton.alpha = 0
    }
    
    private func setUpPlayControlButtonProperties() {
        playControlButton.highlightedTrackCircleColor = playControlButtonHighlightedTrackCircleColor
        playControlButton.nonhighlightedTrackCircleColor = playControlButtonNonhighlightedTrackCircleColor
        playControlButton.highlightedImageViewColor = playControlButtonHighlightedImageViewColor
        playControlButton.nonhighlightedImageViewColor = playControlButtonNonhighlightedImageViewColor
        playControlButton.alpha = 0
    }
    
    
    // MARK: Constraints setup
    
    private func setupConstraints(for view: UIView) {
        view.centerToSuperview()
        let heightConstraint = NSLayoutConstraint(item: view,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .height,
                                                  multiplier: 1,
                                                  constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: view,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: self,
                                                 attribute: .width,
                                                 multiplier: 1,
                                                 constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint])
    }

    
    // MARK: Method overrides
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //let width = min(frame.width, frame.height)
        //pendingViewWidthConstraint.constant = width
        //downloadingButtonWidthConstraint.constant = width
        
        //if startDownloadButtonTitleWidth == 0 {
        //    startDownloadButtonTitleWidth = startDownloadButton.titleWidth
        // }
        
        //if downloadedButtonTitleWidth == 0 {
        //    downloadedButtonTitleWidth = downloadedButton.titleWidth
        //}
    }
    
    // MARK: Action methods
    
    @objc private func currentButtonTapped() {
        delegate?.didTapPlayButton(withState: state)
        didTapPlayButtonAction?(state)
    }
}
