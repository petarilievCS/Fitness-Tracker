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
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        loadFood()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.dataSource = self
        foodTableView.delegate = self
        foodTableView.allowsSelection = true
        searchBar.delegate = self
        addSelectedFoodsButton.layer.cornerRadius = 10.0
        
        // refresh data if needed
        let lastRefreshed = defaults.integer(forKey: "lastRefreshed")
        let date = Date()
        let calendar = Calendar.current
        let today = calendar.component(.day, from: date)
        
        if lastRefreshed != today {
            uncheckItems()
            resetCalorieIntake()
        }
        
        if defaults.integer(forKey: "caloriesConsumed") == 0 {
            loadFood()
            uncheckItems()
            defaults.set(0, forKey: "caloriesConsumed")
            defaults.set(0, forKey: "proteinConsumed")
            foodTableView.reloadData()
        }
        
    }

    // remove all selected items everyday
    private func uncheckItems() {
        for food in foodArray {
            if food.selected {
                food.selected = false
            }
        }
        saveFood()
    }

    //MARK: - Adding Food Methods
    
    // scan barcode and add food to table
    @IBAction func barcodeButtonPressed(_ sender: UIButton) {
        
    }
    
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
            
            if calorieTextField.text! != "" {
                newFood.calories = Double(calorieTextField.text!)!
            } else {
                newFood.calories = 0.0
            }
            
            if proteinTextField.text! != "" {
                newFood.protein = Double(proteinTextField.text!)!
            } else {
                newFood.protein = 0.0
            }
            
            newFood.selected = false
            newFood.numServings = 1
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
            alertTextField.keyboardType = .numberPad
            calorieTextField = alertTextField
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter protein per serving..."
            alertTextField.keyboardType = .numberPad
            proteinTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Helper methods
    func resetCalorieIntake() {
        
        var calorieIntake = 0
        var proteinIntake = 0
        
        for food in foodArray {
            if food.selected {
                calorieIntake += Int(food.numServings) * Int(food.calories)
                proteinIntake += Int(food.numServings) * Int(food.protein)
            }
        }
        
        defaults.set(calorieIntake, forKey: "caloriesConsumed")
        defaults.set(proteinIntake, forKey: "proteinConsumed")
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
    func loadFood(with request: NSFetchRequest<Food> = Food.fetchRequest(), predicate : NSPredicate? = nil) {
        request.predicate = predicate
        do {
            foodArray = try context.fetch(request)
        } catch {
           print("Error while fetching data")
        }
        foodTableView.reloadData()
    }
}

//MARK: - Table view data source methods
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
        
        // cell.backgroundColor = UIColor(named: "yellow")
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

//MARK: - Table view delegate methods
extension FoodsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        let caloriesConsumed = defaults.integer(forKey: "caloriesConsumed")
        let proteinConsumed = defaults.integer(forKey: "proteinConsumed")
        let selectedFood = foodArray[indexPath.row]
        
        if foodArray[indexPath.row].selected {
            defaults.set(caloriesConsumed - Int(selectedFood.calories) * Int(selectedFood.numServings), forKey: "caloriesConsumed")
            defaults.set(proteinConsumed - Int(selectedFood.protein) * Int(selectedFood.numServings), forKey: "proteinConsumed")
        } else {
            defaults.set(caloriesConsumed + Int(selectedFood.calories) * Int(selectedFood.numServings), forKey: "caloriesConsumed")
            defaults.set(proteinConsumed + Int(selectedFood.protein) * Int(selectedFood.numServings), forKey: "proteinConsumed")
        }
        
        foodArray[indexPath.row].numServings = 1
        foodArray[indexPath.row].selected = !(foodArray[indexPath.row].selected)
        foodTableView.reloadData()
    }
    
}

//MARK: - Swipe cell delegate methods
extension FoodsViewController : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // delete action
        if (orientation == .right) {
            let removeAction = SwipeAction(style: .destructive, title: "Remove") { action, indexPath in
                self.context.delete(self.foodArray[indexPath.row])
                self.foodArray.remove(at: indexPath.row)
                
                do {
                    try self.context.save()
                } catch {
                    print("Error whil saving context")
                }
                self.resetCalorieIntake()
            }
            
            let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPAth in
                
                var titleTextField = UITextField()
                var calorieTextField = UITextField()
                var proteinTextField = UITextField()
                var servingTextField = UITextField()
                let currentFood = self.foodArray[indexPath.row]
                
                let alert = UIAlertController(title: "Edit Food", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Edit", style: .default) { action in
                    
                    if titleTextField.text! != "" {
                        currentFood.name = titleTextField.text!
                    }
                    
                    if servingTextField.text! != "" {
                        currentFood.servingSize = servingTextField.text!
                    }
                    
                    if (calorieTextField.text! != "") {
                        currentFood.calories = Double(calorieTextField.text!)!
                    }
                    
                    if (proteinTextField.text! != "") {
                        currentFood.protein = Double(proteinTextField.text!)!
                    }
                    
                    // currentFood.selected = false
                    self.foodArray.replaceSubrange(indexPath.row...indexPath.row, with: [currentFood])
                    self.saveFood()
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = currentFood.name
                    titleTextField = alertTextField
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = currentFood.servingSize
                    servingTextField = alertTextField
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = String(Int(currentFood.calories))
                    alertTextField.keyboardType = .numberPad
                    calorieTextField = alertTextField
                }
                
                alert.addTextField { alertTextField in
                    alertTextField.placeholder = String(Int(currentFood.protein))
                    alertTextField.keyboardType = .numberPad
                    proteinTextField = alertTextField
                }
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
            
            return [removeAction, editAction]
        }
        
        return nil
    }
    
    // enable deleting cell by swiping all the way to the left
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}

//MARK: - SearchBar delegates
extension FoodsViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // create request
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        // sort data
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // perform request/query
        loadFood(with: request, predicate: predicate)
    }
    
    // reset list to original when "x" is pressed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text!.count == 0) {
            loadFood()
        }
    }
    
    // put down keyboard when user is done searching
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
