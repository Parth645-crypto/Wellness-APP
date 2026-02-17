//
//  RitualEngine.swift
//  Wellness App 1
//
//  Created by SDC-USER on 14/02/26.
//

struct RitualEngine {

    static func generateRituals(for profile: UserProfile) -> [Ritual] {
        var rituals: [Ritual] = []

        // Sleep
        rituals.append(
            Ritual(title: "Track Sleep Quality",
                   category: .physical,
                   icon: "moon.fill")
        )

        // Exercise logic
        switch profile.activityLevel {
        case .low:
            rituals.append(
                Ritual(title: "15 min Light Walk",
                       category: .physical,
                       icon: "figure.walk")
            )
        case .moderate:
            rituals.append(
                Ritual(title: "30 min Workout",
                       category: .physical,
                       icon: "figure.walk")
            )
        case .high:
            rituals.append(
                Ritual(title: "Strength + Cardio Session",
                       category: .physical,
                       icon: "flame.fill")
            )
        }

        // Stress logic
        if profile.stressLevel == .high {
            rituals.append(
                Ritual(title: "10 min Deep Breathing",
                       category: .mental,
                       icon: "wind")
            )
        } else {
            rituals.append(
                Ritual(title: "5 min Mindful Meditation",
                       category: .mental,
                       icon: "brain.head.profile")
            )
        }

        // Hydration
        if profile.hydrationLevel == .poor {
            rituals.append(
                Ritual(title: "Drink 2L Water Today",
                       category: .physical,
                       icon: "drop.fill")
            )
        }

        return rituals
    }
}
