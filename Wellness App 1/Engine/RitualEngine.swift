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
        let physicalSorted = physicalPool.sorted {
            $0.energyRequired < $1.energyRequired
        }

        rituals += Array(physicalSorted.prefix(physicalCount))
        
        // 🧠 Mental (1–2 depending on stress)
        let mentalCount = profile.stressLevel == .high ? 2 : 1
        let mentalPoolSorted = mentalPool.sorted { a, b in
            if profile.stressLevel == .high {
                return a.type == .recovery && b.type != .recovery
            }
            return true
        }

        rituals += Array(mentalPoolSorted.prefix(mentalCount))
        
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
                Ritual(
                    title: "Gratitude Journal",
                    category: .emotional,
                    icon: "heart.fill",
                    type: .recovery,
                    difficulty: 1,
                    energyRequired: 1,
                    duration: 10,
                    tags: ["healing"]
                )
            ]
            
        case .angry:
            return [
                Ritual(
                    title: "Box Breathing",
                    category: .mental,
                    icon: "wind",
                    type: .recovery,
                    difficulty: 1,
                    energyRequired: 1,
                    duration: 5,
                    tags: ["calm"]
                )
            ]
            
        case .sleepy:
            return [
                Ritual(
                    title: "Sunlight Exposure",
                    category: .physical,
                    icon: "sun.max.fill",
                    type: .growth,
                    difficulty: 1,
                    energyRequired: 2,
                    duration: 10,
                    tags: ["energy"]
                )
            ]
            
        default:
            return []
        }
    }
    
    private static let corePool: [Ritual] = [
        Ritual(
            title: "Drink 2L Water",
            category: .physical,
            icon: "drop.fill",
            type: .core,
            difficulty: 1,
            energyRequired: 1,
            duration: 5,
            tags: ["hydration", "baseline"]
        ),
        Ritual(
            title: "7+ Hours Sleep",
            category: .physical,
            icon: "moon.fill",
            type: .core,
            difficulty: 2,
            energyRequired: 1,
            duration: 420,
            tags: ["recovery", "sleep"]
        ),
        Ritual(
            title: "10 Min Mindfulness",
            category: .mental,
            icon: "brain.head.profile",
            type: .core,
            difficulty: 2,
            energyRequired: 2,
            duration: 10,
            tags: ["focus", "calm"]
        )
    ]

    private static let physicalPool: [Ritual] = [
        Ritual(
            title: "20 Min Walk",
            category: .physical,
            icon: "figure.walk",
            type: .growth,
            difficulty: 2,
            energyRequired: 2,
            duration: 20,
            tags: ["movement", "fresh_air"]
        ),
        Ritual(
            title: "Strength Training",
            category: .physical,
            icon: "flame.fill",
            type: .growth,
            difficulty: 4,
            energyRequired: 4,
            duration: 40,
            tags: ["fitness", "strength"]
        ),
        Ritual(
            title: "Stretching Routine",
            category: .physical,
            icon: "figure.cooldown",
            type: .growth,
            difficulty: 2,
            energyRequired: 2,
            duration: 15,
            tags: ["flexibility", "recovery"]
        ),
        Ritual(
            title: "Posture Check Session",
            category: .physical,
            icon: "person.crop.circle.badge.checkmark",
            type: .adaptive,
            difficulty: 1,
            energyRequired: 1,
            duration: 5,
            tags: ["posture", "health"]
        )
    ]

    private static let mentalPool: [Ritual] = [
        Ritual(
            title: "Deep Work (45 mins)",
            category: .mental,
            icon: "timer",
            type: .growth,
            difficulty: 4,
            energyRequired: 4,
            duration: 45,
            tags: ["focus", "productivity"]
        ),
        Ritual(
            title: "Gratitude Journal",
            category: .emotional,
            icon: "heart.text.square",
            type: .recovery,
            difficulty: 1,
            energyRequired: 1,
            duration: 10,
            tags: ["reflection", "positive"]
        ),
        Ritual(
            title: "Breathing Exercise",
            category: .mental,
            icon: "wind",
            type: .recovery,
            difficulty: 1,
            energyRequired: 1,
            duration: 5,
            tags: ["calm", "stress"]
        ),
        Ritual(
            title: "Digital Detox (1 hr)",
            category: .mental,
            icon: "iphone.slash",
            type: .adaptive,
            difficulty: 3,
            energyRequired: 2,
            duration: 60,
            tags: ["focus", "distraction"]
        )
    ]

    private static let growthPool: [Ritual] = [
        Ritual(
            title: "Read 15 Pages",
            category: .mental,
            icon: "book.fill",
            type: .growth,
            difficulty: 2,
            energyRequired: 2,
            duration: 20,
            tags: ["learning"]
        ),
        Ritual(
            title: "Learn Something New",
            category: .mental,
            icon: "lightbulb.fill",
            type: .growth,
            difficulty: 3,
            energyRequired: 3,
            duration: 30,
            tags: ["growth"]
        ),
        Ritual(
            title: "Call a Loved One",
            category: .emotional,
            icon: "phone.fill",
            type: .growth,
            difficulty: 1,
            energyRequired: 1,
            duration: 10,
            tags: ["social"]
        ),
        Ritual(
            title: "Skill Practice (30 mins)",
            category: .mental,
            icon: "hammer.fill",
            type: .growth,
            difficulty: 4,
            energyRequired: 4,
            duration: 30,
            tags: ["skill"]
        )
    ]
}
