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
    
    let MSD = MySpotifyDelegate()
    var MusicVC : MusicViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let name = workoutSelected?.name else {
                workoutName.text = "Please select a workout before starting!"
                return
        }
        workoutName.text = name;
        workoutName.textColor = .green
    }
           
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if there is a valid identifier
        if let identifier = segue.identifier  {
            //and it is the appropriate segue for the detail screen
                if identifier == "BeginWorkoutSegue" {
                    if let startVC = segue.destination as? StartTableViewController {
                        startVC.currentWorkout = workoutSelected
                    }
                } else if identifier == "ChangeMusicSegue" {
                    if let MusicVC = segue.destination as? MusicViewController {
                        MusicVC.mySpotifyDelegate = MSD
                    }
                } else if identifier == "ChangeWorkoutSegue" {
                    if let workoutVC = segue.destination as? WorkoutTableViewController {
                        workoutVC.selectedWorkout = workoutSelected
                    }
                }
            }
        }
           
    /*override func shouldPerformSegue (withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "BeginWorkoutSegue" {
            guard let workout = workoutSelected else {
                let alertController = UIAlertController(title: "No Workout Selected", message: "Please choose a workout before starting!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
                return false
            }
            guard let startWorkoutVC = segue.destination as? StartTableViewController else {
                return false
            }
            
            let workout = workouts[selectedIndexPath.row]
            exerciseTableVC.workout = workout
        }
        return true
    }*/
    
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        if let identifier = segue.identifier {
            if identifier == "WorkoutUnwindSegue" {
                if let workoutTableVC = segue.source as? WorkoutTableViewController {
                    if let workout = workoutTableVC.selectedWorkout {
                        workoutSelected = workout
                        workoutName.text = workoutSelected?.name;
                        workoutName.textColor = .green
                    }
                }
            }
        }
    }
    
}

