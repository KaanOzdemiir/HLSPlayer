//
//  Extensions.swift
//  HLSPlayer
//
//  Created by Kaan Ozdemir on 4.03.2021.
//

import Foundation
import UIKit

extension Double{
    var float: Float{
        return Float(self)
    }
}

extension UIViewController{
    var topViewContoller: UIViewController?{
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
