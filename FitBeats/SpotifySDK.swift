//
//  SpotifySDK.swift
//  FitBeats
//
//  Created by Adrian Rabadam on 11/28/20.
//

import Foundation

class SpotifySDK {
    
    let SpotifyClientID = "6fbaa5569f1a443e8ad6b48a8af3dddd"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    var accessToken = "spotifyAccessToken"
    
    
    
    /*lazy var appRemote: SPTAppRemote = {
      let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
      appRemote.connectionParameters.accessToken = self.accessToken
      appRemote.delegate = self
      return appRemote
    }()
    
    self.playURI = ""
    
    func connect() {
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
    
    */
}
