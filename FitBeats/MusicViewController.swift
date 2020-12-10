//
//  MusicViewController.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/27/20.
//
/*
import Foundation
import UIKit

class MusicViewController: UIViewController, UISceneDelegate, UIWindowSceneDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    private var playerState : SPTAppRemotePlayerState?
    
    private let playURI = "spotify:track:5sdkS8DXx8rXNLxbSos8GS"
    private let trackIdentifier = "spotify:track:5sdkS8DXx8rXNLxbSos8GS"
    private let name = "Now Playing View"
    
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
    
    @IBAction func playButtonPressed(){
        /*
        if playerState == nil || playerState!.isPaused{
            if(playerState == nil){
                print("player state is nil")
            } else {
                print("it is paused")
            }
            startPlayback()
            appRemote.playerAPI?.seekForward15Seconds(defaultCallback)
        } else {
            pausePlayback()
        } */
        appRemote.authorizeAndPlayURI("spotify:track:4mL25h2hl6gdyu9tNTudnI")
    }
    
    private func startPlayback() { //begins playback
        appRemote.playerAPI?.play(playURI, asRadio: false, callback: defaultCallback)
        //appRemote.enqueueTrackUri(playURI, callback: defaultCallback)
    }
    
    private func pausePlayback() { //pauses playback
        appRemote.playerAPI?.pause(defaultCallback)
    }
    
    private func skipNext() {
        appRemote.playerAPI?.skip(toNext: defaultCallback)
    }
    
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
        
        
    var accessToken = UserDefaults.standard.string(forKey: kAccessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: MusicViewController.kAccessTokenKey)
        }
    }
    
    override func viewDidLoad() { //when the app starts, immediately throw an alert to connect
        super.viewDidLoad()
        self.connect() //or, auto connect.
        // took the alert out!
        /*
        let alert = UIAlertController(title: "Connect to Spotify", message: "Would you like this app to open Spotify?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes", style: .default) { (alertAction) in self.connect()} //connect if yes is pressed
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { (alertAction) in}
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil) */
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
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.getPlayerState(defaultCallback)
        appRemote.playerAPI?.subscribe(toPlayerState: defaultCallback)
        
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
          
    func connect() {
        //appRemote.authorizeAndPlayURI(playURI)
        //self.appRemote.connect()
        if (!appRemote.isConnected) {
            self.appRemote.authorizeAndPlayURI(self.playURI)
            self.appRemote.connect()
        }
        if(appRemote.isConnected){
            appRemoteDidEstablishConnection(appRemote)
        } else {
            print("it's not connected. :(")
        }
        connectedLabel.text = "Spotify Connected"
        connectedLabel.textColor = .systemGreen
    }
          
    @IBAction func disconnectPressed(_ sender: UIButton) {
        self.appRemote.disconnect()
    }
    
    private func getPlayerState() {
        appRemote.playerAPI?.getPlayerState { (result, error) -> Void in
            guard error == nil else { return }

            self.playerState = result as! SPTAppRemotePlayerState
            //self.updateViewWithPlayerState(playerState)
        }
    }
    
}
 */
 

import Foundation
import UIKit

class MusicViewController: UIViewController, UISceneDelegate, UIWindowSceneDelegate {
    
    private var playerState : SPTAppRemotePlayerState?
    private var subscribedToPlayerState: Bool = false
    private var subscribedToCapabilities: Bool = false
    
    private let playURI = "spotify:track:5sdkS8DXx8rXNLxbSos8GS"
    private let trackIdentifier = "spotify:track:5sdkS8DXx8rXNLxbSos8GS"
    private let name = "Now Playing View"
    
