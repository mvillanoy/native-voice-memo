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
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            NavigationView {
                ScrollView {
                    if viewModel.voiceMemos.isEmpty {
                        RecordingEmptyView()
                    } else {
                        generateItems()
                    }
                }
                .navigationBarTitle("Voice Memos")
            }
            .overlay(viewModel.isRecording ? Color.black.opacity(0.5) : nil)
            RecordingView()
                .environmentObject(viewModel)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.error ?? "Error"), dismissButton: .default(Text("Ok")))
                }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            viewModel.setInjected(injected: diContainer)
        }
        .onReceive(viewModel.$error) { error in
            if let error = error {
                showAlert = true
            }
        }

    }
    
    func generateItems() -> AnyView {
        AnyView(LazyVStack {
            ForEach(viewModel.voiceMemos) { item in
                RecordingListItem(isSelected: .constant(selectedId == item.id), voiceMemo: item, isPlaying: .constant(viewModel.isPlaying), seekPosition: viewModel.playerDuration) {
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

                } onSeekTo: { position in
                    viewModel.seekVoiceMemo(to: position)
                }
                .onTapGesture {
                    withAnimation(.smooth) {
                        selectedId = item.id
                        viewModel.select(item)
                    }
                }

            }
        })
    }
}

#Preview {
    RecordingListView()
        .modelContainer(for: VoiceMemo.self, inMemory: true)
}
