//
//  ContactCell.swift
//  Test
//
//  Created by Parth Barot on 2/19/23.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    var contact: ContactModel! {
        didSet{
            nameLabel.text = contact.contactName
            print(contact.contactName ?? "");
            print(contact.mobileNo ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
