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
    @StateObject private var viewModel: RecordingViewModel =
        RecordingViewModel()

    @State var query: String = ""
    @State var selectedId: UUID? = nil
//
//    @Query(sort: \VoiceMemo.timestamp, order: .reverse) var voiceMemos:
//        [VoiceMemo]

    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    if viewModel.voiceMemos.isEmpty {
                        RecordingEmptyView()
                    } else {
//                        TextField("Search Voice Memos", text: self.$query)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                            .onChange(of: query) { newValue in
//
//                            }
                        LazyVStack {
                            ForEach(viewModel.voiceMemos) { item in
                                RecordingListItem(isSelected: .constant(selectedId == item.id), voiceMemo: item, isPlaying: .constant(viewModel.isPlaying)) {
                                    viewModel.deleteVoiceMemo()
                                } onPlayCallback: {
                                    if viewModel.isPlaying {
                                        viewModel.pauseVoiceMemo()
                                    } else {
                                        viewModel.playVoiceMemo()
                                    }
                                    
                                } onRewindCallback: {
                                    viewModel.rewindVoiceMemo()
                                } onFastForwardCallback: {
                                    viewModel.fastForwardVoiceMemo()

                                }
                                .onTapGesture {
                                    withAnimation(.smooth) {
                                        selectedId = item.id
                                        viewModel.select(item)
                                    }
                                }

                            }
                        }
                    }
                }
                .navigationBarTitle("Voice Memos")
            }
            RecordingView()
                .environmentObject(viewModel)
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
