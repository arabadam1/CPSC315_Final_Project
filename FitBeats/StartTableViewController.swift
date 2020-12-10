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
    
    var currentWorkout : Workout? = nil
    var exercises = [Exercise]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getExercises()
    }
    
    func getExercises() {
        if let workout = currentWorkout {
            loadExercises()
            self.navigationItem.title = workout.name
        }
        else {
            let alertController = UIAlertController(title: "No Workout Selected", message: "Please choose a workout before starting!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }
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
        cell.update(with: exercise)
        if indexPath.row == 0 {
            cell.startTimer()
        }

        return cell
    }
    
    func loadExercises(withPredicate predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        let workoutPredicate = NSPredicate(format: "parentWorkout.name MATCHES %@", currentWorkout!.name!)
        
        request.predicate = workoutPredicate
        
        do {
            exercises = try context.fetch(request)
        }
        catch {
            print("Error loading items \(error)")
        }
        tableView.reloadData()
    }

}
