//
//  DIContainer.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import SwiftData
import SwiftUI

class DIContainer {
    // Repositories
    private let voiceMemoRepository: VoiceMemoRepository
    
    // UseCases
    let voiceMemoUseCase: VoiceMemoUseCase
    
    let context: ModelContext
    let modelContainer: ModelContainer
    
    init(container: ModelContainer) {
        self.context = ModelContext(container)
        self.modelContainer = container
        self.voiceMemoRepository = VoiceMemoRepository(context: ModelContext(container))
        self.voiceMemoUseCase = VoiceMemoUseCase(repository: voiceMemoRepository)
    }
    

}


struct DIContainerKey: EnvironmentKey {
    static var defaultValue: DIContainer = DIContainer(container: try! ModelContainer(for: VoiceMemo.self))
    
    typealias Value = DIContainer
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
