//
//  DateExtension.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 27/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import Foundation

import Foundation

extension String {

    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")-> Date?{

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)

        return date

    }
}

extension Date {

    func toString(withFormat format: String = "d MMMM yyyy") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)

        return str
    }
}
