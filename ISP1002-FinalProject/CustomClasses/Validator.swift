//
//  Validator.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation

// Validator class to check if field is empty or not on basis of type and data
//
class Validator {
    
    // Method to check wether the view with multiple fields has all filled or not
    // params: dataArray: Array of ProfileModels, exceptType: Type of Field
    // returns: boolean whether all the text fields are filled or not
    //
    func checkIfOtherModelHasValue(dataArray: [ProfileModel]?, exceptType: AddUpdateContactViewModel.DataType) -> Bool {
        var hasOtherFieldsData = true
        if let dataArray = dataArray {
            for model in dataArray{
                if exceptType != model.dataType{                    
                    if model.value == nil || model.value?.isEmpty == true {
                        hasOtherFieldsData = false
                        break
                    }
                }
            }
        }
        return hasOtherFieldsData
    }
}
