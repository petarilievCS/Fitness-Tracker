//
//  DashboardViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class DashboardViewController : UIViewController {
    
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var caloriesProgressView: UIProgressView!
    @IBOutlet weak var proteinProgressView: UIProgressView!
    @IBOutlet weak var creatineCheckbox: UIButton!
    @IBOutlet weak var vitaminsCheckbox: UIButton!
    
    let defaults = UserDefaults.standard
    
    var gender : String?
    var age : Int?
    var height : Int?
    var weight : Int?
    var activity : Int?
    var goal : Int?
    var calories : Int?
    var protein : Int?
    var caloriesConsumed = 0
    var proteinConsumed = 0
    
    var creatineTaken = false
    var vitaminsTaken = false
    
    override func viewWillAppear(_ animated: Bool) {
        
        weight = defaults.integer(forKey: "Weight")
        calories = defaults.integer(forKey: "Calories")
        protein = defaults.integer(forKey: "Protein")
        caloriesConsumed = defaults.integer(forKey: "caloriesConsumed")
        proteinConsumed = defaults.integer(forKey: "proteinConsumed")
        
        // set labels according to user metrics
        calorieLabel.text = "Calories: " + String(caloriesConsumed) + " / " + String(calories!) + " kcal"
        proteinLabel.text = "Protein: " + String(proteinConsumed) + " / " + String(protein!) + " g"
        weightLabel.text = "Current weight: " + String(weight!) + " kg"
        
        // set progress view
        caloriesProgressView.progress = Float(caloriesConsumed) / Float(calories!)
        proteinProgressView.progress = Float(proteinConsumed) / Float(protein!)
    }
    
    override func viewDidLoad() {
        let dailyCalories = Int(calculateCalorieIntake())
        let dailyProtein = Int(calculateProteinIntake())
        defaults.set(dailyCalories, forKey: "Calories")
        defaults.set(dailyProtein, forKey: "Protein")
        
        creatineTaken = defaults.bool(forKey: "creatine")
        vitaminsTaken = defaults.bool(forKey: "vitamins")
        setCheckboxes()
        
        // uncheck boxes every day
        let lastRefreshed = defaults.integer(forKey: "lastRefreshed")
        let date = Date()
        let calendar = Calendar.current
        let today = calendar.component(.day, from: date)
        
        if lastRefreshed != today {
            creatineCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
            vitaminsCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
        // make progress view bigger
        caloriesProgressView.transform = caloriesProgressView.transform.scaledBy(x: 1, y: 10)
        proteinProgressView.transform = proteinProgressView.transform.scaledBy(x: 1, y: 10)
        
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
        
        // adjust calorie intake for activity level
        if (activity == 0) {
            dailyCalories = userBMR * 1.2
        } else if (activity == 1) {
            dailyCalories = userBMR * 1.375
        } else if (activity == 2) {
            dailyCalories = userBMR * 1.55
        } else if (activity == 3) {
            dailyCalories = userBMR * 1.725
        }
        
        // adjust calorie intake for goal 
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
    
    //MARK: - Checkbox methods
    @IBAction func creatineChecked(_ sender: UIButton) {
        if creatineTaken {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            creatineTaken = false
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            creatineTaken = true
        }
        defaults.set(creatineTaken, forKey: "creatine")
    }
    
    @IBAction func vitaminsCheckbox(_ sender: UIButton) {
        if vitaminsTaken {
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            vitaminsTaken = false
        } else {
            sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            vitaminsTaken = true
        }
        defaults.set(vitaminsTaken, forKey: "vitamins")
    }
    
    func setCheckboxes() {
        
        if creatineTaken {
            creatineCheckbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            creatineCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
        if vitaminsTaken {
            vitaminsCheckbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            vitaminsCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
        }
    }
    
}
