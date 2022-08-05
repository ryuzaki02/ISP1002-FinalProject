//
//  AddUpdateContactViewController.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 08/07/22.
//

import UIKit

class AddUpdateContactViewController: UIViewController {
    
    enum ProfileViewState {
        case new
        case edit
        case showOnly
    }
    
    enum RightBarButtonState{
        case done
        case edit
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: ProfileHeaderView!
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Initial Setup
    private func setupNavBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)], for: .normal)
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)], for: .normal)
    }
    
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
    
    //MARK:- Update data received from text fields
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
    
    //MARK:- Change behaviour controller methods
    private func updateForNewState() {
        dataArray = profileViewModel?.getDataForTableView()
        headerView.setupHeader(contactModel: nil, isEditable: true)
        setRightBarButtonItem(buttonState: .done)
        doneBarButtonItem?.isEnabled = false
    }
    
    private func updateForEditState(contactModel: ContactModel) {
        self.contactModel = contactModel
        dataArray = profileViewModel?.getDataForTableView()
        headerView.setupHeader(contactModel: contactModel, isEditable: true)
        setRightBarButtonItem(buttonState: .done)
        doneBarButtonItem?.isEnabled = true
    }
    
    private func updateForShowOnlyState(contactModel: ContactModel) {
        self.contactModel = contactModel
        dataArray = profileViewModel?.getDataForTableView()
        headerView.setupHeader(contactModel: contactModel, isEditable: false)
        setRightBarButtonItem(buttonState: .edit)
    }
    
    private func updateViewData(contactModel: ContactModel) {
        headerView.setupHeader(contactModel: contactModel, isEditable: false)
        dataArray = profileViewModel?.getDataForTableView()
        self.contactModel = contactModel
    }
    
    //MARK:- Data injection
    func setupData(profileViewModel: AddUpdateContactViewModel?) {
        self.profileViewModel = profileViewModel
    }
    
    private func addKeyboardTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    private func getUpdatedContactModelFromProfileDataArray() -> ContactModel? {
        guard let profileViewModel = profileViewModel,
              let dataArray = dataArray else {
            return nil
        }
        
        return profileViewModel.getContactModelFromDataArray(dataArray: dataArray, contactModel: contactModel)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK:- Button Actions
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
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Keyboard Methods
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = UIEdgeInsets.zero
    }
    
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

extension AddUpdateContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        doneBarButtonItem?.isEnabled = textField.text?.count == 1 && string.isEmpty && !hasOtherFieldsData ? false : true
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let tf = textField as? TextFieldWithType{
            hasOtherFieldsData = validator.checkIfOtherModelHasValue(dataArray: dataArray, exceptType: tf.textFieldType)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let tf = textField as? TextFieldWithType{
            updateDataArray(type: tf.textFieldType, value: textField.text)
        }
    }
}

extension AddUpdateContactViewController: ProfileHeaderViewProtocol {
    func contactDidChange(contactModel: ContactModel, isNew: Bool) {
        self.dismiss(animated: true, completion: nil)
        setRightBarButtonItem(buttonState: .edit)
        updateViewData(contactModel: contactModel)
        headerViewDelegate?.contactDidChange(contactModel: contactModel, isNew: isNew)
    }
}

extension AddUpdateContactViewController: ProfileHeaderCameraPickerDelegate {
    func openImagePicker() {
        self.imagePicker.present(from: view)
    }
    
    func imageDidSelect(image: UIImage) {
        profileViewModel?.profileImage = image
    }
}
