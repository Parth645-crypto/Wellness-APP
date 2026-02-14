import SwiftUI

enum Mood: String, CaseIterable {
    case happy, sad, angry, sleepy, confused, frustrated
}

struct DashboardView: View {

    @AppStorage("hasSeenDashboardHint") private var hasSeenDashboardHint = false
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
                VStack(spacing: 16) {

                    // MARK: - Header
                    header

                    // MARK: - Tree Area
                    treeSection

                    // MARK: - Ecosystem Health Card
                    ecosystemCard

                    // MARK: - Mood Tracker
                    moodTracker
                    
                    // MARK: - Ecosystem Breakdown
                    ecosystemBreakdown

                    // MARK: - Insight Card
                    //insightCard
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 120) // prevents floating button overlap
                .foregroundColor(primaryTextColor) // prevents floating button overlap

            }
        }
        .overlay(floatingButton, alignment: .bottomTrailing)
        .overlay {
            if !hasSeenDashboardHint {
                dashboardHintOverlay
            }
        }
        .sheet(isPresented: $showStats) {
            RoutineChecklistView()
        }
    }
}

struct RoutineChecklistView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var morningWalk = false
    @State private var meditation = false
    @State private var journaling = false
    
    var body: some View {
        NavigationView {
            List {
                Toggle("Morning Walk", isOn: $morningWalk)
                Toggle("Meditation", isOn: $meditation)
                Toggle("Journaling", isOn: $journaling)
            }
            .navigationTitle("Daily Rituals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private extension DashboardView {

    var ecosystemBreakdown: some View {
        VStack(spacing: 16) {

            // Section Heading
            HStack {
                Text("ECOSYSTEM HEALTH")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(secondaryTextColor)

                Spacer()
            }

            // Main Glass Card
            VStack(spacing: 22) {

                metricRow(
                    icon: "figure.walk",
                    iconColor: .blue,
                    title: "PHYSICAL VITALITY",
                    subtitle: "Body movement & exercise",
                    value: 0.65
                )

                Divider().opacity(0.2)

                metricRow(
                    icon: "brain.head.profile",
                    iconColor: .purple,
                    title: "MENTAL FOCUS",
                    subtitle: "Concentration & clarity",
                    value: 0.40
                )

                Divider().opacity(0.2)

                metricRow(
                    icon: "moon.fill",
                    iconColor: .green,
                    title: "SLEEP RECOVERY",
                    subtitle: "Restfulness & quality",
                    value: 0.80
                )

                // Info Box
                infoBox
            }
            .padding(20)
//            .background(
//                RoundedRectangle(cornerRadius: 28)
//                    .fill(.ultraThinMaterial)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 28)
//                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
//                    )
//            )
            .glassCard(isDarkMode: isDarkMode)
        }
    }
}

struct GlassCardModifier: ViewModifier {
    let isDarkMode: Bool
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    if isDarkMode {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.indigo.opacity(0.25))
                            .blur(radius: 20)

                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.08))
                    } else {
                        RoundedRectangle(cornerRadius: 28)
                            .fill(.ultraThinMaterial)

                        RoundedRectangle(cornerRadius: 28)
                            .fill(Color.white.opacity(0.35))
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(
                        isDarkMode
                        ? Color.white.opacity(0.15)
                        : Color.white.opacity(0.5),
                        lineWidth: 1
                    )
            )
    }
}

extension View {
    func glassCard(isDarkMode: Bool) -> some View {
        self.modifier(GlassCardModifier(isDarkMode: isDarkMode))
    }
}

private extension DashboardView {

    func metricRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        value: Double
    ) -> some View {

        VStack(alignment: .leading, spacing: 12) {

            HStack {

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(secondaryTextColor)
                }

                Spacer()

                Text("\(Int(value * 100))%")
                    .font(.subheadline.bold())
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
            }

            ProgressView(value: value)
                .tint(Color(red: 0.35, green: 0.75, blue: 0.70)) // calmer tone
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
        }
    }
}

private extension DashboardView {

