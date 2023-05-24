//
//  ImageLoader.swift
//  WeatherApp
//
//  Created by Suchita Paleja on 5/24/23.
//


import Foundation
import UIKit

protocol ImageCacheType: AnyObject {
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
    func removeAllImages()
    subscript(_ url: URL) -> UIImage? { get set }
}

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache: ImageCacheType
    
    init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    func getImageFromUrl(_ urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(nil)
        }
        
        if let image = cache[url] {
            return completion(image)
        }
        
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                return completion(nil)
            }
            guard response != nil else {
                return completion(nil)
            }
            guard let imageData = data else { return completion(nil) }
            
            DispatchQueue.main.async {
                guard let image = UIImage(data: imageData) else { return }
                self.cache[url] = image
                completion(image)
            }
        }.resume()
    }
}

