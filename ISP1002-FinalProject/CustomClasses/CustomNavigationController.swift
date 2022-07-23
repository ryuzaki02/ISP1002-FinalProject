//
//  CustomNavigationController.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation
import UIKit

class CustomNavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
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

extension CustomNavigationController : UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension UINavigationController {
    func hideNavigationBar() {
        self.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.setNavigationBarHidden(false, animated: true)
    }
    
    func initNavigationBar() {
        self.setBackgroundColor(toColor: UIColor.white)
        self.setTitleColor(toColor: UIColor.white)
        self.navigationBar.tintColor = UIColor.customGreen
    }
    
    func resetNavigationBar() {
        self.setBackgroundColor(toColor: UIColor.white)
        self.setTitleColor(toColor: UIColor.black)
        self.navigationBar.tintColor = UIColor.black
    }
    
    func setBackgroundColor(toColor: UIColor) {
        self.navigationBar.barTintColor = toColor
    }
    
    func setTitleColor(toColor: UIColor = UIColor.navigationTitleGrayColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:toColor]
    }
    
    func setTitle(toTitle: String, font: UIFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold), titleColor: UIColor = UIColor.navigationTitleGrayColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.foregroundColor:titleColor]
        self.navigationBar.topItem?.title = toTitle
    }
}
