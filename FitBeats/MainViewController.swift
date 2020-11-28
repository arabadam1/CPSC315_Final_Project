//
//  ViewController.swift
//  FitBeats
//
//  Created by Adrian Rabadam on 11/27/20.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if there is a valid identifier
        if let identifier = segue.identifier  {
            //and it is the appropriate segue for the detail screen
            if identifier == "BeginWorkoutSegue" {
    
            } else if identifier == "ChangeMusicSegue" {

            } else if identifier == "ChangeWorkoutSegue" {
                
            }
        }
    }
}

