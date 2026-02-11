import SwiftUI

struct EnvironmentView: View {

    var stage: GrowthStage
    var mood: MoodState

    var body: some View {
        ZStack {

            // SKY
            skyLayer

            VStack {
                Spacer()

                ZStack {

                    // GROUND
                    groundLayer

                    // TREE
                    if stage != .seed {
                        treeLayer
                    } else {
                        Circle()
                            .fill(Color.brown.opacity(0.8))
                            .frame(width: 18, height: 18)
                            .offset(y: 30)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: stage)
    }

    // MARK: SKY

    private var skyLayer: some View {
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
            return [Color.blue.opacity(0.25), Color.white]
        case .happy:
            return [Color.yellow.opacity(0.3), Color.orange.opacity(0.2)]
        case .stressed:
            return [Color.gray.opacity(0.4), Color.blue.opacity(0.2)]
        case .tired:
            return [Color.indigo.opacity(0.4), Color.black.opacity(0.2)]
        case .overwhelmed:
            return [Color.red.opacity(0.3), Color.gray.opacity(0.3)]
        }
    }

    // MARK: GROUND

    private var groundLayer: some View {
        ZStack {
            Ellipse()
                .fill(Color.green.opacity(0.3))
                .frame(height: 180)
                .blur(radius: 5)

            Ellipse()
                .fill(Color.green.opacity(0.2))
                .frame(height: 120)
        }
    }

    // MARK: TREE

    private var treeLayer: some View {
        VStack(spacing: 0) {

            // CANOPY
            canopyLayer
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)

            // TRUNK
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.brown.opacity(0.8), Color.brown.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 22, height: trunkHeight)
        }
    }

    private var canopyLayer: some View {
        ZStack {

            // Left canopy blob
            Circle()
                .fill(canopyColor)
                .frame(width: canopySize * 0.9, height: canopySize * 0.9)
                .offset(x: -canopySize * 0.25, y: -canopySize * 0.1)
                .rotationEffect(.degrees(stage == .flourishing ? 1 : 0))
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: stage)
            // Right canopy blob
            Circle()
                .fill(canopyColor)
                .frame(width: canopySize * 0.9, height: canopySize * 0.9)
                .offset(x: canopySize * 0.25, y: -canopySize * 0.1)
                .rotationEffect(.degrees(stage == .flourishing ? 1 : 0))
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: stage)
            // Center canopy blob
            Circle()
                .fill(canopyColor)
                .frame(width: canopySize, height: canopySize)
                .offset(y: -canopySize * 0.2)
                .rotationEffect(.degrees(stage == .flourishing ? 1 : 0))
                .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: stage)
        }
    }

    private var canopySize: CGFloat {
        switch stage {
        case .sprout: return 80
        case .youngPlant: return 120
        case .blooming: return 160
        case .flourishing: return 200
        default: return 0
        }
    }

    private var trunkHeight: CGFloat {
        switch stage {
        case .sprout: return 50
        case .youngPlant: return 70
        case .blooming: return 90
        case .flourishing: return 110
        default: return 0
        }
    }

    private var canopyColor: Color {
        stage == .flourishing ? Color.mint : Color.green.opacity(0.8)
    }
}
