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
                        Text(DateUtilities.formatTime(localSeekPosition))
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
                        ItemIcon(icon: "square.and.arrow.up", color: .red)
                    }

                    Spacer()

                    Button {
                        onRewindCallback()
                    } label: {
                        ItemIcon(icon: "15.arrow.trianglehead.counterclockwise")
                    }

                    Button {
                        onPlayCallback()
                    } label: {
                        ItemIcon(icon: isPlaying ? "pause.fill" : "play.fill")
                    }

                    Button {
                        onFastForwardCallback()
                    } label: {
                        ItemIcon(icon: "15.arrow.trianglehead.clockwise")
                    }

                    Spacer()

                    Button {
                        onDeleteCallback()
                    } label: {
                        ItemIcon(icon: "trash", color: .red)
                    }

                }
                .padding(.trailing, 16)
            }
            Divider()
                .padding(.top, 6)
        }
        .onChange(of: seekPosition) { oldValue, newValue in
            if !isDragging {
                localSeekPosition = newValue
            }
        }
        .padding(.leading, 16)
        .contentShape(Rectangle())
    }
}
