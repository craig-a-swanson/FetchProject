//
//  NetworkError.swift
//  FetchProject
//
//  Created by Craig Swanson on 7/5/24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidURLResponseCode
    case decodingError
    case mealNotAvailable
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The supplied URL was not valid."
        case .invalidURLResponseCode:
            return "There was a problem communicating with the server, please try again later."
        case .decodingError:
            return "There was an error reading the response from the server."
        case .mealNotAvailable:
            return "The meal was not found. Please try another one."
        }
    }
}
