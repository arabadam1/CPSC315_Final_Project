//
//  ExerciseTableViewController.swift
//  FitBeats
//
//  Created by Adrian Rabadam on 11/29/20.
//

import UIKit
import CoreData

class ExerciseTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var nameTextField = UITextField()
    var durationTextField = UITextField()
    var intensityTextField = UITextField()
    let picker = UIPickerView()
    
    var workout: Workout? = nil {
        didSet {
            loadExercises()
        }
    }
    var exercises = [Exercise]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let workout = workout, let name = workout.name {
            self.navigationItem.title = "\(name) Exercises"
        }
        picker.delegate = self
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return exercises.count
        }
        else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseCell", for: indexPath) as! ExerciseTableViewCell

        let exercise = exercises[indexPath.row]
        cell.update(with: exercise)
        

        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(exercises[indexPath.row])
            exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveExercises()
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let exercise = exercises.remove(at: sourceIndexPath.row)
        exercises.insert(exercise, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    /*override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // called whenever the user selects (taps) on a row
        let exercise = exercises[indexPath.row]
        saveExercises()
        tableView.deselectRow(at: indexPath, animated: true)
    }*/
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Create New Exercise", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name of Exercise"
            self.nameTextField = textField
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Duration (seconds)"
            self.durationTextField = textField
        }
        
        alert.addTextField { (textField) in
            textField.inputView = self.picker
            textField.placeholder = "Intensity"
            self.intensityTextField = textField
        }
        
        let action = UIAlertAction(title: "Create", style: .default) { (alertAction) in
            let nameText = self.nameTextField.text!
            let durationText = self.durationTextField.text!
            let intensityText = self.intensityTextField.text!
            let newExercise = Exercise(context: self.context)
            newExercise.name = nameText
            newExercise.length = Int32(durationText) ?? 10
            newExercise.intensity = Int32(intensityText) ?? 5
            newExercise.parentWorkout = self.workout
            self.exercises.append(newExercise)
            self.saveExercises()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveExercises() {
        do {
            try context.save()
        }
        catch {
            print("Error saving items \(error)")
        }
        tableView.reloadData()
    }
    
    func loadExercises(withPredicate predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        let workoutPredicate = NSPredicate(format: "parentWorkout.name MATCHES %@", workout!.name!)
        
        request.predicate = workoutPredicate
        
        do {
            exercises = try context.fetch(request)
        }
        catch {
            print("Error loading items \(error)")
        }
        tableView.reloadData()
    }
    
    let pickerData = [String](arrayLiteral: "1", "2", "3", "4", "5", "6", "7", "8", "9", "10")
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        intensityTextField.text = self.pickerData[row]
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
