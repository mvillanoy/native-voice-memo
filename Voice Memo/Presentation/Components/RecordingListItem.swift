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
    @Binding var isPlaying: Bool
    @Binding var seekPosition: TimeInterval
    @State private var localSeekPosition: TimeInterval = 0
    @State private var isDragging: Bool = false

    var onDeleteCallback: (() -> Void)
    var onPlayCallback: (() -> Void)
    var onRewindCallback: (() -> Void)
    var onFastForwardCallback: (() -> Void)
    var onSeekTo: ((TimeInterval) -> Void)

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
                if !isSelected {
                    Text(
                        DateUtilities.formatTime(voiceMemo.duration)
                    )
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
            }

            if isSelected {
                Slider(
                    value: $localSeekPosition, in: 0...voiceMemo.duration,
                    label: {

                    },
                    minimumValueLabel: {
                        Text("00:00")
                            .font(.subheadline)
                    },
                    maximumValueLabel: {
                        Text(DateUtilities.formatTime(seekPosition))
                            .font(.subheadline)
                    },
                    onEditingChanged: { isEditing in
                        isDragging = isEditing
                        if !isEditing {
                            onSeekTo(localSeekPosition)
                        }
                    }
                )
                .foregroundStyle(.white)
                .padding(.vertical, 4)
                .padding(.trailing, 16)

                HStack {
                    ShareLink(
                        item: FileUtilities.getDefaultDirectory(
                            fileName: voiceMemo.fileName)
                    ) {
                        Image(systemName: "square.and.arrow.up")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.red)
                            .backgroundStyle(.clear)
                            .frame(
                                width: DEFAULT_BUTTON_SIZE,
                                height: DEFAULT_BUTTON_SIZE)
                    }

                    Spacer()

                    Button {
                        onRewindCallback()
                    } label: {
                        Image(
                            systemName: "15.arrow.trianglehead.counterclockwise"
                        )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .backgroundStyle(.clear)

                        .frame(
                            width: DEFAULT_BUTTON_SIZE,
                            height: DEFAULT_BUTTON_SIZE)
                    }

                    Button {
                        onPlayCallback()
                    } label: {
                        Image(
                            systemName: isPlaying ? "pause.fill" : "play.fill"
                        )
                        .resizable()
                        .foregroundStyle(.white)
                        .aspectRatio(contentMode: .fit)
                        .backgroundStyle(.clear)
                        .frame(
                            width: DEFAULT_BUTTON_SIZE,
                            height: DEFAULT_BUTTON_SIZE)
                    }

                    Button {
                        onFastForwardCallback()
                    } label: {
                        Image(systemName: "15.arrow.trianglehead.clockwise")
                            .resizable()
                            .foregroundStyle(.white)
                            .aspectRatio(contentMode: .fit)
                            .backgroundStyle(.clear)

                            .frame(
                                width: DEFAULT_BUTTON_SIZE,
                                height: DEFAULT_BUTTON_SIZE)
                    }

                    Spacer()

                    Button {
                        onDeleteCallback()
                    } label: {
                        Image(systemName: "trash")
                            .resizable()
                            .foregroundStyle(.red)
                            .aspectRatio(contentMode: .fit)
                            .backgroundStyle(.clear)
                            .frame(
                                width: DEFAULT_BUTTON_SIZE,
                                height: DEFAULT_BUTTON_SIZE)
                    }

                }
                .padding(.trailing, 16)
            }
            Divider()
                .padding(.top, 6)
        }
        .onChange(of: seekPosition) { newSeekPosition in
            if !isDragging {
                localSeekPosition = newSeekPosition
            }
        }
        .padding(.leading, 16)
        .contentShape(Rectangle())
    }
}
