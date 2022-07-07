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
        
        addSelectedFoodsButton.layer.cornerRadius = 10.0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFood()
        
        for food in foodArray {
            print(food.name)
            print(food.servingSize)
            print(food.calories)
            print(food.protein)
        }
        
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
        // self.tableView.reloadData()
    }
    
    // load foods from database
    func loadFood(with request: NSFetchRequest<Food> = Food.fetchRequest()) {
        do {
            foodArray = try context.fetch(request)
        } catch {
           print("Error while fetching data")
        }
        // tableView.reloadData()
    }
}

