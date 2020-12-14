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
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
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
    
    @IBAction func pauseExercise(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? ActiveExerciseCell
        cell?.stopTimer()
        self.stopTimer()
        let alertController = UIAlertController(title: "Paused", message: "Your workout is currently paused", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Resume", style: .default, handler: {_ in
            cell?.startTimer()
            self.startTimer()
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true)
    }
    
    @IBAction func skipExercise(_ sender: UIButton) {
        deleteExercise()
    }
        
    func deleteExercise() {
        let indexPath = IndexPath(row: 0, section: 0)
        exercises.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        timer?.invalidate()
        
        var transitionAlert : UIAlertController = UIAlertController()
        
        var transitionTimer : Timer? = nil
        var transitionSecondsLeft: Int = 15 {
            didSet {
                if (transitionSecondsLeft == 0) {
                    transitionTimer?.invalidate()
                    transitionTimer = nil
                    transitionAlert.dismiss(animated: true, completion: nil)
                    tableView.reloadData()
                }
                transitionAlert.message = "Next exercise in: \(transitionSecondsLeft)"
            }
        }
        if exercises.count == 0 {
            let alertController = UIAlertController(title: "Workout Completed", message: "You have finished your workout!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in
                self.stopTimer()
                alertController.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true)
        }
        else {
            transitionAlert = UIAlertController(title: "Transition", message: "Change exercise!", preferredStyle: .alert)
            transitionAlert.addAction(UIAlertAction(title: "Skip", style: .default, handler: {_ in
                transitionTimer?.invalidate()
                transitionTimer = nil
                transitionAlert.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
            }))
            
            present(transitionAlert, animated: true) {
                transitionTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                    transitionSecondsLeft -= 1
                })
            }
        }
    }
    
    func loadExercises(withPredicate predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        
        let workoutPredicate = NSPredicate(format: "parentWorkout.name MATCHES %@", currentWorkout!.name!)
        
        request.predicate = workoutPredicate
        
        do {
            exercises = try context.fetch(request)
            //compilePlaylist(exercises)
        }
        catch {
            print("Error loading items \(error)")
        }
        tableView.reloadData()
    }
     
    func compilePlaylist(exercises : [Exercise]) -> [String]{
        let choices : [String] = ["", ""]       //choices of songs: will edit later
        var finishedURIList : [String] = []     //list to be returned of URIs that work with this workout
        for i in 0..<exercises.count{           // 1 song per exercise
            let length = exercises[i].length
            let intensity = exercises[i].intensity
            let filteredByIntensity = choices.filter { song in
                //filteredByIntensity creates a list of appropriate songs that have similar intensities
                return findIntensityInDatabase(song: song) == intensity
            }
            let filteredByLength = filteredByIntensity.filter { song in
                //filteredByLength creates a list of songs with a good length and similar intensities
                return abs(findLengthInDatabase(song : song) - Int(length)) < 20
            }
            
            var bestSong : String = "" //empty to start
            var closestLength : Int = 1000000 //dummy variable
            
            //the next loop picks the song with the CLOSEST LENGTH to play during your workout
            for i in 0..<filteredByLength.count {
                var currentApproximation = abs(findLengthInDatabase(song : filteredByLength[i]) - Int(length))
                if(i == 0) {
                    closestLength = currentApproximation
                    bestSong = filteredByLength[i]
                } else {
                    if(abs(findLengthInDatabase(song : filteredByLength[i]) - Int(length)) < closestLength){
                        closestLength = currentApproximation
                        bestSong = filteredByLength[i]
                    }
                }
            }
            finishedURIList.append(bestSong) //append the best song for the exercise
        }
        return finishedURIList //return the playlist of songs to play
    }
    
    func findIntensityInDatabase(song : String) -> Int{
        /*
         search song intensity based on what the user enters
         */
        return 0
    }
    
    func findLengthInDatabase(song : String) -> Int{
        return 0
    }

}
