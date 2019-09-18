//
//  UIImageView+Extension.swift
//  eTreatMD_Exercise
//
//  Created by Jason Li on 2019-09-18.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImage(withURLString urlString: String, withDefaultImage defaultImage: UIImage? = nil, completion: @escaping (_ success: Bool) -> () = { _ in }) {
        image = nil
        
        guard let url = URL(string: urlString) else {
            image = defaultImage
            completion(false)
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = imageFromCache
            completion(true)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let `self` = self else { return }
            
            if let data = data, let imageToCache = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    self.image = imageToCache
                    completion(true)
                }
            } else {
                DispatchQueue.main.async {
                    self.image = defaultImage
                    completion(false)
                }
            }
            }.resume()
    }
}
