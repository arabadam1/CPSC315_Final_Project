
import Foundation
import UIKit

class MusicViewController: UIViewController, UISceneDelegate, UIWindowSceneDelegate {
    
    var mySpotifyDelegate : MySpotifyDelegate? = nil
    
    var songs : [String] = [
        "spotify:track:3Q6F8RByyhRTJpRtZLY3cg",
        "spotify:track:6Yqmv7XJLCrQEauMbPGZSw",
        "spotify:track:3aNo9bcIR1uese91Xa12oE"
    ]
    
    var songID : Int = 0
    
    var defaultCallback: SPTAppRemoteCallback { //default callback is spotify's way of saying "this works." returns error is not
        get {
            return {[weak self] _, error in
                if let error = error {
                    let newError = error as? NSError
                    let alert = UIAlertController(title: "Error", message: newError?.description, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self!.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    private let playURI = "spotify:track:5sdkS8DXx8rXNLxbSos8GS"
    private let trackIdentifier = "spotify:track:5sdkS8DXx8rXNLxbSos8GS"
    private let name = "Now Playing View"
    
    
    @IBAction func playButtonPressed(){
        var AR = mySpotifyDelegate?.appRemote
        
        AR?.authorizeAndPlayURI(songs[songID])
        songID += 1
        AR?.connect()

        if(mySpotifyDelegate?.appRemote.isConnected != nil){
            if(mySpotifyDelegate?.appRemote.isConnected == true){
                print("true")
            } else {
                print("it's not connected")
            }
        } else {
            print("it's nil")
        }
    }
}

