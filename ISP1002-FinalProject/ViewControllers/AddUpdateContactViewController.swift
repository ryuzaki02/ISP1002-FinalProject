//
//  AddUpdateContactViewController.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import UIKit

class AddUpdateContactViewController: UIViewController {
    
    // MARK: - Enums
    //
    enum ProfileViewState {
        case new
        case edit
        case showOnly
    }
    
    // Bar button enums
    enum RightBarButtonState{
        case done
        case edit
    }
    
    // MARK: - Outlets
    //
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: ProfileHeaderView!
    
    // MARK: - Variables
    //
    private var cellHeight: CGFloat = 56.0
    private var cellIdentifier = "AddUpdateTableViewCell"
    private var profileViewModel: AddUpdateContactViewModel?
    private var contactModel: ContactModel?
    private var doneBarButtonItem: UIBarButtonItem?
    var headerViewDelegate: ProfileHeaderViewProtocol?
    private var dataArray: [ProfileModel]?
    private var hasOtherFieldsData = true
    private var validator = Validator()
    private var imagePicker: ImagePicker!

    // MARK: - View controller Lifecycle methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        headerView.initialiseHeaderWith(delegate: headerViewDelegate, pickerDelegate: self)
        updateData()
        addKeyboardTapGesture()
        self.imagePicker = ImagePicker(presentationController: self, delegate: headerView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        // Do any additional setup after loading the view.
    }
    
    // Deinit method to remove observers
    //
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Initial Setup
    //
    // Method to setup navigation bar
    // params: nothing
    // return: nothing
    //
    private func setupNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)], for: .normal)
    }
    
    // Method to setup bar button items
    // params: buttonState: RightBarButtonState
    // return: nothing
    //
    func setRightBarButtonItem(buttonState: RightBarButtonState) {
        navigationItem.rightBarButtonItems?.removeAll()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        switch buttonState {
        case .done:
            doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
            navigationItem.rightBarButtonItem = doneBarButtonItem
        case .edit:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        }
    }
    
    // Update model states for controller
    // params: nothing
    // return: nothing
    //
    private func updateData() {
        switch profileViewModel?.getProfileViewState() ?? .new {
        case .new:
            updateForNewState()
        case .edit(let contactModel):
            updateForEditState(contactModel: contactModel)
        case .showOnly(let contactModel):
            updateForShowOnlyState(contactModel: contactModel)
        }
    }
    
    // Method to update the array for profile models
    // params: type: AddUpdateContactViewModel.DataType, value: String (Optional)
    // return: nothing
    //
    private func updateDataArray(type: AddUpdateContactViewModel.DataType, value: String?) {
        guard var dataArray = dataArray else {
            return
        }
        for (index, model) in dataArray.enumerated(){
            if model.dataType == type{
                dataArray[index].updateValue(value: value)
                break
            }
        }
        self.dataArray = dataArray
    }
    
    // Method to update the new state for controller
    // params: nothing
    // return: nothing
    //
    private func updateForNewState() {
        dataArray = profileViewModel?.getDataForTableView()
        headerView.setupHeader(contactModel: nil, isEditable: true)
        setRightBarButtonItem(buttonState: .done)
        doneBarButtonItem?.isEnabled = false
    }
    
    // Method to update the edit state for controller
    // params: contactModel: ContactModel
    // return: nothing
    //
    private func updateForEditState(contactModel: ContactModel) {
        self.contactModel = contactModel
        dataArray = profileViewModel?.getDataForTableView()
        headerView.setupHeader(contactModel: contactModel, isEditable: true)
        setRightBarButtonItem(buttonState: .done)
        doneBarButtonItem?.isEnabled = true
    }
    
    // Method to update the show only state for controller
    // params: contactModel: ContactModel
    // return: nothing
    //
    private func updateForShowOnlyState(contactModel: ContactModel) {
        self.contactModel = contactModel
        dataArray = profileViewModel?.getDataForTableView()
        headerView.setupHeader(contactModel: contactModel, isEditable: false)
        setRightBarButtonItem(buttonState: .edit)
    }
    
    // Method to update the update view data state for controller
    // params: contactModel: ContactModel
    // return: nothing
    //
    private func updateViewData(contactModel: ContactModel) {
        headerView.setupHeader(contactModel: contactModel, isEditable: false)
        dataArray = profileViewModel?.getDataForTableView()
        self.contactModel = contactModel
    }
    
    // Method to setup controller with view model
    // params: profileViewModel: AddUpdateContactViewModel (Optional)
    // return: nothing
    //
    func setupData(profileViewModel: AddUpdateContactViewModel?) {
        self.profileViewModel = profileViewModel
    }
    
    // Method to add keyboard gesture
    // params: nothing
    // return: nothing
    //
    private func addKeyboardTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // Method to update contact model from profile data array
    // params: nothing
    // return: ContactModel (Optional)
    //
    private func getUpdatedContactModelFromProfileDataArray() -> ContactModel? {
        guard let profileViewModel = profileViewModel,
              let dataArray = dataArray else {
            return nil
        }
        
        return profileViewModel.getContactModelFromDataArray(dataArray: dataArray, contactModel: contactModel)
    }
    
    // Method to handle dismiss keyboard
    // params: nothing
    // return: nothing
    //
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Button Actions
    //
    // Method to handle edit button action
    // params: nothing
    // return: nothing
    //
    @objc func editButtonTapped() {
        guard let contactModel = contactModel else {
            return
        }
        let newProfileViewModel = AddUpdateContactViewModel(profileViewState: .edit(contactModel: contactModel))
        let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUpdateContactViewController") as! AddUpdateContactViewController
        profileVC.setupData(profileViewModel: newProfileViewModel)
        profileVC.headerViewDelegate = self
        let navControl = CustomNavigationController.init(rootViewController: profileVC)
        present(navControl, animated: true, completion: nil)
    }
    
    // Method to handle done button action
    // params: nothing
    // return: nothing
    //
    @objc func doneButtonTapped() {
        view.endEditing(true)
        guard let contactModel = getUpdatedContactModelFromProfileDataArray()
        else {
            return
        }
        
        view.isUserInteractionEnabled = false
        
        switch profileViewModel?.getProfileViewState() ?? .new {
        case .new:
            saveOrUpdateContact(state: .new, contactModel: contactModel)
        case .edit(_):
            saveOrUpdateContact(state: .edit, contactModel: contactModel)
        default:
            #if DEBUG
            print("")
            #endif
        }
    }
    
    // Method to handle cancel button action
    // params: nothing
    // return: nothing
    //
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    // Method to handle keyboard show delegate method
    // params: notfication: Notification
    // return: nothing
    //
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    // Method to handle keyboard hide delegate method
    // params: notfication: Notification
    // return: nothing
    //
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = UIEdgeInsets.zero
    }
    
    // Method to handle save or update contact according to state and contact model
    // params: state: ProfileState, contactModel: ContactModel
    // return: nothing
    //
    func saveOrUpdateContact(state: ProfileViewState, contactModel: ContactModel) {
        switch state {
        case .new:
            dismiss(animated: true, completion: nil)
            headerViewDelegate?.contactDidChange(contactModel: contactModel, isNew: true)
            profileViewModel?.updateState(contactModel: contactModel)
        case .edit:
            dismiss(animated: true, completion: nil)
            headerViewDelegate?.contactDidChange(contactModel: contactModel, isNew: false)
            profileViewModel?.updateState(contactModel: contactModel)
        default:
            #if DEBUG
            print("")
            #endif
        }
    }
}

