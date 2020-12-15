
import Foundation
import UIKit

class MusicViewController: UIViewController, UISceneDelegate, UIWindowSceneDelegate {
    
    var appRemote : SPTAppRemote? = nil
    
    @IBOutlet var connectedLabel : UILabel!
    @IBOutlet var connectButton : UIButton!
    @IBOutlet var pauseButton : UIButton!
    
    
    @IBAction func pause(_sender: UIButton){
        if !(appRemote?.isConnected ?? false){
            print("app remote is not connected")
            appRemote?.authorizeAndPlayURI(songs[0])
        } else {
            appRemote?.playerAPI?.pause({(anyOptional, errorOptional) in
                print("Successfully Paused")
            })
            pauseButton.setTitle("Play", for: .normal)
        }
    }
    
    var index = -1
    var songs : [String] = [
        "spotify:track:3Q6F8RByyhRTJpRtZLY3cg",
        "spotify:track:6Yqmv7XJLCrQEauMbPGZSw",
        "spotify:track:3aNo9bcIR1uese91Xa12oE",
        "spotify:track:0PPcv1x7uCQAe3oF2j66io",
        "spotify:track:0YFwNNWeRQhOi6p17jTCzp",
        "spotify:track:5dIbt8z9xaqQGsLhzTWqUm",
        "spotify:track:6MDdceLYec4AxohmorE4vH",
        "spotify:track:5sBplhIrmzA4kQGyIOpmDf",
        "spotify:track:5mMQUkzDRr8O3Kg7bXUYb7",
        "spotify:track:0qJeyYAgv6UpvewUxRXAhb",
        "spotify:track:0qJeyYAgv6UpvewUxRXAhb",
    ]
    
    override func viewDidLoad() {
        connectButton.setTitle("Connect To Spotify", for: .normal)
    }
    
    private let trackIdentifier = "spotify:track:5sdkS8DXx8rXNLxbSos8GS"
    private let name = "Now Playing View"
    
    @IBAction func connectButtonPressed(_sender: UIButton){
        if !(appRemote?.isConnected ?? false){
            appRemote?.connect()
            connectedLabel.text = "Connected to Spotify"
            connectedLabel.textColor = UIColor.systemGreen
            connectButton.setTitle("Disconnect From Spotify", for: .normal)
        }
    }
    
    @IBAction func playButtonPressed(){
        index += 1
        index %= songs.count
        let playURI = songs[index]
        if !(appRemote?.isConnected ?? false){
            print("app remote is not connected")
            appRemote?.authorizeAndPlayURI(playURI)
        } else {
            print("app remote is connected")
            appRemote?.playerAPI?.play(playURI, callback: {(anyOptional, errorOptional) in
                print("successfully playing")
            })
        }
    }
    
    @IBAction func skipButtonPressed(){
        index += 1
        index %= songs.count
        let playURI = songs[index]
        if !(appRemote?.isConnected ?? false){
            print("app remote is not connected")
            appRemote?.authorizeAndPlayURI(playURI)
        } else {
            print("app remote is connected")
            appRemote?.playerAPI?.play(playURI, callback: {(anyOptional, errorOptional) in
                print("Skipped a song")
            })
        }
    }
    
    @IBAction func previousButtonPressed(){
        index -= 1
        index %= songs.count
        let playURI = songs[index]
        if !(appRemote?.isConnected ?? false){
            print("app remote is not connected")
            appRemote?.authorizeAndPlayURI(playURI)
        } else {
            print("app remote is connected")
            appRemote?.playerAPI?.play(playURI, callback: {(anyOptional, errorOptional) in
                print("Playing previous song.")
            })
        }
    }
}

