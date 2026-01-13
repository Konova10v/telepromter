//
//  OnboardingViewModel.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import Foundation

enum OnboardingState {
	case welcome
	case onboarding
	case result
}

class OnboardingViewModel: ObservableObject {
	@Published var onboardingState: OnboardingState = .onboarding
}
