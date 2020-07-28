//
//  Utility.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 27/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

struct Utility {
    static func showApploader() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(UIColor.gray)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.show()
    }
    
    static func hideApploader() {
        SVProgressHUD.dismiss()
    }
    
    static func showLoaderWithText(text: String)
    {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setRingRadius(30.0)
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.setForegroundColor(UIColor.black)
        
        if text.count > 0 {
            
            SVProgressHUD.show(withStatus: text)
        } else {
            
            SVProgressHUD.show()
        }
    }
    
    
}


