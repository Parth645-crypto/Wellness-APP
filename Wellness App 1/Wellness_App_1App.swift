//
//  Wellness_App_1App.swift
//  Wellness App 1
//
//  Created by SDC-USER on 06/02/26.
//

import SwiftUI

@main
struct Wellness_App_1App: App {

    @AppStorage("hasSeenWelcome") var hasSeenWelcome = false
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {

            if !hasSeenWelcome {
                WelcomeView()
            } else if !hasCompletedOnboarding {
                OnboardingView()
            } else {
                DashboardView()
            }
        }
    }
}
