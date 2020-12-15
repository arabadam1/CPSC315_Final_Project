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
    
    var appRemote : SPTAppRemote? = nil
    var currentlyPlayingIndex : Int = 0
    
    var currentWorkout : Workout? = nil
    var exercises = [Exercise]()
    var playlist = [String]()
    
    var timer : Timer? = nil
    var secondsLeft : Int = 60 {
        didSet {
            if(secondsLeft == 0){
                currentlyPlayingIndex+=1
                if exercises.count > 1 {
                    appRemote?.playerAPI?.play(playlist[currentlyPlayingIndex], callback: {(anyOptional, errorOptional) in
                        print("successfully playing")
                    })
                }
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
        appRemote?.playerAPI?.play("spotify:track:2M5ndhTi0zOIymTD4Ff1T8", callback: {(anyOptional, errorOptional) in
            print("successfully playing")
        })
        
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
        appRemote?.playerAPI?.pause({(anyOptional, errorOptional) in
            print("successfully paused")
        })
        let alertController = UIAlertController(title: "Paused", message: "Your workout is currently paused", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Resume", style: .default, handler: {_ in
            cell?.startTimer()
            self.startTimer()
            self.appRemote?.playerAPI?.resume()
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true)
    }
    
    @IBAction func skipExercise(_ sender: UIButton) {
        deleteExercise()
        currentlyPlayingIndex += 1
        currentlyPlayingIndex %= playlist.count
        let playURI = playlist[currentlyPlayingIndex]
        appRemote?.playerAPI?.play(playURI, callback: {(anyOptional, errorOptional) in
            print("successfully playing")
        })
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
        }
        catch {
            print("Error loading items \(error)")
        }
        tableView.reloadData()
        playlist = compilePlaylist(exercises: exercises)
    }
     
    func compilePlaylist(exercises : [Exercise]) -> [String]{
        var finishedURIList : [String] = []     //list to be returned of URIs that work with this workout
        for i in 0..<exercises.count{           // 1 song per exercise
            let length = exercises[i].length
            let intensity = exercises[i].intensity
            let filteredByIntensity = database.filter { song in
                //filteredByIntensity creates a list of appropriate songs that have similar intensities
                return song.intensity == intensity
            }
            
            print("For intensity " + String(intensity) + " correlating to exercise " + exercises[i].name!)
            for j in 0..<filteredByIntensity.count{
                print(filteredByIntensity[j].name)
            }
            print("")
            
            // commented out for test, needs error handling
            /*let filteredByLength = filteredByIntensity.filter { song in
                //filteredByLength creates a list of songs with a good length and similar intensities
                if((song.length - Int(length)) < 25){
                    return true
                } else {
                    return false
                }
            }
            
            print("For length " + String(length) + " correlating to exercise " + exercises[i].name!)
            for x in 0..<filteredByLength.count{
                print(filteredByIntensity[x].name)
            }
            print("")*/
            
            var bestSong: String = ""
            bestSong = filteredByIntensity[0].URI
            print(filteredByIntensity[0].name + " was added to the playlist.")
            var closestLength : Int = 1000000 //dummy variable
            
            //the next loop picks the song with the CLOSEST LENGTH to play during your workout
            /*
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
             */
            finishedURIList.append(bestSong) //append the best song for the exercise
        }
        
        for i in 0..<finishedURIList.count{
            print(finishedURIList[i])
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
    
    let database : [Song] = [
        Song(length: 163, intensity: 4, name: "Contact", URI : "spotify:track:2M5ndhTi0zOIymTD4Ff1T8"),
        Song(length: 287, intensity: 6, name: "Fade Away", URI : "spotify:track:4QRWA5UqYU1st9aO0UfxOj"),
        Song(length: 173, intensity: 7, name: "Upgrade", URI : "spotify:track:5psz20rVFNRlt0u9cpzBpY8"),
        Song(length: 99, intensity: 3, name: "White People", URI : "spotify:track:7Li7ff5lQ1gqvwbCdRXaQL"),
        Song(length: 233, intensity: 5, name: "Like Woah", URI : "spotify:track:6bM3GKo47KVgvj3gHdWS0U"),
        Song(length: 500, intensity: 9, name: "Young Jesus", URI : "spotify:track:0KiKfllNTmhImvXVIHqR0z"),
        Song(length: 240, intensity: 3, name: "Innermission", URI : "spotify:track:1zucHJN4WKHIzSL4FyiJw9"),
        Song(length: 203, intensity: 9, name: "I Am the Greatest", URI : "spotify:track:1BTj47Up5m8601KOFrTvkj"),
        Song(length: 27, intensity: 1, name: "The Cube- Scene", URI : "spotify:track:30S46V7RcyGXUModoqW69b"),
        Song(length: 209, intensity: 10, name: "Lord Willin'", URI : "spotify:track:4q6oNFTjZmJqkIgPdp8iR1"),
        Song(length: 377, intensity: 5, name: "City of Stars", URI : "spotify:track:5mJbSgVBnJ4ayOjFdmyOdl"),
        Song(length: 200, intensity: 8, name: "Stainless", URI : "spotify:track:5rwOE5J3Y1A2NiRa6y3Yph"),
        Song(length: 71, intensity: 4, name: "Babel", URI : "spotify:track:58RqurG6pfsJVxNyc9OL22"),
        Song(length: 282, intensity: 4, name: "Paradise", URI : "spotify:track:0M2ZekrsEkru9Xp5rWnouQ"),
        Song(length: 247, intensity: 7, name: "Never Been", URI : "spotify:track:0aAk9KMmPChiS2EG9Fg7IX"),
        Song(length: 201, intensity: 7, name: "Run It", URI : "spotify:track:4iq3zHwgHSxstFvYw4yIsQ"),
        Song(length: 56, intensity: 1, name: "Lucidity- Scene", URI : "spotify:track:1sQBStJC5unqE7TzStlFQl"),
        Song(length: 234, intensity: 4, name: "Broken Whiskey Glass", URI : "spotify:track:5BoOzegGrg5XFRR8UBDtkF"),
        Song(length: 208, intensity: 4, name: "Big Lie", URI : "spotify:track:02opp1cycqiFNDpLd2o1J3"),
        Song(length: 417, intensity: 7, name: "Deja Vu", URI : "spotify:track:0H8XeaJunhvpBdBFIYi6Sh"),
        Song(length: 180, intensity: 5, name: "No Option", URI : "spotify:track:6M0IsaUX4GNyto4niSegfI"),
        Song(length: 269, intensity: 6, name: "Cold", URI : "spotify:track:1QWmKmqhv5zcsS3v45FNl0"),
        Song(length: 257, intensity: 8, name: "White Iverson", URI : "spotify:track:1QWmKmqhv5zcsS3v45FNl0"),
        Song(length: 223, intensity: 2, name: "I Fall Apart", URI : "spotify:track:75ZvA4QfFiZvzhj2xkaWAh"),
        Song(length: 194, intensity: 2, name: "Patient", URI : "spotify:track:75ZvA4QfFiZvzhj2xkaWAh"),
        Song(length: 180, intensity: 3, name: "Go Flex", URI : "spotify:track:5yuShbu70mtHXY0yLzCQLQ"),
        Song(length: 197, intensity: 4, name: "Feel", URI : "spotify:track:7MTIDmToGs0I5Oue9V0CHl"),
        Song(length: 237, intensity: 5, name: "Too Young", URI : "spotify:track:4SYUUlkScpNR1QvPscXf8t"),
        Song(length: 220, intensity: 10, name: "Congratulations", URI : "spotify:track:3a1lNhkSLSkpJE4MSHpDu9"),
        Song(length: 195, intensity: 2, name: "Up There", URI : "spotify:track:2rKmNEYrQxaOPZrOWKZpOc"),
        Song(length: 219, intensity: 3, name: "Yours Truly, Austin Post", URI : "spotify:track:0LpiKjWMfZTkPPHonlM8nB"),
        Song(length: 325, intensity: 3, name: "Leave", URI : "spotify:track:5dI1yHSqgmilFEqpGbqxHh"),
        Song(length: 249, intensity: 5, name: "Hit This Hard", URI : "spotify:track:61jnrkPHpLumBf1kqGpRRt"),
        Song(length: 225, intensity: 1, name: "Money Made Me Do It", URI : "spotify:track:1ysAvOdJgUjc6CqOQxepaz"),
        Song(length: 257, intensity: 2, name: "Feeling Whitney", URI : "spotify:track:35r28RDot7nPE7y9K9H7l0")
    ]

}
