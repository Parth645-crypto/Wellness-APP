import SwiftUI

struct PlantView: View {
    var stage: GrowthStage
    
    var body: some View {
        Image(treeName)
            .resizable()
            .scaledToFit()
            .frame(height: 260)
            .scaleEffect(scaleValue)
            .opacity(opacityValue)
            .animation(.easeInOut(duration: 0.6), value: stage)
    }
    
    private var treeName: String {
        switch stage {
        case .seed:
            return "tree_seed"
        case .sprout:
            return "tree_seed"
        case .youngPlant:
            return "tree_young"
        case .blooming:
            return "tree_mature"
        case .flourishing:
            return "tree_blooming"
        }
    }
    
    private var scaleValue: CGFloat {
        switch stage {
        case .seed:
            return 0.7
        case .sprout:
            return 0.8
        case .youngPlant:
            return 0.9
        case .blooming:
            return 1.0
        case .flourishing:
            return 1.05
        }
    }
    
    private var opacityValue: Double {
        switch stage {
        case .seed:
            return 0.85
        default:
            return 1.0
        }
    }
}
