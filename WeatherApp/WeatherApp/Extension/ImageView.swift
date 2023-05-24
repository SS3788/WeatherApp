//
//  ImageView.swift
//  WeatherApp
//
//  Created by Suchita Paleja on 5/24/23.
//

import Foundation
import UIKit

extension UIImageView {
    func getImageFromUrl(_ url: String) {
        ImageLoader.shared.getImageFromUrl(url) { image in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

