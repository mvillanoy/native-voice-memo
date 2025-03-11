//
//  RecordingEmptyView.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import SwiftUI

struct RecordingEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
                   Image(systemName: "waveform")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 100, height: 100)
                       .foregroundColor(.gray)
                       .padding(.bottom, 10)

                   Text("No Recordings Yet")
                       .font(.headline)
                       .foregroundColor(.gray)

                   Text("Tap the microphone to start recording.")
                       .font(.subheadline)
                       .foregroundColor(.gray)
                       .padding(.top, 2)
            Spacer()

               }
               .multilineTextAlignment(.center)
               .padding()
    }
}
