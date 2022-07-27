//
//  ViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class WelcomeViewController: UIViewController {

    let defaults = UserDefaults.standard
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var genderSelector: UISegmentedControl!
    @IBOutlet weak var selectedGender: UISegmentedControl!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // customize gender selection
        let genderFont = UIFont.boldSystemFont(ofSize: 24)
        genderSelector.setTitleTextAttributes([NSAttributedString.Key.font: genderFont], for: .normal)
        
        // customize button
        nextButton.layer.cornerRadius = 10.0
        
        // dismiss keyboard when user taps anywhere
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func ageChanged(_ sender: UIStepper) {
        ageLabel.text = String(Int(sender.value))
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        // prevent errors
        if (heightTextField.text != "") && (weightTextField.text != "") {
            // store metrics
            selectedGender.selectedSegmentIndex == 0 ? defaults.set("M", forKey: "Sex") :  defaults.set("F", forKey: "Sex")
            defaults.set(Int(ageLabel.text!), forKey: "Age")
            defaults.set(heightTextField.text, forKey: "Height")
            defaults.set(weightTextField.text, forKey: "Weight")
            
            performSegue(withIdentifier: "welcomeToGoals", sender: self)
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

