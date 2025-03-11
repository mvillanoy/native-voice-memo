//
//  RecordingListView.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/10/25.
//

import SwiftData
import SwiftUI

struct RecordingListView: View {
    @Environment(\.diContainer) private var diContainer: DIContainer
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: RecordingListViewModel = RecordingListViewModel()
    
    @State var selectedItemId: UUID? = nil
    @State var query: String = ""
    
    @Query(sort: \VoiceMemo.timestamp, order: .reverse) var voiceMemos: [VoiceMemo]


    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    if voiceMemos.isEmpty {
                        RecordingEmptyView()
                    } else {
                        TextField("Search Voice Memos", text: self.$query)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: query) { newValue in
                                
                            }
                        LazyVStack {
                            ForEach(voiceMemos) { item in
                                RecordingListItem(
                                    isSelected: .constant(
                                        selectedItemId == item.id),
                                    voiceMemo: item
                                )
                                .onTapGesture {
                                    withAnimation(.smooth) {
                                        selectedItemId = item.id
                                    }
                                }
                                
                            }
                        }
                    }
                }
                .navigationBarTitle("Voice Memos")
            }
            RecordingView()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            viewModel.setInjected(injected: diContainer)
        }

    }
}

#Preview {
    RecordingListView()
        .modelContainer(for: VoiceMemo.self, inMemory: true)
}
