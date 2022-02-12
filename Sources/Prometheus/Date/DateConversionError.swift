//
//  File.swift
//  
//
//  Created by Adrian Haubrich on 21.10.21.
//

import Foundation

enum DateConversionError: String, Error {
    case invalidString = "Failed to convert string to date. The string has most likely an invalid format."
    case empty = "Input is empty."
    case invalidSplit = "Failed to split the date-and-time-string in it's components. The string has most likely an invalid format."
}
