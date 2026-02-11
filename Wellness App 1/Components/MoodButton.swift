//
//  MoodButton.swift
//  Wellness App 1
//
//  Created by SDC-USER on 09/02/26.
//

import SwiftUI

struct MoodButton: View {
    var mood: MoodState
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(emoji)
                .font(.system(size: 28))
                .padding(8)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                )
        }
        .buttonStyle(.plain)
    }

    private var emoji: String {
        switch mood {
        case .calm: return "😌"
        case .happy: return "😊"
        case .stressed: return "😣"
        case .tired: return "😴"
        case .overwhelmed: return "😵‍💫"
        }
    }
}
