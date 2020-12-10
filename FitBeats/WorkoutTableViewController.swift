//
//  WorkoutTableTableViewController.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/28/20.
//
import UIKit
import CoreData

class WorkoutTableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var workouts = [Workout]()
    var selectedWorkout : Workout? = nil
    var lastSelectedWorkoutPath : IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(WorkoutTableViewController.selectWorkout))
        tableView.addGestureRecognizer(longTapGestureRecognizer)
        loadWorkouts()
        print("General Kenobi")
    }

    // MARK: - Table view data source
    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return workouts.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath)
        
        // Configure the cell...
        let workout = workouts[indexPath.row]
        cell.textLabel?.text = workout.name
        if let currWorkout = selectedWorkout {
            if (workout == currWorkout) {
                cell.accessoryType = .checkmark
                lastSelectedWorkoutPath = indexPath
                //print("Hello there")
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let workout = workouts.remove(at: sourceIndexPath.row)
        workouts.insert(workout, at: destinationIndexPath.row)
        
        tableView.reloadData()
        saveWorkouts()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(workouts[indexPath.row])
        workouts.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        saveWorkouts()
    }
    
    @IBAction func createBarButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Create New Workout", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name of Workout"
            alertTextField = textField
        }
        
        let action = UIAlertAction(title: "Create", style: .default) { (alertAction) in
            let text = alertTextField.text!
            let newWorkout = Workout(context: self.context)
            newWorkout.name = text
            self.workouts.append(newWorkout)
            self.saveWorkouts()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ShowExercisesSegue"  {
            
            guard let exerciseTableVC = segue.destination as? ExerciseTableViewController else {
                return
            }
        
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let workout = workouts[selectedIndexPath.row]
            exerciseTableVC.workout = workout
        }
    }
    
    @objc func selectWorkout(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let lastIndexPath = lastSelectedWorkoutPath {
                    tableView.cellForRow(at: lastIndexPath)?.accessoryType = .none
                    print("Hello there")
                }
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                lastSelectedWorkoutPath = indexPath
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "WorkoutUnwindSegue" {
            guard let indexPath = lastSelectedWorkoutPath else {
                print("Workout not selected")
                return true
            }
            selectedWorkout = workouts[indexPath.row]
        }
        return true
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    func saveWorkouts() {
        do {
            try context.save()
        }
        catch {
            
            print("Error saving workouts \(error)")
        }
        tableView.reloadData()
    }
    
    func loadWorkouts() {
        let request: NSFetchRequest<Workout> = Workout.fetchRequest()
        do {
            workouts = try context.fetch(request)
        }
        catch {
            print("Error loading workouts \(error)")
        }
        tableView.reloadData()
    }
    
    @IBAction func editButtonPressed(_ sender:  UIBarButtonItem) {
        let newEditingMode = !tableView.isEditing
        tableView.setEditing(newEditingMode, animated: true)
    }

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
