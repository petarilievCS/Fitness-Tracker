//
//  SettingsViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var resetInformationButton: UIButton!
    @IBOutlet weak var resetMealsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        resetInformationButton.layer.cornerRadius = 10.0
        resetMealsButton.layer.cornerRadius = 10.0
    }
    
}
