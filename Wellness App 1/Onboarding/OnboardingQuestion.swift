//
//  OnboardingQuestion.swift
//  Wellness App 1
//
//  Created by SDC-USER on 12/02/26.
//

import Foundation
import SwiftUI

struct OnboardingQuestion: Identifiable {
    let id = UUID()
    let category: OnboardingCategory
    let icon: String
    let title: String
    let options: [OnboardingOption]
}

struct OnboardingOption: Identifiable {
    let id = UUID()
    let text: String
    let score: Double
}

enum OnboardingCategory {
    case sleep
    case mind
    case movement
    case stress
    case energy

    var gradient: [Color] {
        switch self {
        case .sleep:
            return [
                Color(red: 0.90, green: 0.88, blue: 0.96),
                Color(red: 0.82, green: 0.80, blue: 0.94)
            ]
        case .mind:
            return [Color(red: 0.90, green: 0.88, blue: 0.96),
                    Color(red: 0.82, green: 0.80, blue: 0.94)]

        case .movement:
            return [Color(red: 0.85, green: 0.93, blue: 0.94),
                    Color(red: 0.75, green: 0.88, blue: 0.90)]

        case .stress:
            return [Color(red: 0.88, green: 0.90, blue: 0.95),
                    Color(red: 0.80, green: 0.84, blue: 0.92)]

        case .energy:
            return [Color(red: 0.96, green: 0.92, blue: 0.85),
                    Color(red: 0.93, green: 0.86, blue: 0.75)]
        }
    }
    
    var accent: Color {
        switch self {
        case .sleep: return Color.indigo
        case .mind: return Color.purple
        case .movement: return Color.green
        case .stress: return Color.blue
        case .energy: return Color.orange
        }
    }
}

extension OnboardingQuestion {

    static let all: [OnboardingQuestion] = [

        OnboardingQuestion(
            category: .sleep,
            icon: "moon.zzz.fill",
            title: "On a typical night, how long do you sleep?",
            options: [
                OnboardingOption(text: "8+ peaceful hours", score: 100),
                OnboardingOption(text: "6–7 solid hours", score: 66),
                OnboardingOption(text: "4–5 restless hours", score: 33),
                OnboardingOption(text: "Barely any rest", score: 0)
            ]
        ),

        OnboardingQuestion(
            category: .mind,
            icon: "brain.head.profile",
            title: "How clear does your mind feel most days?",
            options: [
                OnboardingOption(text: "Crystal clear", score: 100),
                OnboardingOption(text: "Mostly focused", score: 66),
                OnboardingOption(text: "A little foggy", score: 33),
                OnboardingOption(text: "Completely cluttered", score: 0)
            ]
        ),

        OnboardingQuestion(
            category: .movement,
            icon: "figure.walk",
            title: "On most days, how active are you?",
            options: [
                OnboardingOption(text: "Active athlete", score: 100),
                OnboardingOption(text: "Light enthusiast", score: 66),
                OnboardingOption(text: "Occasional walker", score: 33),
                OnboardingOption(text: "Mostly stationary", score: 0)
            ]
        ),

        OnboardingQuestion(
            category: .stress,
            icon: "cloud.fill",
            title: "How often do you feel mentally overwhelmed?",
            options: [
                OnboardingOption(text: "Rarely", score: 100),
                OnboardingOption(text: "Sometimes", score: 66),
                OnboardingOption(text: "Often", score: 33),
                OnboardingOption(text: "Almost constantly", score: 0)
            ]
        ),

        OnboardingQuestion(
            category: .energy,
            icon: "bolt.fill",
            title: "How energized do you feel during the day?",

            options: [
                OnboardingOption(text: "Full of energy", score: 100),
                OnboardingOption(text: "Generally steady", score: 66),
                OnboardingOption(text: "Often drained", score: 33),
                OnboardingOption(text: "Completely exhausted", score: 0)
            ]
        )
    ]
}