    var infoBox: some View {
        HStack(spacing: 14) {

            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.25))
                    .frame(width: 44, height: 44)

                Image(systemName: "info.circle.fill")
                    .foregroundColor(.green)
            }

            Text(attributedMessage)
                .font(.subheadline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.green.opacity(0.12))
        )
    }
    
    var attributedMessage: AttributedString {
        var text = AttributedString("Your ecosystem is currently ")
        
        var thriving = AttributedString("Thriving.")
        thriving.font = .subheadline.bold()
        
        let middle = AttributedString(" Completing your rituals today will trigger a ")
        
        var blossom = AttributedString("Blossom Event.")
        blossom.font = .subheadline.bold()
        
        text.append(thriving)
        text.append(middle)
        text.append(blossom)
        
        return text
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
            Color.clear.frame(height: 0)

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
                    .frame(height: 185)
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
//                .background(
//                    Capsule()
//                        .fill(.ultraThinMaterial)
//                        .overlay(
//                            Capsule()
//                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
//                        )
//                )
                .glassCard(isDarkMode: isDarkMode)
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
                .tint(Color(red: 0.35, green: 0.75, blue: 0.70))
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
        }
        .padding(20)
        .glassCard(isDarkMode: isDarkMode)
        .shadow(color: .black.opacity(0.1), radius: 20, y: 10)
    }
}

private extension DashboardView {
    var moodTracker: some View {
        VStack(spacing: 2) {

            HStack {
                Text("MOOD TRACKER")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(secondaryTextColor)

                Spacer()

                Text("+5 Growth")
                    .font(.caption.bold())
                    .foregroundColor(Color(red: 0.35, green: 0.75, blue: 0.70))
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(Mood.allCases, id: \.self) { item in
                        let isSelected = item == mood
                        
                        // 🔥 Break complex colors into constants
                        let backgroundColor: Color = {
                            if isSelected {
                                return isDarkMode ? Color.white.opacity(0.9) : Color.white
                            } else {
                                return isDarkMode ? Color.white.opacity(0.08) : Color.white.opacity(0.25)
                            }
                        }()
                        
                        let borderColor: Color = {
                            if isDarkMode {
                                return Color.white.opacity(0.15)
                            } else {
                                return .clear
                            }
                        }()
                        
                        let textColor: Color = {
                            if isSelected {
                                return .black
                            } else {
                                return isDarkMode ? Color.white.opacity(0.6) : .secondary
                            }
                        }()
                        
                        let shadowColor: Color = {
                            if isSelected && isDarkMode {
                                return Color.white.opacity(0.25)
                            } else {
                                return .clear
                            }
                        }()
                        
                        VStack(spacing: 6) {
                            Text(emoji(for: item))
                                .font(.system(size: isSelected ? 32 : 24))
                                .scaleEffect(isSelected ? 1.1 : 1)

                            Text(item.rawValue.capitalized)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(textColor)
                        }
                        .frame(width: 70, height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(backgroundColor)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(borderColor, lineWidth: 1)
                        )
                        .shadow(color: shadowColor, radius: 12)
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

private extension DashboardView {

    var dashboardHintOverlay: some View {
        ZStack {
            Color.black.opacity(0.28)
                .ignoresSafeArea()

            VStack(spacing: 22) {

                Text("Welcome to your ecosystem")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text("Track your mood daily and tap the bottom-right button to manage your rituals.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                Button {
                    hasSeenDashboardHint = true
                } label: {
                    Text("Got it")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primary)
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 26)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.08), radius: 30, y: 15)
            )
            .padding(30)
        }
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
                clouds(color: .gray.opacity(0.45))

            case .angry:
                clouds(color: .red.opacity(0.35))

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
                .offset(x: -80, y: -240)

            // Second cloud (slightly lower & shifted)
            Image(systemName: "cloud.fill")
                .font(.system(size: 80))
                .offset(x: 110, y: -170)
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
                background: [.gray.opacity(0.5), .blue.opacity(0.2)],
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
                background: [.orange.opacity(0.5), .red.opacity(0.2)],
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
