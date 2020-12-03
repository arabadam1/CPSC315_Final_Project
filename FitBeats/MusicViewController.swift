//
//  MusicViewController.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/27/20.
//

import Foundation
import UIKit

class MusicViewController: UIViewController, UISceneDelegate, UIWindowSceneDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {

    private let SpotifyRedirectURL = URL(string:"spotify-ios-quick-start://spotify-login-callback")!
    private let SpotifyClientID = "08aa155ef54a4b3d8e18b1dc28ab96d5"
    static private let kAccessTokenKey = "access-token-key"
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    var window: UIWindow?
    @IBOutlet var connectedLabel: UILabel!
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
        
    var playURI = ""
        
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: MusicViewController.kAccessTokenKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let alert = UIAlertController(title: "Connect to Spotify", message: "Would you like this app to open Spotify?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            self.connect()
        }
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (alertAction) in
                    
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        let parameters = appRemote.authorizationParameters(from: url);
            if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
                appRemote.connectionParameters.accessToken = access_token
                self.accessToken = access_token
            } else if let _ = parameters?[SPTAppRemoteErrorDescriptionKey] {
                  // Show the error
        }

    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
        
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
          
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        // Connection was successful, you can begin issuing commands
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
        print("connected")
    }
          
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Track name: %@", playerState.track.name)
        print("player state changed")
    }
          
    func sceneDidBecomeActive(_ scene: UIScene) {
        connect()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        /*if self.appRemote.isConnected {
            self.appRemote.disconnect()
        }*/
    }
          
    func connect() {
        self.appRemote.connect()
        if (!appRemote.isConnected) {
            self.appRemote.authorizeAndPlayURI(self.playURI)
        }
        connectedLabel.text = "Spotify Connected"
        connectedLabel.textColor = .systemGreen
    }
          
    @IBAction func disconnectPressed(_ sender: UIButton) {
        self.appRemote.disconnect()
    }
    
}
