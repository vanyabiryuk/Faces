//
//  FileManager-ImageSaver.swift
//  Faces
//
//  Created by Vanüsha on 17.08.2022.
//

import UIKit

extension FileManager {
    static var documentDirectoryURL: URL? {
        let paths = self.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    static func documentDirectoryURL(appending pathComponent: String) -> URL? {
        self.documentDirectoryURL?.appendingPathComponent(pathComponent)
    }
    
    static func save(_ image: UIImage, to fileName: String) {
        guard let url = self.documentDirectoryURL(appending: fileName) else {
            print("Failed to create Document Directory URL while saving an image.")
            return
        }
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to generate Data object while saving an image.")
            return
        }
        
        do {
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to write data to file while saving an image.\n",
                  error.localizedDescription)
        }
    }
    
    static func loadImage(from fileName: String) -> UIImage? {
        guard let url = self.documentDirectoryURL(appending: fileName) else {
            print("Failed to create Document Directory URL while loading an image.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print("Failed to read data from file while loading an image.\n",
                  error.localizedDescription)
            return nil
        }
    }
    
    static func save<T>(_ object: T, to fileName: String) where T: Encodable {
        guard let url = self.documentDirectoryURL(appending: fileName) else {
            print("Failed to create Documents Directory URL while saving an object.")
            return
        }
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Failed to (encode data / write encoded data to file) while saving an object.\n",
                  error.localizedDescription)
        }
    }
    
    static func loadObject<T>(from fileName: String) -> T? where T: Decodable {
        guard let url = self.documentDirectoryURL(appending: fileName) else {
            print("Failed to create Document Directory URL while loading an object.")
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            print("Failed to (read data from file / decode read data) while loading an object.\n",
                  error.localizedDescription)
            return nil
        }
    }
}
