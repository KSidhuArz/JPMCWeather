//
//  NetworkProtocol.swift
//  WeatherJPMC
//
//  Created by Kulbir Singh on 9/11/24.
//

import Foundation

///This protocol is using  for dependency injection 
protocol NetworkProtocol{
    func fetchRequest<T:Codable>(url:URL, type:T.Type) async throws -> T
    static func decodeData<T:Codable>(data:Data) async throws-> T
}
