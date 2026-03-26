struct RitualEngine {

    static func generateRituals(
        for profile: UserProfile,
        emotion: Mood? = nil
    ) -> [Ritual] {
        
        var rituals: [Ritual] = []
        
        // 🌱 Core (always 3)
        rituals += corePool
        
        // 🏃 Physical (1–2 depending on activity)
        let physicalCount = profile.activityLevel == .low ? 1 : 2
        rituals += Array(physicalPool.shuffled().prefix(physicalCount))
        
        // 🧠 Mental (1–2 depending on stress)
        let mentalCount = profile.stressLevel == .high ? 2 : 1
        rituals += Array(mentalPool.shuffled().prefix(mentalCount))
        
        // 🌧 Emotion Adaptive (1)
        if let emotion {
            rituals += emotionBasedRituals(for: emotion)
        }
        
        // 🚀 Growth (always 1 rotating)
        rituals += Array(growthPool.shuffled().prefix(1))
        
        return rituals.shuffled()
    }

    static func emotionBasedRituals(for mood: Mood) -> [Ritual] {
        switch mood {
        case .sad:
            return [
                Ritual(title: "Gratitude Journal",
                       category: .emotional,
                       icon: "heart.fill",
                       type: .recovery)
            ]
        case .angry:
            return [
                Ritual(title: "Box Breathing",
                       category: .mental,
                       icon: "wind",
                       type: .recovery)
            ]
        case .sleepy:
            return [
                Ritual(title: "Sunlight Exposure",
                       category: .physical,
                       icon: "sun.max.fill",
                       type: .growth)
            ]
        default:
            return []
        }
    }
    
    private static let corePool: [Ritual] = [
        Ritual(title: "Drink 2L Water", category: .physical, icon: "drop.fill", type: .core),
        Ritual(title: "7+ Hours Sleep", category: .physical, icon: "moon.fill", type: .core),
        Ritual(title: "10 Min Mindfulness", category: .mental, icon: "brain.head.profile", type: .core)
    ]

    private static let physicalPool: [Ritual] = [
        Ritual(title: "20 Min Walk", category: .physical, icon: "figure.walk", type: .growth),
        Ritual(title: "Strength Training", category: .physical, icon: "flame.fill", type: .growth),
        Ritual(title: "Stretching Routine", category: .physical, icon: "figure.cooldown", type: .growth),
        Ritual(title: "Posture Check Session", category: .physical, icon: "person.crop.circle.badge.checkmark", type: .adaptive)
    ]

    private static let mentalPool: [Ritual] = [
        Ritual(title: "Deep Work (45 mins)", category: .mental, icon: "timer", type: .growth),
        Ritual(title: "Gratitude Journal", category: .emotional, icon: "heart.text.square", type: .recovery),
        Ritual(title: "Breathing Exercise", category: .mental, icon: "wind", type: .recovery),
        Ritual(title: "Digital Detox (1 hr)", category: .mental, icon: "iphone.slash", type: .adaptive)
    ]

    private static let growthPool: [Ritual] = [
        Ritual(title: "Read 15 Pages", category: .mental, icon: "book.fill", type: .growth),
        Ritual(title: "Learn Something New", category: .mental, icon: "lightbulb.fill", type: .growth),
        Ritual(title: "Call a Loved One", category: .emotional, icon: "phone.fill", type: .growth),
        Ritual(title: "Skill Practice (30 mins)", category: .mental, icon: "hammer.fill", type: .growth)
    ]
}
