//
//  Book+CoreDataProperties.swift
//  CoreData-2
//
//  Created by Марк Фокша on 26.09.2023.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var name: String?
    @NSManaged public var owner: User?

}

extension Book : Identifiable {

}
