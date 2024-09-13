//
//  Weather.swift
//  WeatherJPMC
//
//  Created by Kulbir Singh on 9/11/24.
//

import Foundation

struct Result: Codable{
    let visibility: Double
    let name: String
    let weather:[Weather]
}

struct Weather:Codable{
    let id: Int
    let main: String?
    let description: String?
    let icon: String?
}

