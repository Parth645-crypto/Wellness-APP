struct UserProfile: Codable {
    var sleepHours: Int
    var activityLevel: ActivityLevel
    var stressLevel: StressLevel
    var hydrationLevel: HydrationLevel
    var energyLevel: EnergyLevel  // 1–5
}

enum ActivityLevel: String, Codable {
    case low, moderate, high
}

enum StressLevel: String, Codable {
    case low, medium, high
}

enum HydrationLevel: String, Codable {
    case low, average, high
}

enum EnergyLevel: Int, Codable {
    case veryLow = 1
    case low = 2
    case medium = 3
    case high = 4
    case peak = 5
}
