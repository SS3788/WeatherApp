//
//  ViewController.swift
//  WeatherApp
//
//  Created by Suchita Paleja on 5/22/23.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
   
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var todayHighLowLabel: UILabel!
    
    @IBOutlet weak var iconimageView: UIImageView!
    
    var apiManager = APIManager()
    
    //Create a instance of LocationManager and assign a deleget
    let locationManager = CLLocationManager()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign delegates to confirm Protocol
        apiManager.delegate = self
        searchTextField.delegate = self
        
        intitializeLocationUpdate()
       
    }

    // MARK: - SEARCH button Action
    @IBAction func searchButtonTap(sender : UIButton) {
        if(searchTextField.text != nil) {
            apiManager.getWeatherByCity(cityName: searchTextField.text!)
            if(searchTextField.text!.isEmpty == false){
                //Remove last stored Search
                Utility.removeUserDefaults(key: StringConstant.DEFAULTS_LAST_SEARCH_CITY)
                
                //Store recent Search
                Utility.setUserDefaults(value: searchTextField.text, key: StringConstant.DEFAULTS_LAST_SEARCH_CITY)
            }
            searchTextField.text = ""
            searchTextField.endEditing(true)
        }
    }
    
    // MARK: - Request Location Access
    func intitializeLocationUpdate() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
  
}


// MARK: - UITextField Delegate methods
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.endEditing(true)
            return true
    }
}

// MARK: - CLLocationManagerDelegate methods
extension ViewController: CLLocationManagerDelegate {
   
    // This is called if:
    // the location manager is updating, and
    // it was able to get the user's location.
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = locations.last {
          
          // Check for last search city
          // If last search city name found in defaults, call api to get weather of that city
          // Else call api to get weather of current location
          if(Utility.getUserDefaults(key: StringConstant.DEFAULTS_LAST_SEARCH_CITY) != nil) {
              let lastSearchCity = Utility.getUserDefaults(key: StringConstant.DEFAULTS_LAST_SEARCH_CITY) as! String
              apiManager.getWeatherByCity(cityName: lastSearchCity)
          } else {
              apiManager.getWeatherByCordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
          }
      }
      
    }
    
    // This is called if:
    // the location manager is updating, and
    // it is not able to get the user's location.
  private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
      print("Error: \(error)")
    }
}

// MARK: - WeatherManagerDelegate
extension ViewController: APIManagerDelegate {
    
    func didFailWithError(error: NetworkError) {
        Utility.removeUserDefaults(key: StringConstant.DEFAULTS_LAST_SEARCH_CITY)
    }
    
    func didUpdateWeather(weather: WeatherData) {
        DispatchQueue.main.async {
            self.searchTextField.text = ""
            self.cityNameLabel.text = weather.cityName
            self.currentTempLabel.text = NSString(format: "%@%@",weather.temperatureString,"\u{00B0}")as String
            self.todayHighLowLabel.text = NSString(format: "H:%@%@  L:%@%@",weather.highTemperatureString,"\u{00B0}",weather.lowTemperatureString,"\u{00B0}")as String
            if let icon = weather.icon {
                print("https://openweathermap.org/img/wn\(icon)@2x.png")
                self.iconimageView.getImageFromUrl("https://openweathermap.org/img/wn/\(icon)@2x.png")
            }
        }
    }
}

