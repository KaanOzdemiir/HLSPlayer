//
//  ViewController.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 3.03.2021.
//

import UIKit
import AVFoundation

class HomeVC: BaseVC {

    // MARK: Variables
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: Button Actions
extension HomeVC{
    @IBAction func streamButtonTapped(_ sender: Any) {
        AppRouter.shared.presentVideoPlayer(parentVC: self)
    }
}