    var defaultCallback: SPTAppRemoteCallback {
        get {
            return {[weak self] _, error in
                if let error = error {
                    let newError = error as NSError
                    let alert = UIAlertController(title: "Error", message: newError.description, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self!.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    var appRemote: SPTAppRemote? {
        get {
            return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appRemote
        }
    }
    
    private func updateViewWithPlayerState(_ playerState: SPTAppRemotePlayerState) {
        //updatePlayPauseButtonState(playerState.isPaused)
        //updateRepeatModeLabel(playerState.playbackOptions.repeatMode)
        //updateShuffleLabel(playerState.playbackOptions.isShuffling)
        //trackNameLabel.text = playerState.track.name + " - " + playerState.track.artist.name
        //fetchAlbumArtForTrack(playerState.track) { (image) -> Void in
            //self.updateAlbumArtWithImage(image)
        //}
        //updateViewWithRestrictions(playerState.playbackRestrictions)
        //updateInterfaceForPodcast(playerState: playerState)
    }
    
    private func updatePlayPauseButtonState(_ paused: Bool) {
        //let playPauseButtonImage = paused ? PlaybackButtonGraphics.playButtonImage() : PlaybackButtonGraphics.pauseButtonImage()
        //playPauseButton.setImage(playPauseButtonImage, for: UIControl.State())
        //playPauseButton.setImage(playPauseButtonImage, for: .highlighted)
    }

    private func updatePlayerStateSubscriptionButtonState() {
        //let playerStateSubscriptionButtonTitle = subscribedToPlayerState ? "Unsubscribe" : "Subscribe"
        //playerStateSubscriptionButton.setTitle(playerStateSubscriptionButtonTitle, for: UIControl.State())
    }

    // MARK: Capabilities
    private func updateViewWithCapabilities(_ capabilities: SPTAppRemoteUserCapabilities) {
        //onDemandCapabilitiesLabel.text = "Can play on demand: " + (capabilities.canPlayOnDemand ? "Yes" : "No")
    }

    private func updateCapabilitiesSubscriptionButtonState() {
        //let capabilitiesSubscriptionButtonTitle = subscribedToCapabilities ? "Unsubscribe" : "Subscribe"
        //capabilitiesSubscriptionButton.setTitle(capabilitiesSubscriptionButtonTitle, for: UIControl.State())
    }
    
    private func skipNext() {
        appRemote?.playerAPI?.skip(toNext: defaultCallback)
    }

    private func skipPrevious() {
        appRemote?.playerAPI?.skip(toPrevious: defaultCallback)
    }

    private func startPlayback() {
        appRemote?.playerAPI?.resume(defaultCallback)
    }

    private func pausePlayback() {
        appRemote?.playerAPI?.pause(defaultCallback)
    }
    
    private func playTrack() {
        appRemote?.playerAPI?.play(trackIdentifier, callback: defaultCallback)
    }

    private func enqueueTrack() {
        appRemote?.playerAPI?.enqueueTrackUri(trackIdentifier, callback: defaultCallback)
    }

    private func toggleShuffle() {
        guard let playerState = playerState else { return }
        appRemote?.playerAPI?.setShuffle(!playerState.playbackOptions.isShuffling, callback: defaultCallback)
    }

    private func getPlayerState() {
        appRemote?.playerAPI?.getPlayerState { (result, error) -> Void in
            guard error == nil else { return }

            let playerState = result as! SPTAppRemotePlayerState
            self.updateViewWithPlayerState(playerState)
        }
    }
    
    private func playTrackWithIdentifier(_ identifier: String) {
        appRemote?.playerAPI?.play(identifier, callback: defaultCallback)
    }

    private func subscribeToPlayerState() {
        guard (!subscribedToPlayerState) else { return }
        appRemote?.playerAPI!.delegate = self
        appRemote?.playerAPI?.subscribe { (_, error) -> Void in
            guard error == nil else { return }
            self.subscribedToPlayerState = true
            self.updatePlayerStateSubscriptionButtonState()
        }
    }

    private func unsubscribeFromPlayerState() {
        guard (subscribedToPlayerState) else { return }
        appRemote?.playerAPI?.unsubscribe { (_, error) -> Void in
            guard error == nil else { return }
            self.subscribedToPlayerState = false
            self.updatePlayerStateSubscriptionButtonState()
        }
    }

    
    // MARK: - User API
    private func fetchUserCapabilities() {
        appRemote?.userAPI?.fetchCapabilities(callback: { (capabilities, error) in
            guard error == nil else { return }

            let capabilities = capabilities as! SPTAppRemoteUserCapabilities
            self.updateViewWithCapabilities(capabilities)
        })
    }

    private func subscribeToCapabilityChanges() {
        guard (!subscribedToCapabilities) else { return }
        appRemote?.userAPI?.delegate = self
        appRemote?.userAPI?.subscribe(toCapabilityChanges: { (success, error) in
            guard error == nil else { return }

            self.subscribedToCapabilities = true
            self.updateCapabilitiesSubscriptionButtonState()
        })
    }

    private func unsubscribeFromCapailityChanges() {
        guard (subscribedToCapabilities) else { return }
        appRemote?.userAPI?.unsubscribe(toCapabilityChanges: { (success, error) in
            guard error == nil else { return }

            self.subscribedToCapabilities = false
            self.updateCapabilitiesSubscriptionButtonState()
        })
    }
    
    func appRemoteConnecting() {
        //connectionIndicatorView.state = .connecting
    }

    func appRemoteConnected() {
        //connectionIndicatorView.state = .connected
        subscribeToPlayerState()
        subscribeToCapabilityChanges()
        getPlayerState()

        //enableInterface(true)
    }

    func appRemoteDisconnect() {
        //connectionIndicatorView.state = .disconnected
        self.subscribedToPlayerState = false
        self.subscribedToCapabilities = false
        //enableInterface(false)
    }
    
    @IBAction func playButtonPressed(){
        appRemote?.playerAPI?.play("spotify:track:4mL25h2hl6gdyu9tNTudnI", callback: defaultCallback)
    }
}

extension MusicViewController: SPTAppRemotePlayerStateDelegate {
       func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
           self.playerState = playerState
           updateViewWithPlayerState(playerState)
       }
}

extension MusicViewController: SPTAppRemoteUserAPIDelegate {
    func userAPI(_ userAPI: SPTAppRemoteUserAPI, didReceive capabilities: SPTAppRemoteUserCapabilities) {
        updateViewWithCapabilities(capabilities)
    }
}
