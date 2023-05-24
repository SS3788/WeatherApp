//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Suchita Paleja on 5/23/23.
//

import Foundation
struct WeatherData {
    // MARK: - sunrise
    let sunRiseSeconds: TimeInterval
    var sunRiseString: String {
        let time = Date(timeIntervalSince1970: sunRiseSeconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
    // MARK: - sunset
    let sunSetSeconds: TimeInterval
    var sunSetString: String {
        let time = Date(timeIntervalSince1970: sunSetSeconds)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time)
    }
    // MARK: - description & city
    let description: String
    let cityName: String
    
    // MARK: - id and related icon
    let conditionID: Int
    var icon: String?
    // MARK: - temperature, high temperature, low temprature, humidity and Wind speed
    let temperature: Double
    var temperatureString: String {
        String(format: "%0.0f", temperature)
    }
    let highTemperature: Double
    var highTemperatureString: String {
        String(format: "%0.0f", highTemperature)
    }
    let lowTemperature: Double
    var lowTemperatureString: String {
        String(format: "%0.0f", lowTemperature)
    }
    let humidity: Int
    var humidityString: String {
        return "\(humidity)%"
    }
    let wind: Double
    var windSpeedString: String {
        String(format: "%0.0hu/h", wind)
    }
}
