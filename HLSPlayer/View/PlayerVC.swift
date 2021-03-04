//
//  PlayerVC.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 3.03.2021.
//

import Foundation
import AVKit

class PlayerVC: BaseVC {
    
    // MARK: IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    // MARK: Variables
    let viewModel = PlayerViewModel()
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer!
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePlayer()
        setupPlayerLayer()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
        self.playerLayer.frame.size = size
    }
}

// MARK: Player Layer Configurations
extension PlayerVC{
    func setupPlayerLayer() {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspect
        videoView.layer.addSublayer(playerLayer)
        videoView.bringSubviewToFront(containerView)
    }
}

// MARK: Player Configurations
extension PlayerVC{
    func configurePlayer() {
        guard let url = viewModel.hlsVideoUrl else {
            print("Invalid URL!")
            return
        }
        
        let videoAsset = AVAsset(url: url)
        
        for characteristic in videoAsset.availableMediaCharacteristicsWithMediaSelectionOptions {
            print("\(characteristic)")
            
            // Retrieve the AVMediaSelectionGroup for the specified characteristic.
            if let group = videoAsset.mediaSelectionGroup(forMediaCharacteristic: characteristic) {
                // Print its options.
                for option in group.options {
                    print("  Option: \(option.displayName) - \(option.availableMetadataFormats)")
                }
            }
        }
        let playerItem = AVPlayerItem(asset: videoAsset)
        
        if let group = videoAsset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible) {
            // Set the locale identifier to the value of languageID to select the current language
            let locale = Locale(identifier: "en-EN")
            // Create an option group to hold the options in the group that match the locale
            let options =
                AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
            // Assign the first option from options to the variable option
            if let option = options.first {
                // Select the option for the selected locale
                playerItem.select(option, in: group)
            }
        }
        
        self.player = AVPlayer(playerItem: playerItem)
        activateSound()
    }
    
    func activateSound() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch let error {
            print("(activateSound) Error: \(error.localizedDescription)")
        }
    }
}
