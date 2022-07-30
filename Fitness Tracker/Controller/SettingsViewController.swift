//
//  SettingsViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit
import CoreData

class SettingsViewController : UIViewController {
    
    @IBOutlet weak var resetInformationButton: UIButton!
    @IBOutlet weak var resetMealsButton: UIButton!
    @IBOutlet weak var setCaloriesButton: UIButton!
    @IBOutlet weak var setProteinButton: UIButton!
    @IBOutlet weak var setStepsButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        resetInformationButton.layer.cornerRadius = 10.0
        resetMealsButton.layer.cornerRadius = 10.0
        setStepsButton.layer.cornerRadius = 10.0
        setProteinButton.layer.cornerRadius = 10.0
        setCaloriesButton.layer.cornerRadius = 10.0
    }
    
    // reset all meals
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        let foodRequest : NSFetchRequest<Food> =  Food.fetchRequest()
        var foodArray = [Food]()
        
        do {
            try foodArray = self.context.fetch(foodRequest)
        } catch {
            print(error)
        }
        
        for i in Range(0...(foodArray.count - 1)) {
            self.context.delete(foodArray[i])
        }
        
        foodArray.removeAll()
        defaults.set(0, forKey: "caloriesConsumed")
        defaults.set(0, forKey: "proteinConsumed")
        
        do {
            try self.context.save()
        } catch {
            print(error)
        }
    }
    
    // set custom calories
    @IBAction func setCaloriesPressed(_ sender: UIButton) {
        var calorieTextField = UITextField()

        let alert = UIAlertController(title: "Set Custom Calories", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Set", style: .default) { action in
            if calorieTextField.text != "" {
                self.defaults.set(Int(calorieTextField.text!), forKey: "calories")
                self.defaults.set(true, forKey: "customCalories")
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.keyboardType = .numberPad
            calorieTextField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setProteinPressed(_ sender: UIButton) {
        var proteinTextField = UITextField()

        let alert = UIAlertController(title: "Set Custom Protein", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Set", style: .default) { action in
            if proteinTextField.text != "" {
                self.defaults.set(Int(proteinTextField.text!), forKey: "protein")
                self.defaults.set(true, forKey: "customProtein")
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.keyboardType = .numberPad
            proteinTextField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setStepsPressed(_ sender: UIButton) {
        var stepsTextField = UITextField()

        let alert = UIAlertController(title: "Set Steps", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Set", style: .default) { action in
            if stepsTextField.text != "" {
                self.defaults.set(Int(stepsTextField.text!), forKey: "steps")
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.keyboardType = .numberPad
            stepsTextField = alertTextField
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
