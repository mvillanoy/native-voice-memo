//
//  FileUtilities.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import Foundation

class FileUtilities {
    static func getDefaultDirectory(fileName: String) -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!

        let url = documentsDirectory.appendingPathComponent(fileName)
        return url
    }
}
