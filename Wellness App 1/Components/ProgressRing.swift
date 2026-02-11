//
//  ProgressRing.swift
//  Wellness App
//
//  Created by SDC-USER on 06/02/26.
//
import SwiftUI

struct ProgressRing: View {
    var progress: Double
    var color: Color
    var title: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.15), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: progress / 100)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.8), value: progress)
                
                Text("\(Int(progress))")
                    .font(.system(size: 18, weight: .semibold))
            }
            .frame(width: 70, height: 70)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
