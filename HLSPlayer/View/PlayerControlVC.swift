//
//  PlayerControlView.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 3.03.2021.
//

import Foundation
import UIKit
import AVFoundation

class PlayerControlVC: UIViewController {
    // MARK: IBOutlets
    @IBOutlet var controls: [UIView]!
    @IBOutlet weak var closeButton: UIButton!{
        didSet{
            closeButton.setImage(#imageLiteral(resourceName: "ic_close").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    @IBOutlet weak var progressBar: UIProgressView!{
        didSet{
            progressBar.setProgress(0, animated: false)
        }
    }
    
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet{
            playPauseButton.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        switch viewModel.playerState {
        case .playing:
            viewModel.playerState = .paused
        case .paused:
            viewModel.playerState = .playing
        }

    }
    
    @IBOutlet weak var forwardButton: UIButton!{
        didSet{
            forwardButton.setImage(#imageLiteral(resourceName: "ic_forward").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    @IBOutlet weak var backwardButton: UIButton!{
        didSet{
            backwardButton.setImage(#imageLiteral(resourceName: "ic_backward").withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    // MARK: Variables
    var playerVC: PlayerVC?{
        get{
            return self.parent as? PlayerVC
        }
    }
    
    let viewModel = PlayerControlViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToMainView()
        subcribeTimerFiring()
        subscribeIsPlayingState()
        hideControlsAfterTwoSeconds()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.playerState = .playing
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.playerState = .paused
    }
    
    func hideControlsAfterTwoSeconds() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideControls()
        }
    }
    
    func addTapGestureToMainView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func mainViewTapped() {
        viewModel.isControlsShowing ? hideControls() : showControls()
    }
}

// MARK: Button Actions
extension PlayerControlVC{
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        playerVC?.dismiss(animated: true)
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        if let player = playerVC?.player, let duration  = player.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
            let newTime = playerCurrentTime + viewModel.seekDuration
            if newTime < CMTimeGetSeconds(duration)
            {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player.seek(to: selectedTime)
            }
        }
        viewModel.pauseResumeTimer()
    }
    
    @IBAction func backwardButtonTapped(_ sender: Any) {
        if let player = playerVC?.player, let duration  = player.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
            let newTime = playerCurrentTime - viewModel.seekDuration
            if newTime < CMTimeGetSeconds(duration)
            {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player.seek(to: selectedTime)
            }
        }
        viewModel.pauseResumeTimer()
    }
}

// MARK: Timer Firing Action
extension PlayerControlVC{
    func subcribeTimerFiring() {
        viewModel.rxTimerFireSubject.subscribe(onNext: { [weak self] () in
            guard
                let self = self,
                let totalSeconds = self.playerVC?.player?.currentItem?.asset.duration.seconds,
                let currentSecond = self.playerVC?.player?.currentItem?.currentTime().seconds else
            {
                return
            }
            #if DEBUG
            print("Current Second: \(currentSecond)")
            #endif
            let progress = currentSecond / totalSeconds
            self.progressBar.setProgress(progress.float, animated: true)
        }).disposed(by: viewModel.disposeBag)
    }
}

// MARK: Playing State Controls
extension PlayerControlVC{
    func subscribeIsPlayingState() {
        viewModel.rxIsPlayStateSubject.subscribe(onNext: { [weak self] (state) in
            switch state{
            case.playing:
                self?.playPauseButton.setImage(#imageLiteral(resourceName: "ic_pause").withRenderingMode(.alwaysTemplate), for: .normal)
                self?.playerVC?.player?.play()
                self?.viewModel.resumeTimer()
            case .paused:
                self?.playPauseButton.setImage(#imageLiteral(resourceName: "ic_play").withRenderingMode(.alwaysTemplate), for: .normal)
                self?.playerVC?.player?.pause()
                self?.viewModel.pauseTimer()
            }
        }).disposed(by: viewModel.disposeBag)
    }
    
}

// MARK: Controls Actions
extension PlayerControlVC{
    func showControls() {
        UIView.animate(withDuration: 0.3) {
            self.controls.forEach({$0.alpha = 1})
        }
        viewModel.isControlsShowing = true
    }
    func hideControls() {
        UIView.animate(withDuration: 0.3) {
            self.controls.forEach({$0.alpha = 0})
        }
        viewModel.isControlsShowing = false
    }
}
