//
//  RecordingViewModel.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import Foundation
import SwiftData
import SwiftUI

class RecordingViewModel: ObservableObject {
    private let audioService = AudioService()
    
    @Published var voiceMemos: [VoiceMemo] = []
    @Published var isPlaying = false
    @Published var isRecording = false
    
    @Published var selectedVoiceMemo: VoiceMemo?
    @Published var duration: TimeInterval = 0
    @Published var playerDuration: TimeInterval = 0
    @Published var recordingFilename: String = "New Recording"
    
    var timer: Timer?

    var injected: DIContainer?
    
    init() {
        audioService.delegate = self
    }

    func setInjected(injected: DIContainer) {
        self.injected = injected
        getVoiceMemos()
    }
    
    func select(_ voiceMemo: VoiceMemo) {
        if voiceMemo.id != self.selectedVoiceMemo?.id {
            pauseVoiceMemo()
        }
        self.selectedVoiceMemo = voiceMemo

    }
    
    func getVoiceMemos() {
        voiceMemos = self.injected?.voiceMemoUseCase.getVoiceMemos() ?? []
     }
    
    func playVoiceMemo() {
        if let selectedVoiceMemo = selectedVoiceMemo {
            isPlaying = true
            audioService.playAudio(fileURL: FileUtilities.getDefaultDirectory(fileName: selectedVoiceMemo.fileName))
        }
    }
    
    func pauseVoiceMemo() {
        audioService.pauseAudio()
        isPlaying = false
    }
    
    func deleteVoiceMemo() {
        if let selectedVoiceMemo = selectedVoiceMemo {
            self.injected?.voiceMemoUseCase.deleteVoiceMemo(selectedVoiceMemo)
            self.getVoiceMemos()
        }
    }
    
    func rewindVoiceMemo() {
        
    }
    
    func fastForwardVoiceMemo() {
        
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
            recordingFilename = url.lastPathComponent
            isRecording = false
            self.injected?.voiceMemoUseCase.saveVoiceMemo(filename: recordingFilename, duration: duration)
            reset()
            self.getVoiceMemos()

        }
    }
    
    func reset() {
        timer?.invalidate()
        timer = nil
        self.duration = 0
    }
}

extension RecordingViewModel: AudioSeviceDelegate {
    func didFinishPlaying() {
        isPlaying = false
        reset()
    }
    
    
}

