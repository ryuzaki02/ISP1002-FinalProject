//
//  ContactListTableViewCell.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 15/07/22.
//

import UIKit

class ContactListTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!

    // MARK: - Initialiser
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

}
