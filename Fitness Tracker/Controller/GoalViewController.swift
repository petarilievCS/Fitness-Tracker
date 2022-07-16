//
//  GoalViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class GoalViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    let activities = ["Never", "1-3 days/week", "3-5 days/week", "6-7 days/week"]
    let goals = ["Cut", "Maintain", "Bulk"]
    
    @IBOutlet weak var activityPicker: UIPickerView!
    @IBOutlet weak var goalPicker: UIPickerView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        
        activityPicker.dataSource = self
        activityPicker.delegate = self
        goalPicker.dataSource = self
        goalPicker.delegate = self
        
        nextButton.layer.cornerRadius = 10.0
        
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        // set activity and goal
        defaults.set(activityPicker.selectedRow(inComponent: 0), forKey: "Activity")
        defaults.set(goalPicker.selectedRow(inComponent: 0), forKey: "Goal")
        defaults.set(0, forKey: "caloriesConsumed")
        defaults.set(0, forKey: "proteinConsumed")
        defaults.set(true, forKey: "infoEntered")
    }
}

extension GoalViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == activityPicker ? 4 : 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == activityPicker ? activities[row] : goals[row]
    }
}
