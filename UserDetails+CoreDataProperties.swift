//
//  UserDetails+CoreDataProperties.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 26/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails")
    }

    @NSManaged public var isFavorite: Bool
    @NSManaged public var userCellNo: String?
    @NSManaged public var userDOB: Date?
    @NSManaged public var userFullName: String?
    @NSManaged public var userGender: String?
    @NSManaged public var userId: String?
    @NSManaged public var userImageURL: String?
    @NSManaged public var userLocation: String?
    @NSManaged public var userPassword: String?
    @NSManaged public var userPhoneNo: String?

}
