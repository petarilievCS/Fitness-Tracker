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
    @IBOutlet weak var checkmarkIcon: UIImageView!
    
    override func awakeFromNib() {
        checkmarkIcon.isHidden = true
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
