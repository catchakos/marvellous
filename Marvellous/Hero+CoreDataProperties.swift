//
//  Hero+CoreDataProperties.swift
//  Marvellous
//
//  Created by Alexandros Katsaprakakis on 28/05/2017.
//  Copyright © 2017 Alexandros Katsaprakakis. All rights reserved.
//

import Foundation
import CoreData


extension Hero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero")
    }

    @NSManaged public var desc: String?
    @NSManaged public var identifier: Int64
    @NSManaged public var modified: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var thumbnailUrl: String?
    
    @NSManaged public var appearsInComics: NSSet?
    @NSManaged public var appearsInSeries: NSSet?
}

// MARK: Generated accessors for appearsInComics
extension Hero {
    
    @objc(addAppearsInComicsObject:)
    @NSManaged public func addToAppearsInComics(_ value: Comic)
    
    @objc(removeAppearsInComicsObject:)
    @NSManaged public func removeFromAppearsInComics(_ value: Comic)
    
    @objc(addAppearsInComics:)
    @NSManaged public func addToAppearsInComics(_ values: NSSet)
    
    @objc(removeAppearsInComics:)
    @NSManaged public func removeFromAppearsInComics(_ values: NSSet)
    
}

// MARK: Generated accessors for appearsInSeries
extension Hero {
    
    @objc(addAppearsInSeriesObject:)
    @NSManaged public func addToAppearsInSeries(_ value: Series)
    
    @objc(removeAppearsInSeriesObject:)
    @NSManaged public func removeFromAppearsInSeries(_ value: Series)
    
    @objc(addAppearsInSeries:)
    @NSManaged public func addToAppearsInSeries(_ values: NSSet)
    
    @objc(removeAppearsInSeries:)
    @NSManaged public func removeFromAppearsInSeries(_ values: NSSet)
    
}
