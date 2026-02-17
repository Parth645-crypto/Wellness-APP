//
//  GrowthStage.swift
//  Wellness App
//
//  Created by SDC-USER on 06/02/26.
//

import CoreFoundation

enum GrowthStage: String {
    case seed
    case sprout
    case youngPlant
    case blooming
    case flourishing

    static func stage(for score: CGFloat) -> GrowthStage {
        switch score {
        case 0..<20: return .seed
        case 20..<40: return .sprout
        case 40..<60: return .youngPlant
        case 60..<80: return .blooming
        default: return .flourishing
        }
    }

    var startingXP: Int {
        switch self {
        case .seed: return 0
        case .sprout: return 120
        case .youngPlant: return 350
        case .blooming: return 700
        case .flourishing: return 1200
        }
    }
}

extension GrowthStage {

    var title: String {
        switch self {
        case .seed: return "Seed"
        case .sprout: return "Sprout"
        case .youngPlant: return "Young Plant"
        case .blooming: return "Blooming"
        case .flourishing: return "Flourishing"
        }
    }

    var message: String {
        switch self {
        case .seed:
            return "You're just getting started. Small daily rituals will unlock powerful growth."
            
        case .sprout:
            return "You’ve taken the first step. A little consistency will strengthen your roots."
            
        case .youngPlant:
            return "You’re growing steadily. Stay consistent and your ecosystem will flourish."
            
        case .blooming:
            return "You’re thriving beautifully. Keep nurturing your habits and blossom fully."
        case .flourishing:
            return "You’re a tree of life! Keep nurturing and you’ll continue to grow and thrive."
        }
    }

    var imageName: String {
        switch self {
        case .seed: return "seed"
        case .sprout: return "sprout"
        case .youngPlant: return "young_plant"
        case .blooming: return "mature_tree"
        case .flourishing: return "blossom_tree"
        }
    }
}
