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
