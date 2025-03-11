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
    var timestamp: Date
    var duration: TimeInterval
    
    init(fileName: String, duration: TimeInterval = 0) {
        self.id = UUID()
        self.fileName = fileName
        self.timestamp = Date()
        self.duration = duration
    }
}
