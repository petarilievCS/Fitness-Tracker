//
//  DashboardViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class DashboardViewController : UIViewController {
    
    let defaults = UserDefaults.standard
    
    var gender : String?
    var age : Int?
    var height : Int?
    var weight : Int?
    var activity : Int?
    var goal : Int?
    
    override func viewDidLoad() {
        print(calculateCalorieIntake())
        print(Int(calculateProteinIntake()))
        
        navigationController?.navigationBar.isHidden = true
        super.viewDidLoad()
    }
    
    // use Muffin-St Jeor formula to calculate BMR (basal metabolic rate)
    func calculateBMR() -> Double {
        
        // set all varibales
        gender = defaults.string(forKey: "Sex")!
        age = defaults.integer(forKey: "Age")
        height = defaults.integer(forKey: "Height")
        weight = defaults.integer(forKey: "Weight")
        var BMR : Double
        
        // calculate BMR
        if (gender == "M") {
            BMR = 10.0 * Double(weight!) + 6.25 * Double(height!) - 5.0 * Double(age!) + 5.0
        } else {
            BMR = 10.0 * Double(weight!) + 6.25 * Double(height!) - 5.0 * Double(age!) - 161.0
        }
        
        return BMR
    }
    
    // calculates calorie intake based on goal and activity level
    func calculateCalorieIntake() -> Double {
        
        let userBMR = calculateBMR()
        var dailyCalories = 0.0
        activity = defaults.integer(forKey: "Activity")
        goal = defaults.integer(forKey: "Goal")
        
        if (activity == 0) {
            dailyCalories = userBMR * 1.2
        } else if (activity == 1) {
            dailyCalories = userBMR * 1.375
        } else if (activity == 2) {
            dailyCalories = userBMR * 1.55
        } else if (activity == 3) {
            dailyCalories = userBMR * 1.725
        }
        
        if (goal == 0) {
            dailyCalories *= 0.8
        } else if (goal == 2) {
            dailyCalories *= 1.1
        }
        
        return dailyCalories
        
    }
    
    // calculate protien intake
    func calculateProteinIntake() -> Double {
        let weight = defaults.integer(forKey: "Weight")
        return Double(weight) * 0.8 * 2.2
    }
    
}
