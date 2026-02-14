//
//  OnboardingViewModel.swift
//  Wellness App 1
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {

    @Published var currentIndex: Int = 0
    @Published var answers: [Double] = []
    @Published var selectedOptionIndex: Int? = nil

    let questions = OnboardingQuestion.all

    var currentQuestion: OnboardingQuestion {
        questions[currentIndex]
    }

    var progress: Double {
        Double(currentIndex) / Double(questions.count)
    }

    func selectOption(_ option: OnboardingOption, index: Int) {
        selectedOptionIndex = index

        if answers.count > currentIndex {
            answers[currentIndex] = option.score
        } else {
            answers.append(option.score)
        }
    }
    func next() {
        if currentIndex < questions.count - 1 {
            currentIndex += 1
        }
    }

    func calculateOverallScore() -> Double {
        guard !answers.isEmpty else { return 0 }
        return answers.reduce(0, +) / Double(answers.count)
    }
    
    func previous() {
        if currentIndex > 0 {
            currentIndex -= 1
            selectedOptionIndex = nil
        }
    }
    
    func growthStage() -> GrowthStage {
        let score = calculateOverallScore()

        switch score {
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
}
