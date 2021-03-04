//
//  PlayerControlViewModel.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 4.03.2021.
//

import Foundation
import RxSwift

class PlayerControlViewModel {
    // MARK: Variables
    var seekDuration: Float64 = 10
    var timer: Timer?
    var isControlsShowing = true
    
    let disposeBag = DisposeBag()
    
    let rxTimerFireSubject = PublishSubject<Void>()
    let rxIsPlayStateSubject = PublishSubject<PlayerState>()
    
    var playerState: PlayerState = .playing{
        didSet{
            rxIsPlayStateSubject.onNext(playerState)
        }
    }
    
    func pauseResumeTimer() {
        switch playerState {
        case .playing:
            resumeTimer()
        case .paused:
            pauseTimer()
        }
    }
    
    func resumeTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        timer?.invalidate()
    }
    
    @objc func fireTimer() {
        rxTimerFireSubject.onNext(())
    }
}
