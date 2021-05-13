//
//  ImageStore.swift
//  RickAndMortyWidgetExtension
//
//  Created by Alperen Ünal on 13.05.2021.
//

import UIKit

class ImageStore {
    
    func saveImage(_ image: UIImage, forKey key: String) {
        guard let imageData = image.pngData() else { return }
        
        if let filePath = filePath(forKey: key) {
            do  {
                try imageData.write(to: filePath,
                                    options: .atomic)
            } catch let err {
                print("Saving file resulted in error: ", err)
            }
        }
    }
    
    func retrieveImage(forKey key: String) -> UIImage? {
        if let filePath = self.filePath(forKey: key),
           let fileData = FileManager.default.contents(atPath: filePath.path),
           let image = UIImage(data: fileData) {
            return image
        } else {
            return nil
        }
    }
    
    private func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        print(documentURL.appendingPathComponent(key + ".png"))
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
}
