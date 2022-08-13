//
//  Validator.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation

class Validator{
    
    func checkIfOtherModelHasValue(dataArray: [ProfileModel]?, exceptType: AddUpdateContactViewModel.DataType) -> Bool{
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
