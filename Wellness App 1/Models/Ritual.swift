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
