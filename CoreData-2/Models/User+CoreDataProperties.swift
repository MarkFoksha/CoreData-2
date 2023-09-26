//
//  User+CoreDataProperties.swift
//  CoreData-2
//
//  Created by Марк Фокша on 26.09.2023.
//
//

import Foundation
import CoreData
import UIKit


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var avatar: UIImage?
    @NSManaged public var book: Book?

}

extension User : Identifiable {

}
