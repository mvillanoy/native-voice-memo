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
    @Published var playerDuration: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var recordingFilename: String = "New Recording"
    @Published var error: String?
    var timer: Timer?

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
        
        if selectedVoiceMemo == nil, !voiceMemos.isEmpty {
            selectVoiceMemo(voiceMemos.first!)
        }
    }

    func deleteVoiceMemo() {
        if let selectedVoiceMemo = selectedVoiceMemo {
            self.injected?.voiceMemoUseCase.deleteVoiceMemo(selectedVoiceMemo)
            self.getVoiceMemos()
        }
    }

    // playback functions
    func selectVoiceMemo(_ voiceMemo: VoiceMemo) {
        if voiceMemo.id != self.selectedVoiceMemo?.id {
            stopVoiceMemo()
            
        }
        self.selectedVoiceMemo = voiceMemo
        audioService.loadAudio(
            from: FileUtilities.getDefaultDirectory(
                fileName: self.selectedVoiceMemo!.fileName))
    }

    func playPauseVoiceMemo() {
        if isPlaying {
            audioService.pauseAudio()
            isPlaying = false
            stopPlaybackTimer()
        } else {
            audioService.playAudio()
            isPlaying = true
            startPlaybackTimer()
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

    private func startPlaybackTimer() {
        stopPlaybackTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.playerDuration += 1
        }
    }

    private func stopPlaybackTimer() {
        timer?.invalidate()
        timer = nil
    }

    func rewindVoiceMemo() {
        self.playerDuration =
            self.playerDuration > 15 ? self.playerDuration - 15 : 0
        audioService.playAudio(seekTo: playerDuration)
    }

    func fastForwardVoiceMemo() {
        if let selectedVoiceMemo = selectedVoiceMemo {
            self.playerDuration =
                (self.playerDuration + 15) < selectedVoiceMemo.duration
                ? self.playerDuration + 15 : selectedVoiceMemo.duration
            audioService.playAudio(seekTo: playerDuration)
        }
    }

    // record functions
    func startRecording() {
        self.selectedVoiceMemo = nil
        stopVoiceMemo()
        audioService.requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    if let url = self.audioService.startRecording() {
                        self.isRecording = true
                        self.recordingFilename = url.lastPathComponent
                        self.reset()
                        self.timer = Timer.scheduledTimer(
                            withTimeInterval: 1, repeats: true
                        ) {
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
            self.injected?.voiceMemoUseCase.saveVoiceMemo(
                filename: recordingFilename, duration: duration)
            self.getVoiceMemos()
            
        } else {
            self.error = "Unable to save recording"
        }
        
        isRecording = false
        reset()
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
