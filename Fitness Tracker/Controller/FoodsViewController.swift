//
//  FoodsViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit
import CoreData

class FoodsViewController : UIViewController {
    
    var foodArray = [Food]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var addSelectedFoodsButton: UIButton!
    @IBOutlet weak var foodTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFood()
        foodTableView.dataSource = self
        foodTableView.delegate = self
        addSelectedFoodsButton.layer.cornerRadius = 10.0
        
        foodTableView.register(UINib(nibName: "FoodCell", bundle: nil), forCellReuseIdentifier: "FoodCell")
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCell", for: indexPath) as! FoodCell
        let currentFood = foodArray[indexPath.row]
        
        // customize cell
        cell.nameLabel.text = currentFood.name
        cell.servingLabel.text = currentFood.servingSize
        
        // set selected
        if (currentFood.selected) {
            cell.checkmarkIcon.isHidden = false
        } else {
            cell.checkmarkIcon.isHidden = true
        }
        
        // create macro text
        var macroText = String(Int(currentFood.calories)) + " kcal"
        macroText += " - "
        macroText += String(Int(currentFood.protein)) + " g"
        cell.macroLabel.text = macroText
        
        return cell
    }
}

extension FoodsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodArray[indexPath.row].selected = !(foodArray[indexPath.row].selected)
        foodTableView.reloadData()
    }
    
}
