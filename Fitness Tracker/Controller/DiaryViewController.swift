//
//  DiaryViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit
import CoreData


class DiaryViewController : UIViewController {
    
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
}

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
        cell.textLabel?.text = currentFood.name
        let detailData = String(Int(currentFood.calories)) + " kcal, " + String(Int(currentFood.protein)) + " g"
        cell.detailTextLabel?.text = detailData
        
        cell.backgroundColor = UIColor(named: "veryDarkGray")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
         
        return cell
    }
}

