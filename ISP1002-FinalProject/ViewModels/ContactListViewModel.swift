//
//  ContactListViewModel.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import Foundation
import UIKit

struct ContactListViewModel {
    private var contactsArray: [ContactModel] = []
    var filteredArray: [ContactModel] = []
    var contactsDict: [String: [ContactModel]] = [:]
    var sectionHeaderArray: [String] = []
    
    init() {
        getData()
    }
    
     mutating func getData() {
        filteredArray = DatabaseManager.shared.fetchAllContacts() ?? []
        contactsDict = getContactDetails()
        sectionHeaderArray = getSectionHeaderArray()
    }
    
    private func getContactDetails() -> [String: [ContactModel]] {
        var dataDict: [String:[ContactModel]] = [:]
        if !filteredArray.isEmpty {
            dataDict["#"] = []
        }
        
        for model in filteredArray {
            if let firstChar = model.firstNameChar {
                if dataDict[firstChar] == nil {
                    dataDict[firstChar] = [model]
                } else {
                    dataDict[firstChar]?.append(model)
                }
            } else {
                dataDict["#"]?.append(model)
            }
        }
        
        if let items = dataDict["#"],
           items.isEmpty {
            dataDict.removeValue(forKey: "#")
        }
        
        return dataDict
    }
    
    private func getSectionHeaderArray() -> [String] {
        if contactsDict.keys.count > 0 {
            var keyArr = Array(contactsDict.keys).sorted()
            keyArr.append(keyArr.remove(at: 0))
            return keyArr.sorted()
        }
        return []
    }
    
    func getContactModelArrayForIndex(index: Int) -> [ContactModel]? {
        if index > sectionHeaderArray.count {
            return nil
        }
        let key = sectionHeaderArray[index]
        if let modelArr = contactsDict[key] {
            return modelArr
        }
        return nil
    }
}
