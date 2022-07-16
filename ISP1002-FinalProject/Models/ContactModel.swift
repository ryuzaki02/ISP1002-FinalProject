//
//  ContactModel.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import Foundation

struct ContactModel {
    var firstName: String?
    var lastName: String?
    var firstNameChar: String? {
        if let char = firstName?.first, char.isLetter{
            return String(char).uppercased()
        }
        return nil
    }
}
