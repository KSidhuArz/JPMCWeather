//
//  AppError.swift
//  WeatherJPMC
//
//  Created by Kulbir Singh on 9/11/24.
//

import Foundation

enum CustomError:Error{
    case networkResponseDecodingError
}

extension CustomError{
    var localizedDescription:String{
        switch self{
        case .networkResponseDecodingError:
            return "error while decoding"
        }
    }
}

enum NetworkError:Error {
    case invalidUrl
    case invalidResponse
    case clientError
    case serverError
}

extension NetworkError{
    var localizedDescription: String{
        switch self{
        case .invalidUrl:
            return "Invalid Url"
        case .invalidResponse:
            return "Invalid url response"
        case .clientError:
            return "Client error"
        case .serverError:
            return "Server error"
        }
    }
}
