//
//  Utility.swift
//  WeatherApp
//
//  Created by Suchita Paleja on 5/24/23.
//

import Foundation
import UIKit

class Utility  {
    
    //MARK: - User Defaults
    static func setUserDefaults(value:Any?, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func getUserDefaults(key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key)
    }
    
    static func removeUserDefaults(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
    
}
