//
//  Exercise+CoreDataProperties.swift
//  FitBeats
//
//  Created by Dillon Shipley on 11/28/20.
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
    @NSManaged public var parentWorkout: NSSet?

}

// MARK: Generated accessors for parentWorkout
extension Exercise {

    @objc(addParentWorkoutObject:)
    @NSManaged public func addToParentWorkout(_ value: Workout)

    @objc(removeParentWorkoutObject:)
    @NSManaged public func removeFromParentWorkout(_ value: Workout)

    @objc(addParentWorkout:)
    @NSManaged public func addToParentWorkout(_ values: NSSet)

    @objc(removeParentWorkout:)
    @NSManaged public func removeFromParentWorkout(_ values: NSSet)

}
