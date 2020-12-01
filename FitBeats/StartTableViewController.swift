//
//  StartViewController.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/27/20.
//

import Foundation
import UIKit
import CoreData

class StartTableViewController: UITableViewController {
    
    var exercises = [Exercise]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return exercises.count
            }
            return 0
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveExerciseCell", for: indexPath) as! ActiveExerciseCell
            
            // Configure the cell...
            let exercise = exercises[indexPath.row]
            cell.currentExercise = exercise

            return cell
        }

}
