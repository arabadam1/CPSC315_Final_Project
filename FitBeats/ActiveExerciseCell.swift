//
//  ActiveExerciseCell.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/29/20.
//

import UIKit

class ActiveExerciseCell: UITableViewCell {

    var currentExercise : Exercise
    
    @IBOutlet var exerciseName : UILabel = currentExercise.name!
    @IBOutlet var exerciseSubtype : UILabel!
    @IBOutlet var timeRemaining : UILabel!
    
    var secondsLeft : Int = currentExercise.length {
        didSet {
            if(secondsLeft == 0){
                //nextExercise()
            }
            timeRemaining.text = "\(secondsLeft)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startTimer () {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.seconds -= 1
        })
    }

}
