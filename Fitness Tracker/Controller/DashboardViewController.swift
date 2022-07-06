//
//  DashboardViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class DashboardViewController : UIViewController {
    
    let defaults = UserDefaults.standard
    
    var gender : String
    var age : Int
    var height : Int
    var weight : Int
    var activity : Int
    var goal : Int
    
    override func viewDidLoad() {
        
        // set all varibales
        gender = defaults.string(forKey: "Sex")!
        age = defaults.integer(forKey: "Age")
        height = defaults.integer(forKey: "Height")
        weight = defaults.integer(forKey: "Weight")
        activity = defaults.integer(forKey: "Activity")
        goal = defaults.integer(forKey: "Goal")
        
        calculateBMR()
        
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
    }
    
    // use Muffin-St Jeor formula to calculate BMR (basal metabolic rate)
    func calculateBMR() -> Float {
        var BMR : Float
        if (gender == "M") {
            BMR = 10.0 * weight + 6.25 * height - 5.0 * age + 5.0
        } else {
            BMR = 10.0 * weight + 6.25 * height - 5.0 * age - 161.0
        }
        return BMR
    }
    
}
