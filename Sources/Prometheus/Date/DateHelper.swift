//
//  DateHelper.swift
//  
//
//  Created by Adrian Haubrich on 20.10.21.
//

import Foundation

public struct DateHelper {}

//  MARK: - Date <-> String
extension DateHelper {
    
    /// Transforms a Date to a String (dd.MM.yy, HH:mm).
    ///
    /// The result format is a quite user friendly format that should be used to display date and time information to the user.
    ///
    /// - Parameter date: A Date containing date & time information.
    /// - Returns: "dd.MM.yy, HH:mm"
    public static func string(from date: Date) -> String {
        let format = "dd.MM.yy, HH:mm"
        return DateHelper.string(from: date, in: format)
    }
    
    /// Transforms a String in the specifig format "dd.MM.yy, HH:mm" into a Date.
    ///
    /// - Parameter dateString: A String containing date & time information.
    /// - Returns: A Date-object containing the date & time informations of the input String.
    public static func date(from string: String) throws -> Date {
        let format = "dd.MM.yy, HH:mm"
        do {
            return try date(from: string, in: format)
        } catch {
            throw DateConversionError.invalidString
        }
    }
    
}

// MARK: - dateAndTimeString -> (dateString, timeString)
extension DateHelper {
    
    /// Splits the date & time informations of a single String into two.
    ///
    /// - Parameter dateAndTime: A String containing date & time information.
    /// - Returns: A tuple containing two Strings. The first one contains the date and the second one the time. Both in a user friendly way.
    public static func splitDateAndTimeString(dateAndTime: String) throws -> (String, String) {
        
        let components = dateAndTime.components(separatedBy: ",")
        
        if components.count >= 2 {
            let dateString = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let timeString = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            return ("\(dateString)", "\(timeString)")
        }
        
        throw DateConversionError.invalidSplit
    }
    
}

// MARK: - Database
extension DateHelper {
    
    public static func dbString(from date: Date) -> String {
        let format = "yyyy.MM.dd, HH.mm.ss.SSS"
        return DateHelper.string(from: date, in: format)
    }
    
    public static func dbDate(from dbString: String) throws -> Date {
        let format = "yyyy.MM.dd, HH.mm.ss.SSS"
        do {
            return try date(from: dbString, in: format)
        } catch {
            throw DateConversionError.invalidString
        }
    }
    
}

// MARK: - Helper
extension DateHelper {
    
    private static func string(from date: Date, in format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    private static func date(from string: String, in format: String) throws -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: string) {
            return date
        } else {
            // Error
            if string == "" {
                throw DateConversionError.empty
            } else {
                throw DateConversionError.invalidString
            }
        }
    }
    
}


// MARK: - Date
extension Date {
    
    /// Rounds a date to the nearest hour.
    /// - Returns: The date
    public func nearestHour() -> Date {
        return Date(timeIntervalSinceReferenceDate:
                        (timeIntervalSinceReferenceDate / 3600.0).rounded(.toNearestOrEven) * 3600.0)
    }
}
