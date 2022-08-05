//
//  ContactFileManager.swift
//  ISP1002-FinalProject
//
//  Created by Aman on 05/08/22.
//

import Foundation

class ContactFileManager {
    
    static var shared = ContactFileManager()
    
    func filePath(key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".png")
    }
    
    func retrieveImage(key: String) -> Data? {
        if let filePath = ContactFileManager.shared.filePath(key: key),
            let fileData = FileManager.default.contents(atPath: filePath.path) {
            return fileData
        }
        return nil
    }
    
}
