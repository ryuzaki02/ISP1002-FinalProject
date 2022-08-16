//
//  ContactModel.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import Foundation

struct ContactModel {
    var contactId: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
    var email: String?
    var profilePic: String?
    var firstNameChar: String? {
        if let char = firstName?.first, char.isLetter{
            return String(char).uppercased()
        }
        return nil
    }
    
    // Mutating method to update the path of image
    // param: path: String
    // return: nothing
    //
    mutating func updateProfilePic(path: String) {
        self.profilePic = path
    }
}
