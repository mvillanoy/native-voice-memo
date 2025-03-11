//
//  AudioService.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import AVFoundation

protocol AudioSeviceDelegate {
    func didFinishPlaying()
    
}

class AudioService: NSObject {

    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var delegate: AudioSeviceDelegate?

    var isRecording = false
    var isPlaying = false

    

    private var fileURL: URL?

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        switch type {
        case .began:
            print("Recording interrupted (e.g., phone call). Pausing...")
            audioRecorder?.pause()
        case .ended:
            print("Interruption ended. Resuming recording...")
            audioRecorder?.record()
        default:
            break
        }
    }
   
    func requestRecordPermission(completion: @escaping (Bool) -> Void) {
        if AVAudioApplication.shared.recordPermission == .granted {
            completion(true)
        } else {
            AVAudioApplication.requestRecordPermission { granted in
                completion(granted)
            }
        }
       
    }

    func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .default)
        try audioSession.setActive(true)
    }

    func startRecording(fileName: String? = nil) -> URL? {
        let session = AVAudioSession.sharedInstance()
        var name = fileName
        if name == nil {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYYMMddHHmmss"
            name = "Voice Recording \(dateFormatter.string(from: date)).m4a"
        }
        do {
            try session.setCategory(
                .playAndRecord, mode: .default,
                options: [
                    .defaultToSpeaker, .allowBluetooth, .allowBluetoothA2DP,
                ])
            try session.setActive(true)

            let url = FileUtilities.getDefaultDirectory(
                fileName: name ?? "Voice Recording")
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            ]

            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.isMeteringEnabled = true
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
    
    func loadAudio(from fileURL: URL) {
          do {
              audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
              audioPlayer?.delegate = self
              audioPlayer?.prepareToPlay()
          } catch {
              print("Error loading audio: \(error)")
          }
      }

    func playAudio(seekTo: TimeInterval? = nil) {
        if let seekTo = seekTo {
            audioPlayer?.play(atTime: seekTo)
        } else {
            audioPlayer?.play()
        }
    }

    func pauseAudio() {

        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stopAudio() {

        audioPlayer?.stop()
        isPlaying = false
    }

    func getCurrentPosition() -> TimeInterval {
        return audioPlayer?.currentTime ?? 0

    }
    
    func seekTo(_ timeInterval: TimeInterval) {
        audioPlayer?.currentTime = timeInterval
    }

}

extension AudioService: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer, successfully flag: Bool
    ) {
        isPlaying = false
        self.delegate?.didFinishPlaying()
        self.fileURL = nil
    }
}
