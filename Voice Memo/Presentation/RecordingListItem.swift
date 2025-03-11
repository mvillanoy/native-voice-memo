//
//  RecordingListItem.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import SwiftUI

struct RecordingListItem: View {
    @Binding var isSelected: Bool
    var voiceMemo: VoiceMemo

    var body: some View {
        VStack(alignment: .leading) {
            Text(voiceMemo.fileName)
                .bold()
            Text(
                voiceMemo.timestamp,
                format: Date.FormatStyle(date: .numeric, time: .standard)
            )
            .font(.caption)
            .foregroundStyle(.gray)

            if isSelected {

                Slider(value: .constant(0.5), in: 0...1) {
                    Text("Speed")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                .foregroundStyle(.white)
                .padding(.vertical)

                HStack {
                    Button {
                        print("SHARE")
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .foregroundStyle(.red)

                            .frame(width: 20, height: 20)
                    }

                    Spacer()

                    Button {
                        print("SHARE")
                    } label: {
                        Image(
                            systemName: "15.arrow.trianglehead.counterclockwise"
                        )
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 20, height: 20)
                    }

                    Button {
                        print("SHARE")
                    } label: {
                        Image(systemName: "play.fill")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                    }

                    Button {
                        print("SHARE")
                    } label: {
                        Image(systemName: "15.arrow.trianglehead.clockwise")
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                    }

                    Spacer()

                    Button {
                        print("SHARE")
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .foregroundStyle(.red)

                            .frame(width: 20, height: 20)
                    }

                }
            }
        }
    }
}
