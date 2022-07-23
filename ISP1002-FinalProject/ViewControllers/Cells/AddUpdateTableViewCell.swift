//
//  AddUpdateTableViewCell.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import UIKit

class AddUpdateTableViewCell: UITableViewCell {

    @IBOutlet weak var dataTextField: TextFieldWithType!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = UIColor.navigationTitleGrayColor
        dataTextField.textColor = .black
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupCell(profileModel: ProfileModel, textFieldDelegate: UITextFieldDelegate?) {
        dataTextField.textFieldType = profileModel.dataType
        dataTextField.setupKeyboardType()
        dataTextField.delegate = textFieldDelegate
        dataTextField.isUserInteractionEnabled = profileModel.isEditable
        dataTextField.text = profileModel.value
        nameLabel.text = profileModel.dataType.rawValue
    }

}
