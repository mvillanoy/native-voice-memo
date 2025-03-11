//
//  AnimatingCellHeight.swift
//  Voice Memo
//
//  Created by Monica Villanoy on 3/11/25.
//
import SwiftUI
struct AnimatingCellHeight: AnimatableModifier {
    var height: CGFloat = 0

    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }

    func body(content: Content) -> some View {
        content.frame(height: height.rounded())
    }
}
