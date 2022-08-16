//
//  AddUpdateContactViewModel.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import Foundation
import UIKit

struct AddUpdateContactViewModel {
    
    // Enum to manage state of Add/View/Update controller
    enum ProfileViewState {
        case new
        case edit(contactModel: ContactModel)
        case showOnly(contactModel: ContactModel)
        
        mutating func updateCaseFor(contactModel: ContactModel){
            switch self {
            case .new:
                self = .new
            case .edit( _):
                self = .edit(contactModel: contactModel)
            case .showOnly( _):
                self = .showOnly(contactModel: contactModel)
            }
        }
    }
    
    // Enum to manage the type of text fields present
    enum DataType: String {
        case firstName = "First Name"
        case lastName = "Last Name"
        case mobile = "Mobile"
        case email = "Email"
    }
    
    // MARK: - Variables
    //
    private var profileViewState: ProfileViewState = .new
    var profileImage: UIImage?
    
    // MARK: - Initialisers
    //
    init(profileViewState: ProfileViewState) {
        self.profileViewState = profileViewState
    }
    
    // Mutating method to update the state of contact model
    // param: contactModel: ContactModel
    // return: nothing
    //
    mutating func updateState(contactModel: ContactModel) {
        profileViewState.updateCaseFor(contactModel: contactModel)
    }
    
    // Method to get array of profile models for desired controller state
    // param: nothing
    // return: array of profile models
    //
    func getDataForTableView() -> [ProfileModel] {
        switch profileViewState {
        case .new:
            return [ProfileModel.init(dataType: .firstName, value: "", isEditable: true),
                    ProfileModel.init(dataType: .lastName, value: "", isEditable: true),
                    ProfileModel.init(dataType: .mobile, value: "", isEditable: true),
                    ProfileModel.init(dataType: .email, value: "", isEditable: true)]
        case .edit(let model):
            return [ProfileModel.init(dataType: .firstName, value: model.firstName ?? "", isEditable: true),
                    ProfileModel.init(dataType: .lastName, value: model.lastName ?? "", isEditable: true),
                    ProfileModel.init(dataType: .mobile, value: model.phoneNumber ?? "", isEditable: true),
                    ProfileModel.init(dataType: .email, value: model.email ?? "", isEditable: true)]
        case .showOnly(let model):
            return [ProfileModel.init(dataType: .mobile, value: model.phoneNumber ?? "Not Available", isEditable: false),
                    ProfileModel.init(dataType: .email, value: model.email ?? "Not Available", isEditable: false)]
        }
    }
  
    func getProfileViewState() -> ProfileViewState {
        return profileViewState
    }
    
    //MARK: - Check for done button state
    func isDoneButtonActive() -> Bool {
        var flag = false
        for model in getDataForTableView(){
            if let value = model.value,
                !value.isEmpty{
                flag = true
                break
            }
        }
        return flag
    }
    
    //MARK: - Get contact model from ProfileModel Array
    func getContactModelFromDataArray(dataArray: [ProfileModel], contactModel: ContactModel?) -> ContactModel {
        var firstName = ""
        var lastName = ""
        var email = ""
        var phone = ""
        for model in dataArray{
            switch model.dataType{
            case .firstName:
                firstName = model.value ?? ""
            case .lastName:
                lastName = model.value ?? ""
            case .email:
                email = model.value ?? ""
            case .mobile:
                phone = model.value ?? ""
            }
        }
        let contactId = contactModel?.contactId ?? UUID().uuidString
        let key = "image\(contactId)\(phone)"
        let urlString = saveImageToLocalPath(key: key)
        let profilePicKey: String? = urlString == nil ? nil : key
        return ContactModel(contactId: contactId, firstName: firstName, lastName: lastName, phoneNumber: phone, email: email, profilePic: profilePicKey ?? contactModel?.profilePic ?? "")
    }
    
    func saveImageToLocalPath(key: String) -> String? {
        if let profileImage = profileImage,
           let pngRepresentation = profileImage.pngData(),
           let filePath = ContactFileManager.shared.filePath(key: key) {
            do  {
                try pngRepresentation.write(to: filePath,
                                            options: .atomic)
                return filePath.absoluteString
            } catch let err {
                print("Saving file resulted in error: ", err)
            }
        }
        return nil
    }
}
