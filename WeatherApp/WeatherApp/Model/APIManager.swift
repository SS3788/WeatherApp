//
//  File.swift
//  WeatherApp
//
//  Created by Suchita Paleja on 5/22/23.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case domainError
    case urlError
    case noInternerConnection
    case jsonResponse(response: Data)
}

protocol APIManagerDelegate : AnyObject {
    func didUpdateWeather(weather: WeatherData)
    func didFailWithError(error: NetworkError)
}


class APIManager {

    var delegate: APIManagerDelegate?
    
    //define API Key and URLs
    private let apiKey = StringConstant.DEFAULTS_API_KEY
    private let apiURL = StringConstant.DEFAULTS_BASE_URL
    private let geoURL = StringConstant.DEFAULTS_BASE_URL_GEO
    
    //GeoCoder API Call to get lat and long from City
    func getWeatherByCity(cityName: String)   {
//        let parseURL = "\(apiURL)q=\(cityName)&appid=\(apiKey)"
       let parseURL = "\(geoURL)\(cityName)&limit=1&appid=\(apiKey)"
        getCurrentWeather(urlString: parseURL, isByLatLon: false)
    }
    
    //API Call to get Weather data by lat and long
    func getWeatherByCordinates(lat: Double, lon: Double)   {
        let parseURL = "\(apiURL)lat=\(lat)&lon=\(lon)&appid=\(apiKey)"
        getCurrentWeather(urlString: parseURL, isByLatLon: true)
    }
    
    //Get Weather details
    func getCurrentWeather(urlString: String, isByLatLon: Bool)   {
        
        //Check internet connection
        if !Reachability.isConnectedToNetwork() {
            self.delegate?.didFailWithError(error: .noInternerConnection )
        }
      
        //Remove White Spaces
        let alteredUrlString  = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        //Create URL
        let url = URL(string: alteredUrlString!);
    
        //Create URL Session
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                self.delegate?.didFailWithError(error: .domainError)
                return
            }
            
            if error != nil {
                self.delegate?.didFailWithError(error: .domainError)
            } else if let data = data {
                if 200 ... 299 ~= httpResponse.statusCode {
                    if(!isByLatLon) {
                        let result = try? JSONDecoder().decode([Coord].self, from: data)
                        if let result = result {
                            if(result.description == "[]"){
                                return
                            }
                            self.getWeatherByCordinates(lat: result[0].lat, lon: result[0].lon)
                        } else {
                            self.delegate?.didFailWithError(error: .decodingError)
                        }
                    } else {
                        let result = try? JSONDecoder().decode(CurrentWeather.self, from: data)
                        if let result = result {

                            //Convert JSON response to Weather object
                            let weather = WeatherData(sunRiseSeconds: TimeInterval(result.sys.sunrise), sunSetSeconds: TimeInterval(result.sys.sunset), description: result.weather[0].description, cityName: result.name, conditionID: result.weather[0].id, icon: result.weather[0].icon, temperature: result.main.temp,highTemperature: result.main.tempMax, lowTemperature: result.main.tempMin,humidity: result.main.humidity, wind: result.wind.speed)
                            self.delegate?.didUpdateWeather(weather: weather)
                        } else {
                            self.delegate?.didFailWithError(error: .decodingError)
                        }
                    }

                } else {
                    //completion(.failure(.jsonResponse(response: data)))
                    self.delegate?.didFailWithError(error: .jsonResponse(response: data))
                }
            }
         
        })
        task.resume()
    }
}
