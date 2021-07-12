//
//  Extensions.swift
//

import UIKit
import Foundation


//MARK:- Extension
extension UIImageView {
    
    func downloadImage(link: String, placeholder: String) {
        
        if let cachedImage = imageCache.object(forKey: link as NSString) {
            self.image = cachedImage
        } else {
            
            if URL.init(string: link) != nil {
                URLSession.shared.dataTask(with: URL.init(string: link)!) { (data, response, error) in
                    
                    DispatchQueue.main.async { [weak self] in
                        if error != nil {
                            self?.image = UIImage.init(named: placeholder)
                        } else if let data = data, let image = UIImage(data: data) {
                            imageCache.setObject(image, forKey: link as NSString)
                            self?.image = UIImage(data: data)
                        } else {
                            self?.image = UIImage.init(named: placeholder)
                        }
                    }
                }.resume()
            } else {
                self.image = UIImage.init(named: placeholder)
            }
        }
    }
}

