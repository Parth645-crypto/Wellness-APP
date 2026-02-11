//
//  WellnessViewModel.swift
//  Wellness App
//
//  Created by SDC-USER on 06/02/26.
//

import SwiftUI
import Combine

class WellnessViewModel: ObservableObject {
    private var baseMindScore: Double = 80
    private var baseBodyScore: Double = 95
    private var baseRecoveryScore: Double = 70
    private var baseEnergyScore: Double = 90
    
    @Published var mood: MoodState = .calm
    @Published var mindScore: Double = 80
    @Published var bodyScore: Double = 95
    @Published var recoveryScore: Double = 70
    @Published var energyScore: Double = 90

    var overallScore: Double {
        (mindScore + bodyScore + recoveryScore + energyScore) / 4
    }

    var growthStage: GrowthStage {
        switch overallScore {
        case 0..<25:
            return .seed
        case 25..<50:
            return .sprout
        case 50..<75:
            return .youngPlant
        default:
            return .blooming
        }
    }
    
    func applyMoodEffect() {
        mindScore = baseMindScore
        bodyScore = baseBodyScore
        recoveryScore = baseRecoveryScore
        energyScore = baseEnergyScore
        
        switch mood {
        case .calm:
            mindScore += 2
        case .happy:
            mindScore += 3
            energyScore += 2
        case .stressed:
            mindScore -= 5
        case .tired:
            recoveryScore -= 4
        case .overwhelmed:
            mindScore -= 6
            energyScore -= 3
        }
    }
}
