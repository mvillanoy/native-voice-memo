//
//  RecordingView.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//

import AVFoundation
import SwiftUI

struct RecordingView: View {
    @EnvironmentObject var viewModel: RecordingViewModel

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {

                if viewModel.isRecording {
                    Text(viewModel.recordingFilename)
                        .font(.headline)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.bottom)

                    Text(DateUtilities.formatTime(viewModel.duration))
                        .font(.subheadline)
                        .padding(.bottom)
                }

                // TODO: Add Waveform view

                Button {
                    AudioServicesPlaySystemSound(
                        viewModel.isRecording ? 1114 : 1113)
                    withAnimation(.bouncy) {
                        if viewModel.isRecording {
                            viewModel.stopRecording()
                        } else {
                            viewModel.startRecording()
                        }
                    }

                } label: {
                    Image(
                        systemName: viewModel.isRecording
                            ? "stop.circle.fill" : "microphone.circle.fill"
                    )
                    .resizable()
                    .background(.sheetBackground)
                    .foregroundColor(.red)
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
                }
            }
            Spacer()

        }
        .padding(.top, 24)
        .background(.sheetBackground)
    }
}
