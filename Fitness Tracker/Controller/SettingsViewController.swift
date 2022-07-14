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
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        resetInformationButton.layer.cornerRadius = 10.0
        resetMealsButton.layer.cornerRadius = 10.0
    }
    
    
    // reset all meals
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        print("Pressed")
        
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
        
        print(foodArray.count)
        foodArray.removeAll()
        print(foodArray.count)
        
        do {
            try self.context.save()
        } catch {
            print(error)
        }
    }
    
}
