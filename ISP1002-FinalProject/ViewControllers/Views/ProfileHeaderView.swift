//
//  ProfileHeaderView.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import UIKit

protocol ContactChangedProtocol {
    func contactDidChange(contactModel: ContactModel, isNew: Bool)
}

class ProfileHeaderView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var stackViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageViewTopContraint: NSLayoutConstraint!
    
    private var initalHeaderHeight: CGFloat = 277.0
    private var contactModel: ContactModel?
    private var delegate: ContactChangedProtocol?
    
    override func awakeFromNib() {
        profileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    func initialiseHeaderWith(delegate: ContactChangedProtocol?) {
        self.delegate = delegate
    }
    
    func setupHeader(contactModel: ContactModel?, isEditable: Bool) {
        self.contactModel = contactModel
        if let contactModel = contactModel {
            nameLabel.text = "\(contactModel.firstName ?? "") \(contactModel.lastName ?? "")"
        }
        updateHeaderUI(isEditable: isEditable)
    }
    
    private func updateHeaderUI(isEditable: Bool){
        cameraButton.isHidden = !isEditable
        headerHeightConstraint.constant = isEditable ? initalHeaderHeight - 85 : initalHeaderHeight
        stackViewBottomContraint.constant = isEditable ? -100 : 12
        nameLabel.isHidden = isEditable
    }

}
