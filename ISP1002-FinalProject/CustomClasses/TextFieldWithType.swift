//
//  TextFieldWithType.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation
import UIKit

// Class that inherits UITextfield for customisations
//
class TextFieldWithType: UITextField {
    
    // MARK: - Variables
    
    // Added extra variable to track type of particular text field
    var textFieldType: AddUpdateContactViewModel.DataType = .firstName
}

// Extension to TextFieldWithType Class to add extra methods
//
extension TextFieldWithType {
    
    // Method to set set keyboard type to different text fields
    // params: nothing
    // returns: nothing
    //
    func setupKeyboardType() {
        switch self.textFieldType {
        case .firstName, .lastName:
            self.keyboardType = .default
        case .email:
            self.keyboardType = .emailAddress
        case .mobile:
            self.keyboardType = .numberPad
        }
    }
}
