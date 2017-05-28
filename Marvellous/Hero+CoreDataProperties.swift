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
    @NSManaged public var appearsInComics: Comic?
    @NSManaged public var appearsInSeries: Series?

}
