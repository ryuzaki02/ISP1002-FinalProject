//
//  Color+Extension.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation
import UIKit

// Extension on UIColor to add some custom colors
//
extension UIColor {
    // App's primary color
    class var customGreen: UIColor {
        return UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    }
    
    // Separator color
    class var cellSeparatorGray: UIColor {
        return UIColor(displayP3Red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
    }
    
    // Navigation title color
    class var navigationTitleGrayColor: UIColor {
        return UIColor(displayP3Red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
}
