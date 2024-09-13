//
//  MockApi.swift
//  WeatherJPMCTests
//
//  Created by Ramandeep Singh on 9/12/24.
//

import Foundation
@testable import JPMCWeather

class MockApi:NetworkProtocol{
    var isSuccess:Bool
    
    init(isSuccess:Bool = true) {
        self.isSuccess = isSuccess
    }
    
    func fetchRequest<T:Codable>(url: URL, type: T.Type) async throws -> T{
        if isSuccess {
            let weather = Weather(id: 1, main: "", description: "", icon: "")
            let data = Result(visibility: 12.0, name: "Dallas", weather: [weather])
            return try await MockApi.decodeData(data: JSONEncoder().encode(data))
        }else{
            throw NetworkError.invalidResponse
        }
    }
    
    static func decodeData<T:Codable>(data: Data) async throws -> T {
        do{
            return try JSONDecoder().decode(T.self, from: data)
        }catch{
            throw CustomError.networkResponseDecodingError
        }
    }
}
