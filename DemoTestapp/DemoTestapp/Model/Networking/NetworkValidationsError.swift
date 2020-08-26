//
//  NetworkValidationsError.swift
//  DemoTestapp
//
//  Created by Prashanth reddy on 8/26/20.
//  Copyright © 2020 Prashanth reddy. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case fetch
    case parse
    case badRequest
    case nointernetConnection
    func errorDescription() -> String {
        switch self {
        case .fetch:
            return "Failed in fetching the records."
        case .parse:
            return "Failed in fetching the records."
        case .badRequest:
            return "Bad request"
        case .nointernetConnection:
            return "No Internet Connection"
        }
    }
}
