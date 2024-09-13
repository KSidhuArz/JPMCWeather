//
//  NetworkManager.swift
//  WeatherJPMC
//
//  Created by Kulbir Singh on 9/11/24.
//

import Foundation

final class NetworkManager:NetworkProtocol{
    func fetchRequest<T:Codable>(url:URL, type:T.Type) async throws -> T{
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode{
        case 200..<300:
            return try await NetworkManager.decodeData(data: data)
        case 400..<499:
            throw NetworkError.clientError
        case 500..<599:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }
    
    static func decodeData<T:Codable>(data:Data) async throws-> T{
        do{
            return try JSONDecoder().decode(T.self, from: data)
        }catch{
            throw CustomError.networkResponseDecodingError
        }
    }
}
