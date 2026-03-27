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
    @AppStorage("lastResetDate") private var lastResetDate: Double = 0
    @Published var rituals: [Ritual] = []
    @AppStorage("emotionLog") private var emotionLogData: Data = Data()

    @Published var emotionHistory: [Mood] = []
    
    @AppStorage("lastEmotionTimestamp") private var lastEmotionTimestamp: Double = 0
    @Published var currentEmotion: Mood = .happy
    @AppStorage("currentLevel") var currentLevel: Int = 1
    @AppStorage("xpInCurrentLevel") var xpInCurrentLevel: Int = 0

    let xpPerLevel = 100
    

    private let emotionCooldownMinutes = 5
    private let emotionXP = 3
    
    private let xpPerRitual = 10
    private let xpPerDayBonus = 20
    
    var score: CGFloat {
        let completed = rituals.filter { $0.isCompleted }.count
        let total = rituals.count
        return total == 0 ? 0 : CGFloat(completed) / CGFloat(total) * 100
    }
    
    var growthStage: GrowthStage {
        switch currentLevel {
        case 1...2: return .seed
        case 3...4: return .sprout
        case 5...6: return .youngPlant
        case 7...8: return .blooming
        default: return .flourishing
        }
    }
    
    init(profile: UserProfile? = nil) {
        loadEmotionHistory()
        
        if let profile {
            rituals = RitualEngine.generateRituals(for: profile)
        }
    }
    
    func notifyStageUpgrade(_ stage: GrowthStage) {
        print("Tree upgraded to \(stage)")
    }
    
    func regenerateRituals(profile: UserProfile) {
        let dominantEmotion = mostFrequentEmotion()
        
        rituals = RitualEngine.generateRituals(
            for: profile,
            emotion: dominantEmotion
        )
    }
    
    func remainingEmotionCooldown() -> String {
        
        let now = Date()
        let lastChange = Date(timeIntervalSince1970: lastEmotionTimestamp)
        
        let elapsed = now.timeIntervalSince(lastChange)
        let totalCooldown = TimeInterval(emotionCooldownMinutes * 60)
        
        let remaining = totalCooldown - elapsed
        
        if remaining <= 0 {
            return "0s"
        }
        
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        
        return minutes > 0
            ? "\(minutes)m \(seconds)s"
            : "\(seconds)s"
    }
    
    private func addXP(_ amount: Int) {
        xpInCurrentLevel += amount
        totalXP += amount

        while xpInCurrentLevel >= xpPerLevel {
            xpInCurrentLevel -= xpPerLevel
            currentLevel += 1
        }
    }

    private func removeXP(_ amount: Int) {
        xpInCurrentLevel -= amount
        totalXP -= amount

        if xpInCurrentLevel < 0 {
            xpInCurrentLevel = 0
        }

        if totalXP < 0 {
            totalXP = 0
        }
    }
    
    func setEmotion(
        _ mood: Mood,
        profile: UserProfile
    ) -> Bool {
        
        let now = Date()
        let lastChange = Date(timeIntervalSince1970: lastEmotionTimestamp)
        
        let diff = Calendar.current.dateComponents([.minute],
                                                   from: lastChange,
                                                   to: now).minute ?? 0
        
        if diff < emotionCooldownMinutes {
            return false
        }
        
        // ✅ Allowed
        
        currentEmotion = mood
        lastEmotionTimestamp = now.timeIntervalSince1970
        
        //totalXP += emotionXP
        addXP(emotionXP)
        saveEmotion(mood)   // 🔥 you forgot this
        
        print("Emotion changed to:", mood)
        print("Total rituals:", rituals.count)
        print("Emotion ritual included:",
              rituals.contains(where: { $0.type == .recovery }))
        
        return true
    }
    
    private func saveEmotion(_ mood: Mood) {
        emotionHistory.append(mood)
        if let encoded = try? JSONEncoder().encode(emotionHistory) {
            emotionLogData = encoded
        }
    }

    private func loadEmotionHistory() {
        if let decoded = try? JSONDecoder().decode([Mood].self, from: emotionLogData) {
            emotionHistory = decoded
        }
    }
    
    func toggleRitual(_ ritual: Ritual) {
        guard let index = rituals.firstIndex(where: { $0.id == ritual.id }) else { return }

        rituals[index].isCompleted.toggle()

        if rituals[index].isCompleted {
            addXP(xpPerRitual)
        } else {
            removeXP(xpPerRitual)
        }
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
            regenerateRituals(profile: profile)
            lastResetDate = now.timeIntervalSince1970
        }
    }
    
    private func mostFrequentEmotion() -> Mood? {
        let counts = Dictionary(grouping: emotionHistory, by: { $0 })
            .mapValues { $0.count }
        
        return counts.max(by: { $0.value < $1.value })?.key
    }
}
