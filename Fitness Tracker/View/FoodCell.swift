//
//  FoodCell.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 7.7.22.
//

import UIKit

class FoodCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var macroLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
