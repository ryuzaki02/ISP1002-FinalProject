//
//  Validator.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import Foundation

class Validator{
    
    func checkIfOtherModelHasValue(dataArray: [ProfileModel]?, exceptType: AddUpdateContactViewModel.DataType) -> Bool{
        var hasOtherFieldsData = false
        if let dataArray = dataArray {
            for model in dataArray{
                if exceptType != model.dataType{
                    if let value = model.value,
                        !value.isEmpty{
                        hasOtherFieldsData = true
                        break
                    }
                }
            }
        }
        return hasOtherFieldsData
    }
    
}
