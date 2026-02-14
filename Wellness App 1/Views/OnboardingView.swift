//
//  OnboardingView.swift
//  Wellness App 1
//
//  Created by SDC-USER on 12/02/26.
//

import SwiftUI

struct OnboardingView: View {

    @StateObject private var vm = OnboardingViewModel()
    @State private var showResult = false

    var body: some View {
        ZStack {

            // 🌿 Background Gradient (Brand Feel)
            LinearGradient(
                colors: vm.currentQuestion.category.gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.4), value: vm.currentIndex)

            VStack {

                topSection

                Spacer()

                questionCard

                Spacer()

                continueButton
            }
            .padding(24)
        }
        .fullScreenCover(isPresented: $showResult) {
                OnboardingResultView(
                    stage: vm.growthStage(),
                    score: vm.calculateOverallScore()
                ) {
                    showResult = false
                    // Later: navigate to dashboard here
                }
            }
    }
    
    var topSection: some View {
        VStack(spacing: 16) {

            HStack {
                if vm.currentIndex > 0 {
                    Button {
                        vm.previous()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }

                Spacer()

                Text("\(vm.currentIndex + 1)/\(vm.questions.count)")
                    .font(.caption.bold())
                    .foregroundColor(.secondary)
            }

            ProgressView(value: vm.progress)
                .tint(Color(red: 0.35, green: 0.75, blue: 0.70))
                .scaleEffect(x: 1, y: 1.8, anchor: .center)
                .animation(.easeInOut(duration: 0.3), value: vm.progress)
        }
    }
    
    var questionCard: some View {
        VStack(spacing: 28) {

            let accent = vm.currentQuestion.category.accent

            Image(systemName: vm.currentQuestion.icon)
                .font(.system(size: 36))
                .foregroundColor(accent)
                .padding(30)
                .background(
                    Circle()
                        .fill(accent.opacity(0.18))
                )

            Text(vm.currentQuestion.title)
                .font(.title2.bold())
                .multilineTextAlignment(.center)

            VStack(spacing: 14) {
                ForEach(Array(vm.currentQuestion.options.enumerated()), id: \.element.id) { index, option in

                    Button {
                        vm.selectOption(option, index: index)
                    } label: {
                        HStack {
                            Text(option.text)
                                .font(.headline)
                                .foregroundColor(.black)

                            Spacer()

                            if vm.selectedOptionIndex == index {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(vm.currentQuestion.category.accent)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(
                                    vm.selectedOptionIndex == index
                                    ? vm.currentQuestion.category.accent.opacity(0.12)
                                    : Color.white.opacity(0.9)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(
                                            vm.selectedOptionIndex == index
                                            ? vm.currentQuestion.category.accent
                                            : Color.clear,
                                            lineWidth: 1.5
                                        )
                                )
                                .shadow(
                                    color: vm.selectedOptionIndex == index
                                        ? Color.black.opacity(0.08)
                                        : .clear,
                                    radius: 6,
                                    y: 3
                                )
                        )
                        .scaleEffect(vm.selectedOptionIndex == index ? 1.02 : 1.0)
                        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: vm.selectedOptionIndex)
                    }
                }
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.3))
                )
        )
    }
    
    var continueButton: some View {
        Button {
            if vm.currentIndex == vm.questions.count - 1 {
                // go to result
                showResult = true
            } else {
                vm.next()
                vm.selectedOptionIndex = nil
            }
        } label: {
            Text(vm.currentIndex == vm.questions.count - 1 ? "Finish" : "Continue")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    vm.selectedOptionIndex == nil
                    ? Color.black.opacity(0.2)
                    : Color.black
                )
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .disabled(vm.selectedOptionIndex == nil)
    }
}
