//
//  AppRouter.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 3.03.2021.
//

import Foundation
import UIKit

class AppRouter {
    static let shared = AppRouter()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    func presentVideoPlayer(parentVC: UIViewController) {
        guard let playerVC = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as? PlayerVC else { return }
        playerVC.modalTransitionStyle = .flipHorizontal
        playerVC.modalPresentationStyle = .fullScreen
        parentVC.present(playerVC, animated: true)
    }
    
    func presentNoConnectionVC(parentVC: UIViewController) {
        guard let playerVC = storyboard.instantiateViewController(withIdentifier: "NoConnectionVC") as? NoConnectionVC else { return }
        playerVC.modalTransitionStyle = .crossDissolve
        playerVC.modalPresentationStyle = .fullScreen
        parentVC.present(playerVC, animated: true)
    }
}
