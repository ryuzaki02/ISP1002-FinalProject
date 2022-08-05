//
//  ProfileHeaderView.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import UIKit

protocol ProfileHeaderViewProtocol {
    func contactDidChange(contactModel: ContactModel, isNew: Bool)
}

protocol ProfileHeaderCameraPickerDelegate {
    func openImagePicker()
    
    func imageDidSelect(image: UIImage)
}

class ProfileHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageViewTopContraint: NSLayoutConstraint!
    
    private var initalHeaderHeight: CGFloat = 277.0
    private var contactModel: ContactModel?
    private var delegate: ProfileHeaderViewProtocol?
    private var pickerDelegate: ProfileHeaderCameraPickerDelegate?
    
    override func awakeFromNib() {
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func initialiseHeaderWith(delegate: ProfileHeaderViewProtocol?, pickerDelegate: ProfileHeaderCameraPickerDelegate?) {
        self.delegate = delegate
        self.pickerDelegate = pickerDelegate
    }
    
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
    
    private func updateHeaderUI(isEditable: Bool){
        cameraButton.isHidden = !isEditable
        headerHeightConstraint.constant = isEditable ? initalHeaderHeight - 85 : initalHeaderHeight
        stackViewBottomContraint.constant = isEditable ? -100 : 12
        nameLabel.isHidden = isEditable
    }
    
    //MARK: - Button actions
    @IBAction func cameraButtonAction(_ sender: UIButton!) {
        pickerDelegate?.openImagePicker()
    }
}

extension ProfileHeaderView: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        profileImageView.image = image
        if let image = image {
            pickerDelegate?.imageDidSelect(image: image)
        }
    }
}
