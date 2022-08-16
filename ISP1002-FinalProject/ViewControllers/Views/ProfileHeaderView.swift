//
//  ProfileHeaderView.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import UIKit

// Protocol to handler contact change from header view
//
protocol ProfileHeaderViewProtocol {
    func contactDidChange(contactModel: ContactModel, isNew: Bool)
}

// Protocol to handle camera picker methods
//
protocol ProfileHeaderCameraPickerDelegate {
    func openImagePicker()
    
    func imageDidSelect(image: UIImage)
}

// Class to manage Header view of Profile separately
//
class ProfileHeaderView: UIView {

    // MARK: - Outlets
    //
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageViewTopContraint: NSLayoutConstraint!
    
    // MARK: - Variables
    //
    private var initalHeaderHeight: CGFloat = 277.0
    private var contactModel: ContactModel?
    private var delegate: ProfileHeaderViewProtocol?
    private var pickerDelegate: ProfileHeaderCameraPickerDelegate?
    
    // MARK: - Initialisers
    //
    override func awakeFromNib() {
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    // Method to initialise the header with data
    // param: delegate: ProfileHeaderViewProtocol (Optional), pickerDeleagte: ProfileHeaderCameraPickerDelegate (Optional)
    // return: nothing
    //
    func initialiseHeaderWith(delegate: ProfileHeaderViewProtocol?, pickerDelegate: ProfileHeaderCameraPickerDelegate?) {
        self.delegate = delegate
        self.pickerDelegate = pickerDelegate
    }
    
    // Method to setup header basic data
    // param: contactMode: ContactModel (Optional), isEditable: Booleann
    // return: nothing
    //
    func setupHeader(contactModel: ContactModel?, isEditable: Bool) {
        self.contactModel = contactModel
        if let contactModel = contactModel {
            nameLabel.text = "\(contactModel.firstName ?? "") \(contactModel.lastName ?? "")"
            if let profileUrl = contactModel.profilePic,
               let fileData = ContactFileManager.shared.retrieveImage(key: profileUrl),
               let image = UIImage(data: fileData) {
                profileImageView.image = image
            }
        }
        updateHeaderUI(isEditable: isEditable)
    }
    
    // Method to update the UI part of header
    // param: isEditable: Boolean
    // return: nothing
    //
    private func updateHeaderUI(isEditable: Bool){
        cameraButton.isHidden = !isEditable
        headerHeightConstraint.constant = isEditable ? initalHeaderHeight - 85 : initalHeaderHeight
        stackViewBottomContraint.constant = isEditable ? -100 : 12
        nameLabel.isHidden = isEditable
    }
    
    //MARK: - Button actions
    //
    @IBAction func cameraButtonAction(_ sender: UIButton!) {
        pickerDelegate?.openImagePicker()
    }
}

extension ProfileHeaderView: ImagePickerDelegate {
    // Method to handle image selection from parent controller
    // param: image: UIImage (Optional)
    // return: nothing
    //
    func didSelect(image: UIImage?) {
        profileImageView.image = image
        if let image = image {
            pickerDelegate?.imageDidSelect(image: image)
        }
    }
}
