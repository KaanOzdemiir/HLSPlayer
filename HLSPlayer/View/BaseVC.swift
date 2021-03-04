//
//  BaseVC.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 4.03.2021.
//

import Foundation
import UIKit
import Reachability

class BaseVC: UIViewController {
    
    private let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()
        subcribeReachable()
        subscribeUnreachable()
        reachabilityStartNotify()
    }
    
    func reachabilityStartNotify() {
        do {
            try reachability.startNotifier()
        } catch {
            #if DEBUG
            print("Unable to start notifier")
            #endif
        }
    }
    
    func subcribeReachable() {
        reachability.whenReachable = { [weak self] reachability in
            if reachability.connection == .wifi {
                self?.connectionReachable()
                #if DEBUG
                print("Reachable via WiFi")
                #endif
            } else {
                self?.connectionReachable()
                #if DEBUG
                print("Reachable via Cellular")
                #endif
            }
        }
    }
    
    func connectionReachable() {
        if let noConnectionVC = topViewContoller as? NoConnectionVC{
            noConnectionVC.dismiss(animated: true)
        }
    }
    
    func connectionUnreachable() {
        AppRouter.shared.presentNoConnectionVC(parentVC: self)
    }
    
    func subscribeUnreachable() {
        reachability.whenUnreachable = { [weak self] _ in
            self?.connectionUnreachable()
            #if DEBUG
            print("Not reachable")
            #endif
        }
    }
}
