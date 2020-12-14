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
    
    var timer : Timer? = nil
    var secondsLeft : Int = 60 {
        didSet {
            if(secondsLeft == 0){
                deleteExercise()
            }
        }
    }
    
    let skipButton = UIButton(type: UIButton.ButtonType.system) as UIButton
    
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
    
    func startTimer () {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.secondsLeft -= 1
        })
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
            secondsLeft = cell.secondsLeft
            startTimer()
            cell.startTimer()
        }
        return cell
    }
    
    @IBAction func pauseExercise(_ sender: UIButton) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? ActiveExerciseCell
        if cell?.timer != nil {
            cell?.startTimer()
        }
        else {
            cell?.stopTimer()
        }
    }
    
    @IBAction func skipExercise(_ sender: UIButton) {
        deleteExercise()
    }
        
    func deleteExercise() {
        let indexPath = IndexPath(row: 0, section: 0)
        exercises.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        timer?.invalidate()
        var transitionTimer : Timer? = nil
        var transitionSecondsLeft: Int = 15 {
            didSet {
                if (transitionSecondsLeft == 0) {
                    transitionTimer?.invalidate()
                    transitionTimer = nil
                    alertController.dismiss(animated: true, completion: nil)
                    tableView.reloadData()
                }
                alertController.message = "Next exercise in: \(transitionSecondsLeft)"
            }
        }
        let alertController = UIAlertController(title: "Transition", message: "Change exercise!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true) {
            transitionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                transitionSecondsLeft -= 1
            })
        }
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
