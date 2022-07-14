//
//  FoodsViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit
import CoreData
import SwipeCellKit

class FoodsViewController : UIViewController {
    
    var foodArray = [Food]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var addSelectedFoodsButton: UIButton!
    @IBOutlet weak var foodTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        loadFood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.dataSource = self
        foodTableView.delegate = self
        addSelectedFoodsButton.layer.cornerRadius = 10.0
    }
    
    //MARK: - Adding Food Methods
    
    // saves food item to database
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        var titleTextField = UITextField()
        var calorieTextField = UITextField()
        var proteinTextField = UITextField()
        var servingTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Food", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Food", style: .default) { action in
            let newFood = Food(context: self.context)
            newFood.name = titleTextField.text!
            newFood.servingSize = servingTextField.text!
            newFood.calories = Double(calorieTextField.text!)!
            newFood.protein = Double(proteinTextField.text!)!
            newFood.selected = false
            self.foodArray.append(newFood)
            self.saveFood()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter food title..."
            titleTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter serving size..."
            servingTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter calories per serving..."
            calorieTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter protein per serving..."
            proteinTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Data Manipulation Methods
    
    // save new food to database
    func saveFood() {
        do {
            try self.context.save()
        } catch {
            print("Error while saving context")
        }
        self.foodTableView.reloadData()
    }
    
    // load foods from database
    func loadFood(with request: NSFetchRequest<Food> = Food.fetchRequest()) {
        do {
            foodArray = try context.fetch(request)
        } catch {
           print("Error while fetching data")
        }
        foodTableView.reloadData()
    }
}

extension FoodsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        let currentFood = foodArray[indexPath.row]
        
        // customize cell
        cell.textLabel?.text = currentFood.name
        let detailData = String(Int(currentFood.calories)) + " kcal, " + String(Int(currentFood.protein)) + " g"
        cell.detailTextLabel?.text = detailData
        
        cell.backgroundColor = UIColor(named: "veryDarkGray")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
        
        // add checkmark when selected
        if (currentFood.selected) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
         
        return cell
    }
}

extension FoodsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let caloriesConsumed = defaults.integer(forKey: "caloriesConsumed")
        let proteinConsumed = defaults.integer(forKey: "proteinConsumed")
        
        if foodArray[indexPath.row].selected {
            defaults.set(caloriesConsumed - Int(foodArray[indexPath.row].calories), forKey: "caloriesConsumed")
            defaults.set(proteinConsumed - Int(foodArray[indexPath.row].protein), forKey: "proteinConsumed")
        } else {
            defaults.set(caloriesConsumed + Int(foodArray[indexPath.row].calories), forKey: "caloriesConsumed")
            defaults.set(proteinConsumed + Int(foodArray[indexPath.row].protein), forKey: "proteinConsumed")
        }
        
        foodArray[indexPath.row].selected = !(foodArray[indexPath.row].selected)
        foodTableView.reloadData()
    }
    
}

extension FoodsViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        let removeAction = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in
            self.context.delete(self.foodArray[indexPath.row])
            self.foodArray.remove(at: indexPath.row)
            
            do {
                try self.context.save()
            } catch {
                print("Error whil saving context")
            }
            
        }
        
        return [removeAction]
    }
    
    // enable deleting cell by swiping all the way to the left
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
