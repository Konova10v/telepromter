//
//  OnboardingView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import SwiftUI

struct OnboardingView: View {
	@ObservedObject var viewModel: OnboardingViewModel = OnboardingViewModel()
	
	var body: some View {
		VStack {
			switch viewModel.onboardingState {
				case .welcome:
					welcomeView()
				case .onboarding:
					OnbordingStepView(viewModel: viewModel)
				case .result:
					OnboardingResultView()
			}
		}
	}
	
	func welcomeView() -> some View {
		VStack {
			Image(.logo)
				.padding(.top, 10)
			
			Spacer()
			
			VStack(spacing: 20) {
				Text("Welcome to Teleprompter")
					.font(.system(size: 16))
					.foregroundColor(.white)
					.opacity(0.9)
				
				VStack(spacing: 0) {
					Text("Let’s Personalize Your")
						.foregroundColor(.white)
						.font(.system(size: 40))
						.bold()
					Text("Experience")
						.foregroundColor(.white)
						.font(.system(size: 40))
						.bold()
						.opacity(0.6)
				}
				
				Text("Answer a few quick questions to tailor Telepromper to your needs")
					.font(.system(size: 18))
					.foregroundColor(.neutralGrey)
					.multilineTextAlignment(.center)
					.padding(.horizontal, 40)
			}
			.padding(.bottom, 40)
			
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				Button(action: {
					viewModel.onboardingState = .onboarding
				}) {
					HStack {
						Spacer()
						
						Text("Let’s Start")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
						
						Spacer()
						
						Image(.arrowRight)
					}
						.frame(maxWidth: .infinity)
						.padding()
						.background(
							LinearGradient(
								gradient: Gradient(colors: [
									Color(red: 1, green: 0.39, blue: 0.22),
									Color.primaryOrange
								]),
								startPoint: .leading,
								endPoint: .trailing
								)
							)
							.clipShape(RoundedRectangle(cornerRadius: 16))
							.shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 3)
						.cornerRadius(16)
						.padding(.horizontal, 30)
				}
			}
		}
		.background(
			Image(.welcomeOnboardingBkg)
				.resizable()
				.scaledToFill()
				.frame(width: SizeScreen().width, height: SizeScreen().height)
				.scaleEffect(1.0)
				.clipped()
				.ignoresSafeArea()
		)
	}
}

struct OnboardingView_Previews: PreviewProvider {
	static var previews: some View {
		OnboardingView()
	}
}
