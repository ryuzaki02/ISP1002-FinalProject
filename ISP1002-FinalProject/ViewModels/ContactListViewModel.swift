//
//  ContactListViewModel.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import Foundation
import UIKit

struct ContactListViewModel {
    var filteredArray: [ContactModel] = []
    var contactsDict: [String: [ContactModel]] = [:]
    var sectionHeaderArray: [String] = []
    
    // MARK: - Initialiser
    init() {
        getData()
    }
    
    // MARK: - Methods
    //
    // Mutating method to setup initial local variables
    // param: searchText: String could be empty or not
    // return: nothing
    //
    mutating func getData(searchText: String = "") {
        filteredArray = DatabaseManager.shared.fetchAllContacts() ?? []
        if !searchText.isEmpty {
            filteredArray = filteredArray.filter { $0.firstName?.contains(searchText) ?? false || $0.lastName?.contains(searchText) ?? false }
        }
        contactsDict = getContactDetails()
        sectionHeaderArray = getSectionHeaderArray()
    }
    
    // Method to get the contact details as key-value pair with the first letter as key
    // param: nothing
    // return: Dictionary of first letter as key and array of contact models
    //
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
    
    // Method to provides section headers
    // param: nothing
    // return: Array of section headers
    //
    private func getSectionHeaderArray() -> [String] {
        if contactsDict.keys.count > 0 {
            var keyArr = Array(contactsDict.keys).sorted()
            keyArr.append(keyArr.remove(at: 0))
            return keyArr.sorted()
        }
        return []
    }
    
    // Method to provide array of contact models for header index
    // param: index: Integer
    // return: array of contact models
    //
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
