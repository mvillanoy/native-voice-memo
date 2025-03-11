//
//  ItemIcon.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import SwiftUI

let DEFAULT_BUTTON_SIZE: CGFloat = 25.0

struct ItemIcon: View {
    var icon: String
    var color: Color = .white
    var body: some View {
        Image(
            systemName: icon
        )
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(color)
        .backgroundStyle(.clear)
        .frame(
            width: DEFAULT_BUTTON_SIZE,
            height: DEFAULT_BUTTON_SIZE)
    }
}
