//
//  ImageHelper.swift
//  Till
//
//  Created by Isis Ramirez on 18/10/19.
//  Copyright © 2019 Isis Ramirez. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper: UIViewController {
    public func saveImage(image: UIImage) -> String {
        let hash =  NSUUID().uuidString

        if let data = image.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent("\(hash).jpeg")
                try? data.write(to: filename)
            }
        return "\(hash).jpeg"
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            guard let image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path) else {
                return getRandomDefaultImage()
            }
            return image
        }
        return getRandomDefaultImage()
    }
    
    func getRandomDefaultImage() -> UIImage {
        let number = Int.random(in: 1 ... 5)
        return UIImage(named: "defaultBackground\(number)")!
    }
}
