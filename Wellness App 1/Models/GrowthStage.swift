//
//  GrowthStage.swift
//  Wellness App
//
//  Created by SDC-USER on 06/02/26.
//
enum GrowthStage {
    case seed
    case sprout
    case youngPlant
    case blooming
    case flourishing
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
