//
//  RecordingListViewModel.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import Foundation
import SwiftData
import SwiftUI

class RecordingListViewModel: ObservableObject {
//    @Published var voiceMemos: [VoiceMemo] = []
    @Query(sort: \VoiceMemo.timestamp, order: .reverse) var voiceMemos: [VoiceMemo] = []

    var injected: DIContainer?

    func setInjected(injected: DIContainer) {
        self.injected = injected
        getVoiceMemos()
    }
    
    func getVoiceMemos() {
//        voiceMemos = self.injected?.voiceMemoUseCase.getVoiceMemos() ?? []
//        print("getVoiceMemos \(voiceMemos.count)")
     }
    
    func playVoiceMemo() {
        
    }
    
    func pauseVoiceMemo() {
        
    }
    
    func deleteVoiceMemo(_ voiceMemo: VoiceMemo) {
        self.injected?.voiceMemoUseCase.deleteVoiceMemo(voiceMemo)
//        getVoiceMemos()
    }
}
