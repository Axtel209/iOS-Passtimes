//
//  CalendarUtils.swift
//  Passtimes
//
//  Created by Giorgio Doganiero on 10/19/18.
//  Copyright © 2018 passtimes. All rights reserved.
//

import Foundation

class CalendarUtils {

    // Returns Month as String from a timestamp
    public static func getMonthFromDateTimestamp(_ millis: Int) -> String {
        let date = Date(timeIntervalSince1970: (Double)(millis / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: date)
    }

    // Returns Day as String from a timestamp
    public static func getDayFromDateTimestamp(_ millis: Int) -> String {
        let date = Date(timeIntervalSince1970: (Double)(millis / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: date)
    }

    // Returns Day Hours and Minutes as String from a timestamp
    public static func getTimeFromDateTimestamp(_ millis: Int) -> String {
        let date = Date(timeIntervalSince1970: (Double)(millis / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE hh:mm aa"
        return dateFormatter.string(from: date)
    }

    public static func getHoursFromDateTimestamo(_ millis: Int) -> String {
        let date = Date(timeIntervalSince1970: (Double)(millis / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm aa"
        return dateFormatter.string(from: date)
    }

    // Returns Starting HoursMinutes and Ending HoursMinutes as String from a timestamp
    public static func getStartEndTimefromDateTimestamp(startTime startMillis: Int, endTime endMillis: Int) -> String {
        let dateFormatter = DateFormatter()
        let startDate = Date(timeIntervalSince1970: (Double)(startMillis / 1000))
        let endDate = Date(timeIntervalSince1970: (Double)(endMillis / 1000))
        dateFormatter.dateFormat = "hh:mm aa"

        return dateFormatter.string(from: startDate) + " - " + dateFormatter.string(from: endDate)
    }

    public static func getFirstWeekday() -> UInt {
        return UInt(Calendar.current.component(.weekday, from: Date()))
    }

}
