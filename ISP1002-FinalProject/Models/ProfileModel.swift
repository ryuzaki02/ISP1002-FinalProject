//
//  ProfileModel.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation

struct ProfileModel {
    var dataType: AddUpdateContactViewModel.DataType
    var value: String?
    var isEditable = true
    
    // Mutating method to updated value of the field
    // param: value: String
    // return: nothing
    //
    mutating func updateValue(value: String?){
        self.value = value
    }
}
