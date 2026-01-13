//
//  OnboardingResultView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import SwiftUI

struct OnboardingResultView: View {
    var body: some View {
		VStack {
			Text("Your Results are being personalized...")
				.foregroundStyle(.white)
				.font(.h3)
				.multilineTextAlignment(.center)
				.padding(.horizontal)
				.padding(.top)
			
			Spacer()
			
			Image(.bigLogo)
			
			Spacer()
			
			StepProgressView()
				.padding(.bottom)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.resultOnboarding)
				.resizable()
				.ignoresSafeArea()
		)
    }
}

#Preview {
    OnboardingResultView()
		.environmentObject(TelepromterViewModel())
}


struct StepProgressView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	let steps: [String] = ["Needs", "Requirements", "Expectations", "Customizing your experience"]
	
	@State private var currentStep = 0
	@State private var progresses: [CGFloat] = [0, 0, 0, 0]
	
	var body: some View {
		VStack(alignment: .leading, spacing: 20) {
			ForEach(steps.indices, id: \.self) { index in
				VStack(alignment: .leading) {
					HStack {
						Text(steps[index])
							.font(.bodyMedium)
							.foregroundColor(.white)
						Spacer()
						Text("\(Int(progresses[index] * 100))%")
							.font(.labelMedium)
							.foregroundColor(.white)
					}
					
					GeometryReader { geo in
						ZStack(alignment: .leading) {
							Capsule()
								.fill(Color.gray.opacity(0.3))
								.frame(height: 8)
							
							Capsule()
								.fill(Color.primaryOrange)
								.frame(width: geo.size.width * progresses[index], height: 8)
								.animation(.easeInOut(duration: 0.8), value: progresses[index])
						}
					}
					.frame(height: 8)
				}
			}
		}
		.padding()
		.onAppear {
			startProgress()
		}
	}
	
	func startProgress() {
		guard currentStep < steps.count else { return }
		
		Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
			progresses[currentStep] += 0.01
			
			if progresses[currentStep] >= 1 {
				progresses[currentStep] = 1
				timer.invalidate()
				currentStep += 1
				startProgress()
				
				if progresses.last == 1 {
					viewModel.screen = .mainScreen
				}
			}
		}
	}
}
