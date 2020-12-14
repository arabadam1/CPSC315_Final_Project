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
    @IBOutlet var motivationalQuote : UILabel!
    
    
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
        motivationalQuote.text = getQuote()
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
    
    func getQuote() -> String{
        var myMotivationalString : String = ""
        let quoteNum = Int.random(in: 0..<7)
        switch quoteNum {
        case 0:
            myMotivationalString = "\"Winners Never Quit, and Quitters Never Win\""
        case 1:
            myMotivationalString = "\"There is No Failure, Except in No Longer Trying\""
        case 2:
            myMotivationalString = "\"Never Give Up on Something You Can't Go a Day Without Thinking About\""
        case 3:
            myMotivationalString = "\"It Does Not Matter how Slowly You Go, As Long as You Do Not Stop\""
        case 4:
            myMotivationalString = "\"You Cannot Beat the Person who Will Not Give Up\""
        case 5:
            myMotivationalString = "\"It Always Seems Impossible Until It's Done\""
        case 6:
            myMotivationalString = "\"Rise and Grind.\""
        default:
            myMotivationalString = "No Motivation For Today. Find it Within."
        }
        return myMotivationalString
    }
}
