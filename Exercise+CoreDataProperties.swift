//
//  Exercise+CoreDataProperties.swift
//  FitBeats
//
//  Created by Adrian Rabadam on 11/30/20.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var intensity: Int32
    @NSManaged public var length: Int32
    @NSManaged public var name: String?
    @NSManaged public var parentWorkout: Workout?

}

extension Exercise : Identifiable {

}
