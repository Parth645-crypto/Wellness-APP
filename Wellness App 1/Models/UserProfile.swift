struct UserProfile: Codable {
    var sleepHours: Int
    var activityLevel: ActivityLevel
    var stressLevel: StressLevel
    var hydrationLevel: HydrationLevel
}

enum ActivityLevel: String, Codable {
    case low, moderate, high
}

enum StressLevel: String, Codable {
    case low, medium, high
}

enum HydrationLevel: String, Codable {
    case poor, average, good
}
