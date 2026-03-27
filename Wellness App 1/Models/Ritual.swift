//
//  Ritual.swift
//  Wellness App 1
//
//  Created by SDC-USER on 17/02/26.
//

import SwiftUI

enum RitualType {
    case core
    case adaptive
    case recovery
    case growth
}

struct Ritual: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
    let category: RitualCategory
    let icon: String
    let type: RitualType
    
    // 🔥 NEW FIELDS (INTELLIGENCE)
    let difficulty: Int        // 1 (easy) → 5 (hard)
    let energyRequired: Int    // 1 (low) → 5 (high)
    let duration: Int          // in minutes
    let tags: [String]         // ["focus", "recovery", "social"]
    
    var isCompleted: Bool = false
    
    static func == (lhs: Ritual, rhs: Ritual) -> Bool {
        lhs.id == rhs.id &&
        lhs.isCompleted == rhs.isCompleted
    }
}

enum RitualCategory: String {
    case physical = "PHYSICAL"
    case mental = "MENTAL"
    case emotional = "EMOTIONAL"
    
    var color: Color {
        switch self {
        case .physical: return .blue
        case .mental: return .purple
        case .emotional: return .pink
        }
    }
}
