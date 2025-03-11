//
//  VoiceMemoRepository.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import SwiftData
import Foundation

class VoiceMemoRepository {
    private let context: ModelContext

        init(context: ModelContext) {
            self.context = context
        }
    
    func getVoiceMemos(query: String = "") -> [VoiceMemo] {
        var predicate: Predicate<VoiceMemo>? = nil
        if query.isEmpty {
            predicate = #Predicate<VoiceMemo> { $0.fileName.contains(query) }
        }
        let fetchDescriptor = FetchDescriptor<VoiceMemo>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch recordings: \(error)")
            return []
        }
    }
    
    func saveVoiceMemo(fileName: String, fileURL: URL, duration: Int) {
        let voiceMemo = VoiceMemo(fileName: fileName, fileURL: fileURL, duration: duration)
        context.insert(voiceMemo)
        
        print("saveVoiceMemo repository")
        do {
            try context.save()
            
        } catch {
            print("Failed to save recording: \(error)")
        }
        
    }

    func deleteVoiceMemo(_ voiceMemo: VoiceMemo) {
            do {
                try FileManager.default.removeItem(at: voiceMemo.fileURL)
                context.delete(voiceMemo)
                try context.save()
            } catch {
                print("Failed to delete recording: \(error)")
            }
        }
}
