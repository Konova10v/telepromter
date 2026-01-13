//
//  OnboardingProgressIndicator.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import SwiftUI

struct OnboardingProgressIndicator: View {
	var totalSteps: Int
	var currentStep: Int

	var body: some View {
		HStack(spacing: 5) {
			ForEach(0..<totalSteps, id: \.self) { index in
				Capsule()
					.fill(index <= currentStep ? Color.primaryOrange : Color.white.opacity(0.2))
					.frame(height: 2)
					.frame(maxWidth: .infinity)
			}
		}
		.frame(width: SizeScreen().width - 32)
		.animation(.easeInOut(duration: 0.3), value: currentStep)
	}
}
