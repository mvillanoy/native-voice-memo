//
//  AudioService.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import AVFoundation

class AudioService: ObservableObject {
    var audioRecorder: AVAudioRecorder?
    var isRecording = false
    private var fileURL: URL?

    func requestRecordPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                
            } else {
                
            }
        }
    }
    
    func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
    }
    
    func startRecording() -> URL? {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP])
            try session.setActive(true)

            let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).m4a")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true
//            audioRecorder?.delegate = self
            audioRecorder?.record()

            isRecording = true
            fileURL = url
            return url
        } catch {
            print("Recording error: \(error.localizedDescription)")
            return nil
        }
    }

    func stopRecording() -> URL? {
            guard isRecording, let url = fileURL else { return nil }
            audioRecorder?.stop()
            isRecording = false
            return url
        }
    
    
    func playAudio() {
        
    }
    
    func pauseAudio() {
        
    }
    

}
