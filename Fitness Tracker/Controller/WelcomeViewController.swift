//
//  ViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let blue = "signatureBlue"
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // backgroundView.backgroundColor = UIColor(named: blue)
    
        // customize gender selection
        let genderFont = UIFont.boldSystemFont(ofSize: 24)
        genderSelector.setTitleTextAttributes([NSAttributedString.Key.font: genderFont], for: .normal)
        
        // customize button
        // nextButton.titleLabel?.font = font
        nextButton.layer.cornerRadius = 10.0
    }

}

