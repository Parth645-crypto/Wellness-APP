//
//  Welcome.swift
//  Wellness App 1
//
//  Created by SDC-USER on 13/02/26.
//

import SwiftUI

struct WelcomeView: View {

    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 0.92, green: 0.96, blue: 0.94),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {

                Spacer()

                // Header
                VStack(spacing: 6) {
                    Text("Rooted")
                        .font(.system(size: 40, weight: .black))

                    Text("Your Personal Ecosystem")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Hero Image
                Image("blossom_tree")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 240)

                Spacer()

                // Copy
                VStack(spacing: 12) {
                    Text("Grow with intention.")
                        .font(.title3.weight(.semibold))

                    Text("Answer a few simple questions and discover your growth stage. We’ll build your daily ritual checklist from there.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 40)
                }

                Spacer()

                // CTA
                Button {
                    hasSeenWelcome = true
                } label: {
                    Text("Begin My Journey")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.horizontal, 30)

                Spacer()
            }
        }
    }
}
