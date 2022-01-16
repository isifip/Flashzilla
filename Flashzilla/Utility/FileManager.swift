//
//  FileManager.swift
//  Flashzilla
//
//  Created by Irakli Sokhaneishvili on 15.01.22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
