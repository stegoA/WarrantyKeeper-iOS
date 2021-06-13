//
//  ItemsTableViewCell.swift
//  warrantyKeeper
//
//  Created by Krishna Khandelwal on 12/21/19.
//  Copyright © 2019 anonymous. All rights reserved.
//

import UIKit

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var itemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
