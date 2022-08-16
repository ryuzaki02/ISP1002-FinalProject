//
//  AddUpdateTableViewCell.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 22/07/22.
//

import UIKit

class AddUpdateTableViewCell: UITableViewCell {

    // MARK: - Outlets
    //
    @IBOutlet weak var dataTextField: TextFieldWithType!
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Initialisers
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Extra method not used
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: - Setup methods
    //
    // Method to setup UI of cell and basic data
    // param: profileModel: ProfileModel, textFieldDelegate: UITextFieldDelegate (Optional)
    // return: nothing
    //
    func setupCell(profileModel: ProfileModel, textFieldDelegate: UITextFieldDelegate?) {
        dataTextField.textFieldType = profileModel.dataType
        dataTextField.setupKeyboardType()
        dataTextField.delegate = textFieldDelegate
        dataTextField.isUserInteractionEnabled = profileModel.isEditable
        dataTextField.text = profileModel.value
        nameLabel.text = profileModel.dataType.rawValue
    }

}
