//
//  VoiceMemoUseCase.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import Foundation

class VoiceMemoUseCase {
    let repository: VoiceMemoRepository
    
    init(repository: VoiceMemoRepository) {
        self.repository = repository
    }
    
    func getVoiceMemos(query: String = "") -> [VoiceMemo] {
        repository.getVoiceMemos(query: query)
    }
    
    func saveVoiceMemo(filename: String, duration: TimeInterval) {
        repository.saveVoiceMemo(fileName: filename, duration: duration)
    }
    
    func deleteVoiceMemo(_ voiceMemo: VoiceMemo) {
        repository.deleteVoiceMemo(voiceMemo)
    }
}
