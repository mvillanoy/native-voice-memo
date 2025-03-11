//
//  RecordingViewModel.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import Foundation

class RecordingViewModel: ObservableObject {
    private let audioService = AudioService()

    @Published var isRecording = false
    @Published var recordingTime: String = "00:00"
    @Published var recordingFilename: String = "New Recording"
    var timer: Timer?

    func startRecording() {
        //        audioService.requestRecordPermission()
        audioService.startRecording()
        isRecording = audioService.isRecording
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            [weak self] _ in

        }
    }

    func stopRecording() {
        audioService.stopRecording()
        isRecording = audioService.isRecording
    }
}
