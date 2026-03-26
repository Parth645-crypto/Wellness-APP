//
//  UserProfileStorage.swift
//  Wellness App 1
//
//  Created by SDC-USER on 24/02/26.
//
import SwiftUI
import Combine

class UserProfileStore: ObservableObject {

    @AppStorage("userName") var name: String = "Explorer"
    @AppStorage("sleepGoal") var sleepGoal: Double = 7
    @AppStorage("activityLevel") var activityRaw: String = "moderate"
    @AppStorage("stressLevel") var stressRaw: String = "medium"
    @AppStorage("hydrationLevel") var hydrationRaw: String = "average"

    var profile: UserProfile {
        UserProfile(
            sleepHours: Int(sleepGoal),
            activityLevel: ActivityLevel(rawValue: activityRaw) ?? .moderate,
            stressLevel: StressLevel(rawValue: stressRaw) ?? .medium,
            hydrationLevel: HydrationLevel(rawValue: hydrationRaw) ?? .average
        )
    }
}
