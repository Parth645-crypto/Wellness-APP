import SwiftUI

struct ProfileView: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var profileStore: UserProfileStore
    @ObservedObject var ecosystemVM: EcosystemViewModel
    let isDarkMode: Bool
    

//    var body: some View {
//        NavigationStack {
//            ZStack {
//                LinearGradient(
//                    colors: isDarkMode
//                    ? [Color.indigo, Color.black]
//                    : [Color.white, Color.green.opacity(0.06)],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea()
//
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 28) {
//                        header
//                        baselineSection
//                        growthSection
//                        stageSection
//                    }
//                    .padding(24)
//                }
//            }
//            .navigationTitle("Your Profile")
//            .navigationBarTitleDisplayMode(.large)
//            
//            // 🔥 THIS is the missing piece
//            .toolbarBackground(.visible, for: .navigationBar)
//            .toolbarBackground(
//                isDarkMode ? Color.black.opacity(0.3) : Color.white,
//                for: .navigationBar
//            )
//            .toolbarColorScheme(isDarkMode ? .dark : .light, for: .navigationBar)
//
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundColor(isDarkMode ? .white : .black)
//                    }
//                }
//            }
//        }
//    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Background
                LinearGradient(
                    colors: isDarkMode
                    ? [Color.indigo, Color.black]
                    : [Color.white, Color.green.opacity(0.06)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        
                        baselineSection
                        growthSection
                        stageSection
                    }
                    .padding(24)
                }
            }
            .navigationTitle("Your Profile")
            .navigationBarTitleDisplayMode(.large)
            
            // ✅ THIS fixes title color automatically
            .toolbarColorScheme(isDarkMode ? .dark : .light, for: .navigationBar)
            
            // ✅ Optional but makes it feel premium
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(
                isDarkMode ? Color.black.opacity(0.3) : Color.white,
                for: .navigationBar
            )
            
            // ✅ Native close button (exactly what you wanted)
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
    
    
    var header: some View {
        HStack(alignment: .center) {
            Text("Your Profile")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(primaryText)

            Spacer()
        }
    }

    var primaryText: Color {
        isDarkMode ? .white : .primary
    }

    var secondaryText: Color {
        isDarkMode ? .white.opacity(0.7) : .secondary
    }
    
    private var baselineSection: some View {
        VStack(spacing: 24) {
            
            baselineRow(
                icon: "bed.double.fill",
                title: "Sleep Target",
                value: "\(Int(profileStore.sleepGoal))h",
                color: .blue
            )
            
            baselineRow(
                icon: "waveform.path.ecg",
                title: "Activity Level",
                value: profileStore.activityRaw.capitalized,
                color: .green
            )
            
            baselineRow(
                icon: "brain.head.profile",
                title: "Stress Baseline",
                value: profileStore.stressRaw.capitalized,
                color: .purple
            )
            
            baselineRow(
                icon: "drop.fill",
                title: "Hydration Goal",
                value: profileStore.hydrationRaw.capitalized,
                color: .cyan
            )
        }
    }
    
    private func baselineRow(
        icon: String,
        title: String,
        value: String,
        color: Color
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDarkMode ? color.opacity(0.9) : color)
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(primaryText)
                
                Spacer()
                
                Text(value)
                    .font(.headline)
                    .foregroundColor(isDarkMode ? color.opacity(0.9) : color)
            }
            
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    isDarkMode
                    ? Color.white.opacity(0.12)
                    : Color.black.opacity(0.08)
                )
                .frame(height: 1)
        }
        .padding(20)
        .background(
            ZStack {
                if isDarkMode {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.indigo.opacity(0.25))
                        .blur(radius: 20)

                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.08))
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .fill(Color.white.opacity(0.35))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                            isDarkMode
                            ? Color.white.opacity(0.15)
                            : Color.black.opacity(0.08),   // 🔥 NEW
                            lineWidth: 1
                        )
        ).shadow(
            color: isDarkMode ? .clear : .black.opacity(0.05), // 🔥 NEW
            radius: 8,
            y: 4
        )
    }
    
    private var growthSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Text("GROWTH OVERVIEW")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(secondaryText)
            
            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 16) {
                
                statCard(title: "Current Level",
                         value: "\(ecosystemVM.currentLevel)",
                         color: .green)
                
                statCard(title: "Current XP",
                         value: "\(ecosystemVM.xpInCurrentLevel)",
                         color: .blue)
                
                statCard(title: "Lifetime XP",
                         value: "\(ecosystemVM.totalXP)",
                         color: .purple)
                
                statCard(title: "Completion",
                         value: "\(Int(ecosystemVM.score))%",
                         color: .orange)
            }
        }
    }
    
    private func statCard(
        title: String,
        value: String,
        color: Color
    ) -> some View {
        
        VStack(spacing: 8) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(primaryText)
            
            Text(value)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(isDarkMode ? color.opacity(0.9) : color)
        }
        .frame(maxWidth: .infinity, minHeight: 110)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(isDarkMode ? color.opacity(0.25) : color.opacity(0.12))
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    isDarkMode ? Color.white.opacity(0.1) : Color.clear,
                    lineWidth: 1
                )
        )
    }
    
    private var stageSection: some View {
        HStack(spacing: 16) {
            
            Image(ecosystemVM.growthStage.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text("CURRENT STAGE")
                    .font(.caption)
                    .foregroundColor(secondaryText)
                
                Text(ecosystemVM.growthStage.title)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            ZStack {
                if isDarkMode {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.indigo.opacity(0.25))
                        .blur(radius: 20)

                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.08))
                } else {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .fill(Color.white.opacity(0.35))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    isDarkMode
                    ? Color.white.opacity(0.15)
                    : Color.black.opacity(0.08),
                    lineWidth: 1
                )
        ).shadow(
            color: isDarkMode ? .clear : .black.opacity(0.05), // 🔥 NEW
            radius: 8,
            y: 4
        )
    }
}
