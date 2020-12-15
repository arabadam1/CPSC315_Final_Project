//
//  MySpotifyDelegate.swift
//  SpotifySDKFun
//
//  Created by Gina Sprint on 12/10/20.
//

import Foundation

class MySpotifyDelegate: NSObject, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    static private let kAccessTokenKey = "access-token-key"
    
    let SpotifyClientID = "6fbaa5569f1a443e8ad6b48a8af3dddd"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        appRemote.delegate = self
        return appRemote
    }()
    
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: MySpotifyDelegate.kAccessTokenKey)
        }
    }
    

    // GS: added for SPT delegates
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        print("connected")
        self.appRemote = appRemote
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      print("player state changed")
    }

    
}
