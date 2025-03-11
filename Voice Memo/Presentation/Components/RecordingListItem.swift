//
//  RecordingListItem.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import SwiftUI

let DEFAULT_BUTTON_SIZE: CGFloat = 25.0
struct RecordingListItem: View {
    @Binding var isSelected: Bool
    var voiceMemo: VoiceMemo
    @State var isPlaying: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            Text(voiceMemo.fileName)
                .bold()
                .padding(.top, 6)
            HStack {
                Text(
                    voiceMemo.timestamp,
                    format: Date.FormatStyle(date: .numeric, time: .standard)
                )
                .font(.caption)
                .foregroundStyle(.gray)
                Spacer()
                
                Text(
                    DateUtilities.formatTime(voiceMemo.duration)
                )
                .font(.caption)
                .foregroundStyle(.gray)
            }


            if isSelected {

                Slider(value: .constant(0.5), in: 0...1) {
                    Text("Speed")
                }
                minimumValueLabel: {
                    Text("00:00")
                        .font(.subheadline)
                } maximumValueLabel: {
                    Text("10:00")
                        .font(.subheadline)
                }
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.trailing, 16)


                HStack {
                    ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.red)
                            .backgroundStyle(.clear)
                            .frame(width: DEFAULT_BUTTON_SIZE, height: DEFAULT_BUTTON_SIZE)
                        }


                    Spacer()
                    
                    Button {

                    } label: {
                        Image(
                            systemName: "15.arrow.trianglehead.counterclockwise"
                        )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .backgroundStyle(.clear)

                        .frame(width: DEFAULT_BUTTON_SIZE, height: DEFAULT_BUTTON_SIZE)
                    }

                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill": "play.fill")
                            .resizable()
                            .foregroundStyle(.white)
                            .aspectRatio(contentMode: .fit)
                            .backgroundStyle(.clear)
                            .frame(width: DEFAULT_BUTTON_SIZE, height: DEFAULT_BUTTON_SIZE)
                    }

                    Button {
                        print("SHARE")
                    } label: {
                        Image(systemName: "15.arrow.trianglehead.clockwise")
                            .resizable()
                            .foregroundStyle(.white)
                            .aspectRatio(contentMode: .fit)
                            .backgroundStyle(.clear)

                            .frame(width: DEFAULT_BUTTON_SIZE, height: DEFAULT_BUTTON_SIZE)
                    }

                    Spacer()

                    Button {
                        print("Delete")
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .foregroundStyle(.red)
                            .aspectRatio(contentMode: .fit)
                            .backgroundStyle(.clear)
                            .frame(width: DEFAULT_BUTTON_SIZE, height: DEFAULT_BUTTON_SIZE)
                    }

                }
                .padding(.trailing, 16)
            }
            Divider()
                .padding(.top, 6)
        }
        .padding(.leading, 16)
        .contentShape(Rectangle())
    }
}
