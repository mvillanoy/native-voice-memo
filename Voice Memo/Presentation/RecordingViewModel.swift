//
//  RecordingViewModel.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import Foundation

class RecordingViewModel: ObservableObject {
    private let audioService = AudioService()
    var injected: DIContainer?
    @Published var isRecording = false
    @Published var duration: Int = 0
    @Published var recordingFilename: String = "New Recording"
    var timer: Timer?

    
    func setInjected(injected: DIContainer) {
        self.injected = injected
    }
    
    func startRecording() {
//        audioService.requestRecordPermission { granted in
//            
//        }
        //        audioService.requestRecordPermission()
        if let url = audioService.startRecording() {
            isRecording = true
            recordingFilename = url.lastPathComponent
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            _ in
                self.duration += 1
            }
            
        } else {
            print("error when starting recording")
        }
        
    }
    

    func stopRecording() {
        if let url = audioService.stopRecording() {
            // save recording
            recordingFilename = url.lastPathComponent
            isRecording = false
            self.injected?.voiceMemoUseCase.saveVoiceMemo(filename: recordingFilename, fileURL: url, duration: duration)
            reset()
        }
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        self.duration = 0
    }
}
