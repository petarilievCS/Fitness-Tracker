//
//  DiaryViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit
import CoreData


class DiaryViewController : UIViewController {
    
    let defaults = UserDefaults.standard
    var selectedFoodArray = [Food]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addMealButton: UIButton!
    @IBOutlet weak var addWeightButton: UIButton!
    @IBOutlet weak var diaryTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        loadFood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryTableView.dataSource = self
        diaryTableView.delegate = self
        addMealButton.layer.cornerRadius = 10.0
        addWeightButton.layer.cornerRadius = 10.0
    }
    
    // save new food to database
    func saveFood() {
        do {
            try self.context.save()
        } catch {
            print("Error while saving context")
        }
        diaryTableView.reloadData()
    }
    
    // load foods from database
    func loadFood(with request: NSFetchRequest<Food> = Food.fetchRequest()) {
        
        var foodArray = [Food]()
        do {
            foodArray = try context.fetch(request)
        } catch {
           print("Error while fetching data")
        }
        
        selectedFoodArray.removeAll()
        
        // check if item is selected
        for food in foodArray {
            if food.selected {
                selectedFoodArray.append(food)
            }
        }
        diaryTableView.reloadData()
    }
    
    // change the user's weight when the button is pressed
    @IBAction func addWeightButtonPressed(_ sender: UIButton) {
        
        var weightTextField = UITextField()
        
        let alert = UIAlertController(title: "Add Your Weight", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Weight", style: .default) { action in
            let newWeight = Int(weightTextField.text!)
            self.defaults.set(newWeight, forKey: "Weight")
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter your weight..."
            weightTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

//MARK: - Table view data source methods
extension DiaryViewController : UITableViewDataSource {
    
    func countCheckedFoods() -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedFoodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath)
        let currentFood = selectedFoodArray[indexPath.row]
        
        // customize cell
        cell.textLabel?.text = "x" + String(currentFood.numServings) + " " + currentFood.name!
        
        let numServings = Int(currentFood.numServings)
        let detailData = String(Int(currentFood.calories) * numServings) + " kcal, " + String(Int(currentFood.protein) * numServings) + " g"
        cell.detailTextLabel?.text = detailData
        
        cell.backgroundColor = UIColor(named: "veryDarkGray")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
        
        return cell
    }
}

//MARK: - Table view delegate methods
extension DiaryViewController : UITableViewDelegate {
    
    // show an alert for changing the number of servings
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var numServingsTextField = UITextField()
        
        let alert = UIAlertController(title: "Change Number of Servings", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Change Servings", style: .default) { action in
            let newNumServings = Int(numServingsTextField.text!)
            let selectedFood = self.selectedFoodArray[indexPath.row]
            
            self.selectedFoodArray[indexPath.row].numServings = Int32(newNumServings!)
            self.saveFood()
            
            // adjust dashboard according to new change
            self.defaults.set(Int(selectedFood.numServings) * Int(selectedFood.calories), forKey: "caloriesConsumed")
            self.defaults.set(Int(selectedFood.numServings) * Int(selectedFood.protein), forKey: "proteinConsumed")
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter number of servings..."
            numServingsTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
