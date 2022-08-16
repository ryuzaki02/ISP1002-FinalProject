//
//  CustomNavigationController.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation
import UIKit

// Class customises navigation controller
// Inherits UINavigationController
//
class CustomNavigationController: UINavigationController {

    // MARK: - Variables
    
    // Sets and provide status bar's preferred style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - View Controller life cycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
        setBackgroundColor(toColor: .white)
        navigationBar.isTranslucent = true
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold), NSAttributedString.Key.foregroundColor: UIColor.navigationTitleGrayColor]
        // Do any additional setup after loading the view.
    }
}

// Extension to CustomNavigationContnroller for Gesture
extension CustomNavigationController : UIGestureRecognizerDelegate {
    
    // Method to track gesutre beign requests
    // params: gestureRecongnizer: UIGestureRecognzer
    // returns: boolean
    //
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

// Extension to UINavigationController to handle show, hide and init bar methods
extension UINavigationController {
    
    // Method to hide navigation bar
    // params: nothing
    // returns: nothing
    //
    func hideNavigationBar() {
        self.setNavigationBarHidden(true, animated: true)
    }
    
    // Method to show navigation bar
    // params: nothing
    // returns: nothing
    //
    func showNavigationBar() {
        self.setNavigationBarHidden(false, animated: true)
    }
    
    // Method to initialise navigation bar
    // params: nothing
    // returns: nothing
    //
    func initNavigationBar() {
        self.setBackgroundColor(toColor: UIColor.white)
        self.setTitleColor(toColor: UIColor.white)
        self.navigationBar.tintColor = UIColor.customGreen
    }
    
    // Method to reset navigation bar
    // params: nothing
    // returns: nothing
    //
    func resetNavigationBar() {
        self.setBackgroundColor(toColor: UIColor.white)
        self.setTitleColor(toColor: UIColor.black)
        self.navigationBar.tintColor = UIColor.black
    }
    
    // Method to set background color of navigation bar
    // params: toColor: UIColor
    // returns: nothing
    //
    func setBackgroundColor(toColor: UIColor) {
        self.navigationBar.barTintColor = toColor
    }
    
    // Method to set title color of navigation bar
    // params: toColor: UIColor
    // returns: nothing
    //
    func setTitleColor(toColor: UIColor = UIColor.navigationTitleGrayColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:toColor]
    }
    
    // Method to set title style of navigation bar
    // params: toTitle: String, font: UIFont
    // returns: nothing
    //
    func setTitle(toTitle: String, font: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold), titleColor: UIColor = UIColor.navigationTitleGrayColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:titleColor]
        self.navigationBar.topItem?.title = toTitle
    }
}
