import SwiftUI

enum Mood: String, CaseIterable {
    case happy, sad, angry, sleepy, confused, frustrated
}

struct DashboardView: View {
    

    @AppStorage("hasSeenDashboardHint") private var hasSeenDashboardHint = false
    @State private var mood: Mood = .happy
    //@State private var score: CGFloat = 65
    @State private var showStats = false
    @State private var pulse = false
    @State private var showPromotion = false
    @State private var promotedStage: GrowthStage?
   //@AppStorage("growthStage") private var storedStage: String = GrowthStage.seed.rawValue
    
    var growthStage: GrowthStage {
        viewModel.growthStage
    }
    
    @StateObject private var viewModel = EcosystemViewModel(
        profile: UserProfile(
            sleepHours: 7,
            activityLevel: .moderate,
            stressLevel: .medium,
            hydrationLevel: .average
        )
    )

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
                VStack(spacing: 20) {

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
            RoutineChecklistView(rituals: $viewModel.rituals)
        }
//        .onReceive(viewModel.$rituals) { _ in
//            viewModel.updateXPIfNeeded()
//        }
        .onChange(of: viewModel.rituals) { _ in
            viewModel.recalculateXP()
        }
        .onChange(of: viewModel.growthStage) { newStage in
            promotedStage = newStage
            showPromotion = true
        }
        .alert("🌱 Growth Unlocked!", isPresented: $showPromotion) {
            Button("Amazing!") {}
        } message: {
            if let stage = promotedStage {
                Text("You evolved to \(stage.title)!")
            }
        }
        .onAppear {
            viewModel.checkForDailyReset(
                profile: UserProfile(
                    sleepHours: 7,
                    activityLevel: .moderate,
                    stressLevel: .medium,
                    hydrationLevel: .average
                )
            )
        }
    }
    
}

struct RoutineChecklistView: View {
    
    @Binding var rituals: [Ritual]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    colors: [Color.green.opacity(0.08), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {

                        VStack(spacing: 18) {
                            ForEach($rituals) { $ritual in
                                RitualCard(ritual: $ritual)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Daily Rituals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
        }
    }
}

struct Ritual: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let category: RitualCategory
    let icon: String
    var isCompleted: Bool = false
    
    static func == (lhs: Ritual, rhs: Ritual) -> Bool {
        lhs.id == rhs.id &&
        lhs.isCompleted == rhs.isCompleted
    }
}

enum RitualCategory: String {
    case physical = "PHYSICAL"
    case mental = "MENTAL"
    case emotional = "EMOTIONAL"
    
    var color: Color {
        switch self {
        case .physical: return .blue
        case .mental: return .purple
        case .emotional: return .pink
        }
    }
}

struct RitualCard: View {
    
    @Binding var ritual: Ritual
    
    var body: some View {
        HStack(spacing: 18) {
            
            // Icon container
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(ritual.category.color.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: ritual.icon)
                    .foregroundColor(ritual.category.color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(ritual.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(ritual.isCompleted ? ritual.category.color : .primary)
                    .strikethrough(ritual.isCompleted)
                
                Text(ritual.category.rawValue)
                    .font(.system(size: 11, weight: .medium))
                    .tracking(2)
                    .foregroundColor(.secondary)            }
            
            Spacer()
            
            // Custom Circular Toggle
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    ritual.isCompleted.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .stroke(
                            ritual.isCompleted
                            ? ritual.category.color
                            : Color.gray.opacity(0.3),
                            lineWidth: 2
                        )
                        .frame(width: 26, height: 26)
                    
                    if ritual.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18)
                            .background(ritual.category.color)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(20)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)

                if ritual.isCompleted {
                    RoundedRectangle(cornerRadius: 28)
                        .fill(ritual.category.color.opacity(0.10))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(
                    ritual.isCompleted
                    ? ritual.category.color.opacity(0.35)
                    : Color.white.opacity(0.4),
                    lineWidth: 1
                )
        )
        .shadow(color: .black.opacity(0.08), radius: 20, y: 10)
        .opacity(ritual.isCompleted ? 0.9 : 1)
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
                Image(growthStage.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 185)
            }
            
            // 2. Controlled gap between Tree and Label
            Color.clear.frame(height: 20)

            // Stage Label
            Text(growthStage.title.uppercased())
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

                    Text("\(viewModel.totalXP) XP")
                        .font(.title2.bold())
                }

                Spacer()

                Text("LVL \(Int(viewModel.score / 10))")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.25))
                    .clipShape(Capsule())
            }

            ProgressView(value: Double(viewModel.totalXP), total: 1000)
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
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(moodTheme.accent)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
        }
        .padding(24)
    }
}

private extension DashboardView {

    var dashboardHintOverlay: some View {
        ZStack {

            // Soft dim
            Color.black.opacity(0.15)
                .ignoresSafeArea()

            // Spotlight ring (aligned exactly to button)
            // Spotlight ring (heartbeat animation)
            // Premium breathing halo
            VStack {
                Spacer()
                HStack {
                    Spacer()

                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.18))
                            .frame(width: 90, height: 90)
                            .blur(radius: 8)
                            .scaleEffect(pulse ? 1.08 : 0.96)
                            .animation(
                                .easeInOut(duration: 1.6)
                                    .repeatForever(autoreverses: true),
                                value: pulse
                            )

                        Circle()
                            .stroke(Color.white.opacity(0.9), lineWidth: 3)
                            .frame(width: 76, height: 76)
                    }
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                }
            }
            .onAppear {
                pulse = true
            }
            // Hint card
            VStack {
                Spacer()

                HStack {
                    Spacer()

                    VStack(spacing: 8) {

                        Text("Tap here to manage\nyour daily rituals")
                            .font(.subheadline.weight(.semibold))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white)
                                    .shadow(color: .black.opacity(0.15), radius: 30, y: 20)
                            )

                        // Soft curved indicator
                        Image(systemName: "arrow.right")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black.opacity(1.0))
                            .rotationEffect(.degrees(35))
                    }
                    .padding(.trailing, 28)
                    .padding(.bottom, 75) // lowered properly
                }
            }
        }
        .onTapGesture {
            hasSeenDashboardHint = true
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
