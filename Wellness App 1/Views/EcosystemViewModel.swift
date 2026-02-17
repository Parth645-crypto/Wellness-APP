//
//  EcosystemViewModel.swift
//  Wellness App 1
//
//  Created by SDC-USER on 17/02/26.
//

import SwiftUI
import Combine

class EcosystemViewModel: ObservableObject {
    @AppStorage("totalXP") var totalXP: Int = 0
    //@AppStorage("growthStage") private var storedStage: String = GrowthStage.seed.rawValue
    @AppStorage("lastResetDate") private var lastResetDate: Double = 0
    @Published var rituals: [Ritual] = []
    @Published private(set) var todayXP: Int = 0
    
    private let xpPerRitual = 10
    private let xpPerDayBonus = 20
    
    var score: CGFloat {
        let completed = rituals.filter { $0.isCompleted }.count
        let total = rituals.count
        return total == 0 ? 0 : CGFloat(completed) / CGFloat(total) * 100
    }
    
    var growthStage: GrowthStage {
        switch totalXP {
        case 0..<100: return .seed
        case 100..<300: return .sprout
        case 300..<600: return .youngPlant
        case 600..<1000: return .blooming
        default: return .flourishing
        }
    }
    
    init(profile: UserProfile? = nil) {
        if let profile {
            rituals = RitualEngine.generateRituals(for: profile)
        }
    }
    
    func notifyStageUpgrade(_ stage: GrowthStage) {
        print("Tree upgraded to \(stage)")
    }
    
    func recalculateXP() {
        let completedCount = rituals.filter { $0.isCompleted }.count
        
        var newTodayXP = completedCount * xpPerRitual
        
        if completedCount == rituals.count && rituals.count > 0 {
            newTodayXP += xpPerDayBonus
        }
        
        let difference = newTodayXP - todayXP
        
        totalXP += difference
        todayXP = newTodayXP
    }
        
//    func updateXPIfNeeded() {
//        let completedToday = rituals.filter { $0.isCompleted }.count
//        
//        totalXP += completedToday * xpPerRitual
//        
//        if completedToday == rituals.count && rituals.count > 0 {
//            totalXP += xpPerDayBonus
//        }
//        
//        //checkForStageUpgrade()
//    }
    
//    private func checkForStageUpgrade() {
//        let newStage: GrowthStage
//        
//        switch totalXP {
//        case 0..<100:
//            newStage = .seed
//        case 100..<300:
//            newStage = .sprout
//        case 300..<600:
//            newStage = .youngPlant
//        case 600..<1000:
//            newStage = .blooming
//        default:
//            newStage = .flourishing
//        }
//        
//        if newStage.rawValue != storedStage {
//            storedStage = newStage.rawValue
//            notifyStageUpgrade(newStage)
//        }
//    }
    
    func checkForDailyReset(profile: UserProfile) {
        let now = Date()
        let calendar = Calendar.current
        
        if !calendar.isDateInToday(Date(timeIntervalSince1970: lastResetDate)) {
            rituals = RitualEngine.generateRituals(for: profile)
            todayXP = 0
            lastResetDate = now.timeIntervalSince1970
        }
    }
}
