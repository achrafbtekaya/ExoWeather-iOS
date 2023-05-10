//
//  Weather.swift
//  ExoWeather
//
//  Created by Achref Ben Tekaya on 9/5/2023.
//

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
    
}

// MARK: - Main
struct Main: Decodable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}
