//
//  ContactFileManager.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 05/08/22.
//

import Foundation

// This class handles saving and retreiving image from local file path
//
class ContactFileManager {

    // MARK: - Variables
    //
    // Signleton object of the class
    static var shared = ContactFileManager()
    
    // MARK: - Methods
    //
    // Method to provide path to file from local
    // param: key: String
    // return: URL
    //
    func filePath(key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    // This method retreives image data from desired path
    // param: key: String
    // return: Data
    //
    func retrieveImage(key: String) -> Data? {
        if let filePath = ContactFileManager.shared.filePath(key: key),
            let fileData = FileManager.default.contents(atPath: filePath.path) {
            return fileData
        }
        return nil
    }
    
}
