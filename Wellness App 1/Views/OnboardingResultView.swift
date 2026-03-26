//
//  OnboardingResultView.swift
//  Wellness App 1
//
//  Created by SDC-USER on 13/02/26.
//

import SwiftUI

struct OnboardingResultView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("currentLevel") private var currentLevel: Int = 1
    @AppStorage("xpInCurrentLevel") private var xpInCurrentLevel: Int = 0
    @AppStorage("totalXP") private var totalXP: Int = 0
    let stage: GrowthStage
    let score: Double
    var onContinue: () -> Void

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [Color.white, Color.green.opacity(0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                Spacer()

                Image(stage.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                Text(stage.title)
                    .font(.largeTitle.bold())

                Text(stage.message)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Spacer()

                Button {
                    currentLevel = stage.startingLevel
                    xpInCurrentLevel = 0
                    totalXP = stage.startingXP// 🔥 THIS saves the result
                    hasCompletedOnboarding = true
                    onContinue()
                } label: {
                    Text("Enter My Garden")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .padding(30)
        }
    }
}
