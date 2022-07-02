//
//  DiaryViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class DiaryViewController : UIViewController {
    
    @IBOutlet weak var addMealButton: UIButton!
    @IBOutlet weak var addWeightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMealButton.layer.cornerRadius = 10.0
        addWeightButton.layer.cornerRadius = 10.0
    }
}
