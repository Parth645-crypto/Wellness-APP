//
//  EnvironmentView.swift
//  Wellness App 1
//
//  Created by SDC-USER on 09/02/26.
//

import SwiftUI

struct EnvironmentView: View {

    var stage: GrowthStage
    var mood: MoodState

    var body: some View {
        ZStack {

            // SKY LAYER
            skyGradient

            VStack {
                Spacer()

                ZStack {

                    // GROUND
                    groundShape
                        .frame(height: 120)

                    // TREE
                    VStack(spacing: 0) {

                        // LEAVES
                        if stage != .seed {
                            Circle()
                                .fill(leafColor)
                                .frame(width: canopySize, height: canopySize)
                                .shadow(radius: 10)
                                .transition(.scale)
                        }

                        // TRUNK
                        if stage != .seed {
                            Rectangle()
                                .fill(Color.brown)
                                .frame(width: 20, height: 80)
                        }

                        // SEED
                        if stage == .seed {
                            Circle()
                                .fill(Color.brown)
                                .frame(width: 25, height: 25)
                        }
                    }

                    // FLOWERS
                    if stage == .blooming || stage == .flourishing {
                        flowerLayer
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.6), value: stage)
    }

    // MARK: - SKY

    private var skyGradient: some View {
        LinearGradient(
            colors: skyColors,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var skyColors: [Color] {
        switch mood {
        case .calm:
            return [Color.blue.opacity(0.3), Color.green.opacity(0.2)]
        case .happy:
            return [Color.yellow.opacity(0.4), Color.orange.opacity(0.3)]
        case .stressed:
            return [Color.gray.opacity(0.4), Color.blue.opacity(0.2)]
        case .tired:
            return [Color.indigo.opacity(0.4), Color.black.opacity(0.2)]
        case .overwhelmed:
            return [Color.red.opacity(0.3), Color.gray.opacity(0.3)]
        }
    }

    // MARK: - GROUND

    private var groundShape: some View {
        Ellipse()
            .fill(Color.green.opacity(0.4))
            .scaleEffect(x: 1.5, y: 1)
    }

    // MARK: - TREE PROPERTIES

    private var canopySize: CGFloat {
        switch stage {
        case .sprout: return 60
        case .youngPlant: return 100
        case .blooming: return 140
        case .flourishing: return 170
        default: return 0
        }
    }

    private var leafColor: Color {
        stage == .flourishing ? .mint : .green
    }

    // MARK: - FLOWERS

    private var flowerLayer: some View {
        ZStack {
            ForEach(0..<6) { index in
                Circle()
                    .fill(Color.pink)
                    .frame(width: 10, height: 10)
                    .offset(
                        x: CGFloat.random(in: -60...60),
                        y: CGFloat.random(in: -40...20)
                    )
            }
        }
    }
}
