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
    
    @Published var recordingFilename: String = "New Recording"
    
    var timer: Timer?
    @Published var playerDuration: TimeInterval = 0
    
    @Published var error: String?


    var injected: DIContainer?
    
    init() {
        audioService.delegate = self
    }

    func setInjected(injected: DIContainer) {
        self.injected = injected
        getVoiceMemos()
    }
    
    func getVoiceMemos() {
        voiceMemos = self.injected?.voiceMemoUseCase.getVoiceMemos() ?? []
     }
    
    
    // playback functions
    func selectVoiceMemo(_ voiceMemo: VoiceMemo) {
        if voiceMemo.id != self.selectedVoiceMemo?.id {
            stopVoiceMemo()
        }
        self.selectedVoiceMemo = voiceMemo
        audioService.loadAudio(from: FileUtilities.getDefaultDirectory(fileName: self.selectedVoiceMemo!.fileName))
    }
    
    func playPauseVoiceMemo() {
        if isPlaying {
            audioService.pauseAudio()
            isPlaying = false
            stopTimer()
        } else {
            audioService.playAudio()
            isPlaying = true
            startTimer()
        }
    }
    
    func stopVoiceMemo() {
        audioService.stopAudio()
        isPlaying = false
        reset()
    }

    func seekVoiceMemo(to time: TimeInterval) {
        self.playerDuration = time
        audioService.playAudio(seekTo: time)
    }
    
    private func startTimer() {
          stopTimer()
          timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
              self.playerDuration += 1
          }
        
      }

      private func stopTimer() {
          timer?.invalidate()
          timer = nil
      }
    
    func deleteVoiceMemo() {
        if let selectedVoiceMemo = selectedVoiceMemo {
            self.injected?.voiceMemoUseCase.deleteVoiceMemo(selectedVoiceMemo)
            self.getVoiceMemos()
        }
    }
    
    func rewindVoiceMemo() {
        
        self.playerDuration = self.playerDuration > 15 ? self.playerDuration - 15 : 0
        audioService.playAudio(seekTo: playerDuration)
    }
    
    func fastForwardVoiceMemo() {
        if let selectedVoiceMemo = selectedVoiceMemo {
            self.playerDuration = (self.playerDuration + 15) < selectedVoiceMemo.duration ? self.playerDuration + 15 : selectedVoiceMemo.duration
            audioService.playAudio(seekTo: playerDuration)
        }
        
    }
    
    
    func startRecording() {
        stopVoiceMemo()
        
        audioService.requestRecordPermission { granted in
            DispatchQueue.main.async() {
                if granted {
                    if let url = self.audioService.startRecording() {
                        self.isRecording = true
                        self.recordingFilename = url.lastPathComponent
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                            _ in
                            self.duration += 1
                        }
                    } else {
                        self.error = "Unable to start recording"
                    }
                } else {
                    self.error = "Permission denied to record audio"
                    
                }
            }
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
        self.playerDuration = 0
    }
}

extension RecordingViewModel: AudioSeviceDelegate {
    func didFinishPlaying() {
        isPlaying = false
        reset()
    }
    
    
}

