//
//  ActiveExerciseCell.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/29/20.
//

import UIKit

class ActiveExerciseCell: UITableViewCell {

    var currentExercise : Exercise
    var timer : Timer? = nil
    
    
    @IBOutlet var exerciseName : UILabel!
    //@IBOutlet var exerciseSubtype : UILabel!
    @IBOutlet var timeRemaining : UILabel!
    
    var secondsLeft : Int {
        didSet {
            if(secondsLeft == 0){
                //nextExercise()
            }
            timeRemaining.text = "\(secondsLeft)"
        }
    }
    
    init(exercise : Exercise){
        self.currentExercise =  exercise
        self.exerciseName.text = currentExercise.name
        self.secondsLeft = Int(currentExercise.length)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            self.secondsLeft -= 1
        })
    }

}
