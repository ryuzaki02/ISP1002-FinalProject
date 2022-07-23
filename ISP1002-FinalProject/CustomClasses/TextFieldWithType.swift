//
//  TextFieldWithType.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation
import UIKit

class TextFieldWithType: UITextField {
    var textFieldType: AddUpdateContactViewModel.DataType = .firstName
}

extension TextFieldWithType{
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
