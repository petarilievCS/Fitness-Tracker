//
//  FoodsViewController.swift
//  Fitness Tracker
//
//  Created by Petar Iliev on 1.7.22.
//

import UIKit

class FoodsViewController : UIViewController {
    
    @IBOutlet weak var addSelectedFoodsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSelectedFoodsButton.layer.cornerRadius = 10.0
    }
    
    // saves food item to database 
    @IBAction func addButtonPressed(_ sender: UIButton) {
    }
}
