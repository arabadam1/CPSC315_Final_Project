//
//  ExerciseTableViewCell.swift
//  FitBeats
//
//  Created by Adrian Rabadam on 11/30/20.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    @IBOutlet var exerciseTitle : UILabel!
    @IBOutlet var lengthLabel : UILabel!
    @IBOutlet var intensityLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with exercise: Exercise) {
        exerciseTitle.text = exercise.name
        lengthLabel.text = "\(String(exercise.length))s"
        var icon: String = ""
        if Int32(exercise.intensity) < 5 {
            icon = "💧"
        }
        else if Int32(exercise.intensity) < 8 {
            icon = "⚡️"
        }
        else if Int32(exercise.intensity) <= 10 {
            icon = "🔥"
        }
        intensityLabel.text = String(exercise.intensity) + icon
    }
}
