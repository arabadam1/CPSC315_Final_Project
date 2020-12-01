//
//  ViewController.swift
//  FitBeats
//
//  Created by Adrian Rabadam on 11/27/20.
//

import UIKit

class MainViewController: UIViewController {

    var workoutSelected : Workout?
    @IBOutlet var workoutName : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(workoutSelected != nil){
            guard let name = workoutSelected?.name else {
                workoutName.text = "Please select a workout before starting!"
                return
            }
            workoutName.text = name;
        }
    }
           
           override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
               //if there is a valid identifier
               if let identifier = segue.identifier  {
                   //and it is the appropriate segue for the detail screen
                   if identifier == "BeginWorkoutSegue" {
           
                   } else if identifier == "ChangeMusicSegue" {

                   } else if identifier == "ChangeWorkoutSegue" {
                       if let workoutVC = segue.destination as? WorkoutTableViewController {
                               
                       }
                   }
               }
           }
           
           override func shouldPerformSegue (withIdentifier identifier: String, sender: Any?) -> Bool {
               if identifier == "BeginWorkoutSegue" {
                   if(workoutSelected == nil){
                       let alertController = UIAlertController(title: "No Workout Selected", message: "Please choose a workout before starting!", preferredStyle: .alert)
                       alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                       present(alertController, animated: true, completion: nil)
                       return false
                   }
               }
               return true
           }
    
}

