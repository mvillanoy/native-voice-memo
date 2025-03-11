//
//  VoiceMemo.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/10/25.
//

import Foundation
import SwiftData

@Model
final class VoiceMemo {
    @Attribute(.unique) var id: UUID
    var fileName: String
    var fileURL: URL?
    var timestamp: Date
    
    init(fileName: String, fileURL: URL? = nil) {
        self.id = UUID()
        self.fileName = fileName
        self.fileURL = fileURL
        self.timestamp = Date()
    }
}