extension AddUpdateContactViewController: UITableViewDataSource {
    // Data source method to handle number of rows in section
    // params: tableView: UITableView, section: Integer
    // return: Integer
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    // Data source method to handle cell for row at index path
    // params: tableView: UITableView, indexPath: Indexpath
    // return: UITableViewCell
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AddUpdateTableViewCell
        cell.dataTextField.tag = indexPath.row
        if let model = dataArray?[indexPath.row]{
            cell.setupCell(profileModel: model, textFieldDelegate: self)
        }
        return cell
    }
}

extension AddUpdateContactViewController: UITableViewDelegate {
    // Data source method to handle height for row at index path
    // params: tableView: UITableView, indexPath: Indexpath
    // return: CGFloat
    //
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension AddUpdateContactViewController: UITextFieldDelegate {
    // Delegate method to handle text field text change
    // params: textField: UITextField, range: NSRange, string: String
    // return: Boolean
    //
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        doneBarButtonItem?.isEnabled = (textField.text?.count == 1 && string.isEmpty) || !hasOtherFieldsData ? false : true
        return true
    }
    
    // Delegate method to handle text field text begin editing
    // params: textField: UITextField
    // return: nothing
    //
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let tf = textField as? TextFieldWithType{
            hasOtherFieldsData = validator.checkIfOtherModelHasValue(dataArray: dataArray, exceptType: tf.textFieldType)
        }
    }
    
    // Delegate method to handle text field text end editing
    // params: textField: UITextField
    // return: nothing
    //
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let tf = textField as? TextFieldWithType{
            updateDataArray(type: tf.textFieldType, value: textField.text)
        }
    }
}

extension AddUpdateContactViewController: ProfileHeaderViewProtocol {
    // Method to handle contact did change listener
    // params: contactModel: ContactModel
    // return: isNew: Boolean
    //
    func contactDidChange(contactModel: ContactModel, isNew: Bool) {
        self.dismiss(animated: true, completion: nil)
        setRightBarButtonItem(buttonState: .edit)
        updateViewData(contactModel: contactModel)
        headerViewDelegate?.contactDidChange(contactModel: contactModel, isNew: isNew)
    }
}

extension AddUpdateContactViewController: ProfileHeaderCameraPickerDelegate {
    // Method to handle image picker listener
    // params: nothing
    // return: nothing
    //
    func openImagePicker() {
        self.imagePicker.present(from: view)
    }
    
    // Method to handle image selection
    // params: image: UIImage
    // return: nothing
    //
    func imageDidSelect(image: UIImage) {
        profileViewModel?.profileImage = image
    }
}
