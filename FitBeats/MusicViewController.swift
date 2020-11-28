//
//  MusicViewController.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/27/20.
//

import Foundation
import UIKit

class MusicViewController: UIViewController {
    
    let SpotifyClientID = "6fbaa5569f1a443e8ad6b48a8af3dddd"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    
    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
      let parameters = appRemote.authorizationParameters(from: url);

            if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
                appRemote.connectionParameters.accessToken = access_token
                self.accessToken = access_token
            } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
                // Show the error
            }
      return true
    }
    
    lazy var appRemote: SPTAppRemote = {
      let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
      appRemote.connectionParameters.accessToken = self.accessToken
      appRemote.delegate = self
      return appRemote
    }()
    
    self.playURI = ""
    
    func connect()) {
      self.appRemote.authorizeAndPlayURI(self.playURI)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if self.appRemote.isConnected {
            self.appRemote.disconnect()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let _ = self.appRemote.connectionParameters.accessToken {
            self.appRemote.connect()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
