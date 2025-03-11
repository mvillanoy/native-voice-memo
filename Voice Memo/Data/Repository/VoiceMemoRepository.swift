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
        // TODO: Search functionality
//        var predicate: Predicate<VoiceMemo>? = nil
//        if query.isEmpty {
//            predicate = #Predicate<VoiceMemo> { $0.fileName.contains(query) }
//        }
        let fetchDescriptor = FetchDescriptor<VoiceMemo>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch recordings: \(error)")
            return []
        }
    }
    
    func updateVoiceMemo(_ voiceMemo: VoiceMemo) {
        do {
            try context.save()
            
        } catch {
            print("Failed to save recording: \(error)")
        }
            
    }
    
    func getVoiceMemo(_ id: UUID) -> VoiceMemo? {
        let fetchDescriptor = FetchDescriptor<VoiceMemo>(
            predicate: #Predicate<VoiceMemo> { $0.id == id },
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        do {
            return try context.fetch(fetchDescriptor).first
        } catch {
            print("Failed to fetch recordings: \(error)")
            return nil
        }
    }
    
    func saveVoiceMemo(fileName: String, duration: TimeInterval) {
        let voiceMemo = VoiceMemo(fileName: fileName, duration: duration)
        context.insert(voiceMemo)
        
        print("saveVoiceMemo repository")
        do {
            try context.save()
            
        } catch {
            print("Failed to save recording: \(error)")
        }
        
    }

    func deleteVoiceMemo(_ voiceMemo: VoiceMemo) {
            context.delete(voiceMemo)
                do {
                    try context.save()
                    try FileManager.default.removeItem(at: FileUtilities.getDefaultDirectory(fileName: voiceMemo.fileName))
                } catch {
                    print("Failed to delete recording: \(error)")
                }
            }
        

        
}
