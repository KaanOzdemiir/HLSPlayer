//
//  NoConnectionVC.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 4.03.2021.
//

import Foundation
import UIKit
import Lottie

class NoConnectionVC: UIViewController {
    
    
    @IBOutlet weak var animationView: AnimationView!{
        didSet{
            animationView.loopMode = .loop
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.play()
    }
}
