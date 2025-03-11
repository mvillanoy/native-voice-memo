//
//  RecordingListView.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/10/25.
//

import SwiftData
import SwiftUI

struct RecordingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [VoiceMemo]
    @State var selectedItemId: UUID?

    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(items) { item in
                        RecordingListItem(
                            isSelected: .constant(selectedItemId == item.id),
                            voiceMemo: item
                        )
                        .onTapGesture {
                            selectedItemId = item.id
                        }
                    }
                }
                .navigationBarTitle("Voice Memos")
            }
            RecordingView()
        }

    }
}

#Preview {
    RecordingListView()
        .modelContainer(for: VoiceMemo.self, inMemory: true)
}
