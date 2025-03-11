//
//  DateUtilities.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

class DateUtilities {
    static func formatTime(_ time: Int) -> String {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
}
