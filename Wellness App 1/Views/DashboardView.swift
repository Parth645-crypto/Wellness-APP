import SwiftUI

enum Mood: String, CaseIterable {
    case happy, sad, angry, sleepy, confused, frustrated
}

struct DashboardView: View {

    @State private var mood: Mood = .happy
    @State private var score: CGFloat = 65
    @State private var showStats = false

    var body: some View {
        ZStack {

            // MARK: - Background Gradient
            LinearGradient(
                colors: moodTheme.background,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // MARK: - Environment Overlay
            EnvironmentOverlay(mood: mood)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {

                    // MARK: - Header
                    header

                    // MARK: - Tree Area
                    treeSection

                    // MARK: - Ecosystem Health Card
                    ecosystemCard

                    // MARK: - Mood Tracker
                    moodTracker
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 120) // prevents floating button overlap
                .foregroundColor(primaryTextColor) // prevents floating button overlap

            }
        }
        .overlay(floatingButton, alignment: .bottomTrailing)
    }
}

private extension DashboardView {

    var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Rooted")
                    .font(.system(size: 32, weight: .black))

                Text("YOUR PERSONAL ECOSYSTEM")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(secondaryTextColor)
            }

            Spacer()

            Button {} label: {
                Image(systemName: "person")
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
    }
}

private extension DashboardView {
    var treeSection: some View {
        VStack(spacing: 0) { // Set spacing to 0 for total control
            
            // 1. This pushes the tree down from the header
            Color.clear.frame(height: 60)

            ZStack(alignment: .bottom) {
                // Glow Effect
                Circle()
                    .fill(moodTheme.glow)
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)

                // The Tree
                Image("mature_tree")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
            }
            
            // 2. Controlled gap between Tree and Label
            Color.clear.frame(height: 20)

            // Stage Label
            Text("MATURE PLANT")
                .font(.system(size: 13, weight: .bold))
                .tracking(4)
                .foregroundColor(isDarkMode ? .white.opacity(0.9) : .black.opacity(0.7))
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                )
        }
    }
}

private extension DashboardView {

    var ecosystemCard: some View {
        VStack(spacing: 16) {

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("ECOSYSTEM HEALTH")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(secondaryTextColor)

                    Text("\(Int(score))% Vibe")
                        .font(.title2.bold())
                }

                Spacer()

                Text("LVL \(Int(score / 10))")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.25))
                    .clipShape(Capsule())
            }

            ProgressView(value: score, total: 100)
                .tint(.green)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
    }
}

private extension DashboardView {
    var moodTracker: some View {
        VStack(spacing: 14) {

            HStack {
                Text("MOOD TRACKER")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(secondaryTextColor)

                Spacer()

                Text("+5 Growth")
                    .font(.caption.bold())
                    .foregroundColor(.green)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(Mood.allCases, id: \.self) { item in
                        let isSelected = item == mood

                        VStack(spacing: 6) {
                            Text(emoji(for: item))
                                .font(.system(size: isSelected ? 32 : 24))
                                .scaleEffect(isSelected ? 1.1 : 1)

                            Text(item.rawValue.capitalized)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(
                                    isSelected
                                    ? Color.black
                                    : (isDarkMode ? .white.opacity(0.6) : .secondary)
                                )
                        }
                        .frame(width: 70, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(isSelected ? Color.white : Color.white.opacity(0.25))
                        )
                        .shadow(
                            color: isSelected ? .black.opacity(0.15) : .clear,
                            radius: 8,
                            y: 4
                        )
                        .animation(.easeInOut(duration: 0.25), value: mood)
                        .onTapGesture {
                            mood = item
                        }
                    }
                }
                .padding(.vertical, 12) // 🔥 THIS is the real fix
                .padding(.horizontal, 10)
            }
        }
    }
}

private extension DashboardView {

    var floatingButton: some View {
        Button {
            showStats.toggle()
        } label: {
            Image(systemName: "waveform.path.ecg")
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(moodTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(radius: 10)
        }
        .padding(24)
    }
}

struct EnvironmentOverlay: View {

    let mood: Mood

    var body: some View {
        ZStack {
            switch mood {
            case .happy:
                Image(systemName: "sun.max")
                    .font(.system(size: 120))
                    .foregroundColor(.yellow.opacity(0.25))
                    .offset(x: 120, y: -220)

            case .sad:
                clouds(color: .gray.opacity(0.25))

            case .angry:
                clouds(color: .red.opacity(0.2))

            case .sleepy:
                moon
                stars

            default:
                EmptyView()
            }
        }
        .ignoresSafeArea()
    }

    var moon: some View {
        Image(systemName: "moon.fill")
            .font(.system(size: 90))
            .foregroundColor(.white.opacity(0.4))
            .offset(x: 120, y: -220)
    }

    var stars: some View {
        ForEach(0..<20, id: \.self) { i in
            Circle()
                .fill(.white.opacity(0.6))
                .frame(width: 2)
                .position(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...300)
                )
        }
    }

    func clouds(color: Color) -> some View {
        ZStack {
            // First cloud (original height)
            Image(systemName: "cloud.fill")
                .font(.system(size: 90))
                .offset(x: -80, y: -200)

            // Second cloud (slightly lower & shifted)
            Image(systemName: "cloud.fill")
                .font(.system(size: 80))
                .offset(x: 100, y: -130)
        }
        .foregroundColor(color)
    }
}

struct MoodTheme {
    let background: [Color]
    let glow: Color
    let accent: Color
}

extension Mood {

    var theme: MoodTheme {
        switch self {
        case .happy:
            return MoodTheme(
                background: [.cyan.opacity(0.3), .green.opacity(0.2)],
                glow: .yellow.opacity(0.3),
                accent: .yellow
            )

        case .sad:
            return MoodTheme(
                background: [.gray.opacity(0.3), .blue.opacity(0.2)],
                glow: .blue.opacity(0.2),
                accent: .blue
            )

        case .sleepy:
            return MoodTheme(
                background: [.indigo, .black],
                glow: .purple.opacity(0.3),
                accent: .indigo
            )

        case .angry:
            return MoodTheme(
                background: [.orange.opacity(0.3), .red.opacity(0.2)],
                glow: .red.opacity(0.3),
                accent: .red
            )

        default:
            return MoodTheme(
                background: [.purple.opacity(0.2), .indigo.opacity(0.2)],
                glow: .purple.opacity(0.25),
                accent: .purple
            )
        }
    }
}

extension DashboardView {
    var moodTheme: MoodTheme { mood.theme }

    func emoji(for mood: Mood) -> String {
        switch mood {
        case .happy: return "😊"
        case .sad: return "😔"
        case .angry: return "😡"
        case .sleepy: return "😴"
        case .confused: return "😕"
        case .frustrated: return "😣"
        }
    }
    
    var isDarkMode: Bool {
        mood == .sleepy
    }

    var primaryTextColor: Color {
        isDarkMode ? .white : .primary
    }

    var secondaryTextColor: Color {
        isDarkMode ? .white.opacity(0.7) : .secondary
    }
}
