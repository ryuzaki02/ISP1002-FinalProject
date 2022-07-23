//
//  AddUpdateContactViewModel.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import Foundation

struct AddUpdateContactViewModel {
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
    
    enum DataType: String {
        case firstName = "First Name"
        case lastName = "Last Name"
        case mobile = "Mobile"
        case email = "Email"
    }
    
    private var contactListModel: ContactModel?
    private var profileViewState: ProfileViewState = .new
    
    init(profileViewState: ProfileViewState) {
        self.profileViewState = profileViewState
    }
    
    //TODO: - Check this method
    
//    func updateContactModelWith() -> ContactModel? {

//    }
    
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
    
    func getContactListModel() -> ContactModel? {
        return contactListModel
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
        return ContactModel(contactId: contactModel?.contactId ?? nil, firstName: firstName, lastName: lastName, phoneNumber: phone, email: email, profilePic: contactModel?.profilePic ?? "")
    }
}
