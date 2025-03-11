//
//  Voice_MemoApp.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/10/25.
//

import SwiftUI
import SwiftData

@main
struct Voice_MemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            VoiceMemo.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
        
        let diContainer: DIContainer
    
        init() {
            self.diContainer = DIContainer(container: sharedModelContainer)
        }

    var body: some Scene {
        WindowGroup {
            RecordingListView()
                .environment(\.diContainer, diContainer)
        }
    }
}
