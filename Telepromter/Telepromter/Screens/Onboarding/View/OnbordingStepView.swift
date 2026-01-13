//
//  OnbordingStepView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

enum OnbordingStep {
	case step1
	case step2
	case step3
	case step4
	case step5
}

enum UsePlan {
	case Education
	case Personal
	case Business
	case empty
}

enum Script {
	case Video
	case LiveStreams
	case Presentations
	case empty
}

enum Experience {
	case Beginner
	case Intermediate
	case Advanced
	case empty
}

enum OftenUse {
	case Daily
	case Weekly
	case Montly
	case Occasionally
	case empty
}

enum Goals {
	case Reduce
	case Simplify
	case Enhance
	case empty
}

import SwiftUI

struct OnbordingStepView: View {
	@ObservedObject var viewModel: OnboardingViewModel
	
	@State var stepOnbording: OnbordingStep = .step1
	@State var currentStep = 0
	let totalSteps = 5
	
	@State var selectPlan: UsePlan = .empty
	
	@State var isEducationSelect = false
	@State var isPersonalSelect = false
	@State var isBusinessSelect = false
	
	@State var selectScript: Script = .empty
	@State var isVideoSelect: Bool = false
	@State var isLiveStreamsSelect: Bool = false
	@State var isPresentationsSelect: Bool = false
	
	@State var selectExperience: Experience = .empty
	@State var isBeginnerSelect: Bool = false
	@State var isIntermediateSelect: Bool = false
	@State var isAdvancedSelect: Bool = false
	
	@State var selectOftenUse: OftenUse = .empty
	@State var isDailySelect: Bool = false
	@State var isWeeklySelect: Bool = false
	@State var isMontlySelect: Bool = false
	@State var isOccasionallySelect: Bool = false
	
	@State var selectGoals: Goals = .empty
	@State var isReduceSelect: Bool = false
	@State var isSimplifySelect: Bool = false
	@State var isEnhanceSelect: Bool = false
	
    var body: some View {
		VStack(spacing: 10) {
			ZStack(alignment: .top) {
				ZStack(alignment: .bottomLeading) {
					switch stepOnbording {
						case .step1:
							Image(.onbordingStep1)
								.resizable()
								.edgesIgnoringSafeArea(.top)
								.frame(width: SizeScreen().width, height: SizeScreen().height / 2.2)
						case .step2:
							Image(.onbordingStep2)
								.resizable()
								.edgesIgnoringSafeArea(.top)
								.frame(width: SizeScreen().width, height: SizeScreen().height / 2.2)
						case .step3:
							Image(.onbordingStep3)
								.resizable()
								.edgesIgnoringSafeArea(.top)
								.frame(width: SizeScreen().width, height: SizeScreen().height / 2.2)
						case .step4:
							Image(.onbordingStep4)
								.resizable()
								.edgesIgnoringSafeArea(.top)
								.frame(width: SizeScreen().width, height: SizeScreen().height / 2.2)
						case .step5:
							Image(.onbordingStep5)
								.resizable()
								.edgesIgnoringSafeArea(.top)
								.frame(width: SizeScreen().width, height: SizeScreen().height / 2.2)
					}
					
					switch stepOnbording {
						case .step1:
							Text("What do you plan to use the Teleprompter for?")
								.foregroundStyle(.white)
								.font(.h4)
								.padding(.horizontal)
						case .step2:
							Text("What kind of scripts will you be using?")
								.foregroundStyle(.white)
								.font(.h4)
								.padding(.horizontal)
						case .step3:
							Text("What's your experience with Teleprompters?")
								.foregroundStyle(.white)
								.font(.h4)
								.padding(.horizontal)
						case .step4:
							Text("How often will you use the Teleprompter app?")
								.foregroundStyle(.white)
								.font(.h4)
								.padding(.horizontal)
						case .step5:
							Text("What are your key goals for using a Teleprompter?")
								.foregroundStyle(.white)
								.font(.h4)
								.padding(.horizontal)
					}
				}
				
				OnboardingProgressIndicator(totalSteps: totalSteps,
											currentStep: currentStep)
				.padding(.top)
			}
			
			switch stepOnbording {
				case .step1:
					stepOneView()
				case .step2:
					stepTwoView()
				case .step3:
					stepThreeView()
				case .step4:
					stepFourView()
				case .step5:
					stepFiveView()
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.darkBkg)
				.resizable()
				.ignoresSafeArea()
		)
    }
	
	func stepOneView() -> some View {
		VStack {
			VStack(spacing: 10) {
				SelectableButton(
					title: "Education",
					systemIcon: Image(.education),
					isSelected: $isEducationSelect,
					count: 3
				) {
					isEducationSelect = true
					isPersonalSelect = false
					isBusinessSelect = false
					selectPlan = .Education
				}
				
				SelectableButton(
					title: "Personal",
					systemIcon: Image(.personal),
					isSelected: $isPersonalSelect,
					count: 3
				) {
					isPersonalSelect = true
					isEducationSelect = false
					isEducationSelect = false
					selectPlan = .Personal
				}
				
				SelectableButton(
					title: "Business",
					systemIcon: Image(.case),
					isSelected: $isBusinessSelect,
					count: 3
				) {
					isBusinessSelect = true
					isEducationSelect = false
					isPersonalSelect = false
					selectPlan = .Business
				}
			}
			.padding(.horizontal)
			.padding(.top)
			
			Spacer()
			
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				if selectPlan != .empty{
					Button(action: {
						stepOnbording = .step2
						currentStep += 1
					}) {
						HStack {
							Spacer()
							
							Text("Continue")
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
				} else {
					HStack {
						Spacer()
						
						Text("Continue")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
						
						Spacer()
						
						Image(.arrowRight)
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.white.opacity(0.04))
					)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(
								LinearGradient(
									gradient: Gradient(colors: [
										Color.white.opacity(0.2),
										Color.white.opacity(0.05)
									]),
									startPoint: .top,
									endPoint: .bottom
								),
								lineWidth: 1
							)
					)
					.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
					.cornerRadius(16)
					.padding(.horizontal, 30)
				}
			}
		}
	}
	
	func stepTwoView() -> some View {
		VStack {
			VStack(spacing: 10) {
				SelectableButton(
					title: "Videos",
					systemIcon: Image(.video),
					isSelected: $isVideoSelect,
					count: 3
				) {
					isVideoSelect = true
					isLiveStreamsSelect = false
					isPresentationsSelect = false
					selectScript = .Video
				}
				
				SelectableButton(
					title: "Live Streams",
					systemIcon: Image(.videoSquare),
					isSelected: $isLiveStreamsSelect,
					count: 3
				) {
					isVideoSelect = false
					isLiveStreamsSelect = true
					isPresentationsSelect = false
					selectScript = .LiveStreams
				}
				
				SelectableButton(
					title: "Presentations",
					systemIcon: Image(.videoSquare),
					isSelected: $isPresentationsSelect,
					count: 3
				) {
					isVideoSelect = false
					isLiveStreamsSelect = false
					isPresentationsSelect = true
					selectScript = .LiveStreams
				}
			}
			.padding(.horizontal)
			.padding(.top)
			
			Spacer()
			
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				if selectScript != .empty{
					Button(action: {
						stepOnbording = .step3
						currentStep += 1
					}) {
						HStack {
							Spacer()
							
							Text("Continue")
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
				} else {
					HStack {
						Spacer()
						
						Text("Continue")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
						
						Spacer()
						
						Image(.arrowRight)
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.white.opacity(0.04))
					)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(
								LinearGradient(
									gradient: Gradient(colors: [
										Color.white.opacity(0.2),
										Color.white.opacity(0.05)
									]),
									startPoint: .top,
									endPoint: .bottom
								),
								lineWidth: 1
							)
					)
					.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
					.cornerRadius(16)
					.padding(.horizontal, 30)
				}
			}
		}
	}
	
	func stepThreeView() -> some View {
		VStack {
			VStack(spacing: 10) {
				SelectableButton(
					title: "Beginner",
					systemIcon: Image(.beginner),
					isSelected: $isBeginnerSelect,
					count: 3
				) {
					isBeginnerSelect = true
					isIntermediateSelect = false
					isAdvancedSelect = false
					selectExperience = .Beginner
				}
				
				SelectableButton(
					title: "Intermediate",
					systemIcon: Image(.intermediate),
					isSelected: $isIntermediateSelect,
					count: 3
				) {
					isBeginnerSelect = false
					isIntermediateSelect = true
					isAdvancedSelect = false
					selectExperience = .Intermediate
				}
				
				SelectableButton(
					title: "Advanced",
					systemIcon: Image(.advanced),
					isSelected: $isAdvancedSelect,
					count: 3
				) {
					isBeginnerSelect = false
					isIntermediateSelect = false
					isAdvancedSelect = true
					selectExperience = .Advanced
				}
			}
			.padding(.horizontal)
			.padding(.top)
			
			Spacer()
			
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				if selectExperience != .empty{
					Button(action: {
						stepOnbording = .step4
						currentStep += 1
					}) {
						HStack {
							Spacer()
							
							Text("Continue")
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
				} else {
					HStack {
						Spacer()
						
						Text("Continue")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
						
						Spacer()
						
						Image(.arrowRight)
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.white.opacity(0.04))
					)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(
								LinearGradient(
									gradient: Gradient(colors: [
										Color.white.opacity(0.2),
										Color.white.opacity(0.05)
									]),
									startPoint: .top,
									endPoint: .bottom
								),
								lineWidth: 1
							)
					)
					.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
					.cornerRadius(16)
					.padding(.horizontal, 30)
				}
			}
		}
	}
	
	func stepFourView() -> some View {
		VStack {
			VStack(spacing: 10) {
				SelectableButton(
					title: "Daily",
					systemIcon: Image(.daily),
					isSelected: $isDailySelect,
					count: 4
				) {
					isDailySelect = true
					isWeeklySelect = false
					isMontlySelect = false
					isOccasionallySelect = false
					selectOftenUse = .Daily
				}
				
				SelectableButton(
					title: "Weekly",
					systemIcon: Image(.weekly),
					isSelected: $isWeeklySelect,
					count: 4
				) {
					isDailySelect = false
					isWeeklySelect = true
					isMontlySelect = false
					isOccasionallySelect = false
					selectOftenUse = .Weekly
				}
				
				SelectableButton(
					title: "Montly",
					systemIcon: Image(.montly),
					isSelected: $isMontlySelect,
					count: 4
				) {
					isDailySelect = false
					isWeeklySelect = false
					isMontlySelect = true
					isOccasionallySelect = false
					selectOftenUse = .Montly
				}
				
				SelectableButton(
					title: "Occasionally",
					systemIcon: Image(.occasionally),
					isSelected: $isOccasionallySelect,
					count: 4
				) {
					isDailySelect = false
					isWeeklySelect = false
					isMontlySelect = false
					isOccasionallySelect = true
					selectOftenUse = .Occasionally
				}
			}
			.padding(.horizontal)
			.padding(.top)
			
			Spacer()
			
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				if selectOftenUse != .empty{
					Button(action: {
						stepOnbording = .step5
						currentStep += 1
					}) {
						HStack {
							Spacer()
							
							Text("Continue")
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
				} else {
					HStack {
						Spacer()
						
						Text("Continue")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
						
						Spacer()
						
						Image(.arrowRight)
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.white.opacity(0.04))
					)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(
								LinearGradient(
									gradient: Gradient(colors: [
										Color.white.opacity(0.2),
										Color.white.opacity(0.05)
									]),
									startPoint: .top,
									endPoint: .bottom
								),
								lineWidth: 1
							)
					)
					.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
					.cornerRadius(16)
					.padding(.horizontal, 30)
				}
			}
		}
	}
	
	func stepFiveView() -> some View {
		VStack {
			VStack(spacing: 10) {
				SelectableButton(
					title: "Reduce preparation time",
					systemIcon: Image(.timer),
					isSelected: $isReduceSelect,
					count: 3
				) {
					isReduceSelect = true
					isSimplifySelect = false
					isEnhanceSelect = false
					selectGoals = .Reduce
				}
				
				SelectableButton(
					title: "Simplify my script reading",
					systemIcon: Image(.book),
					isSelected: $isSimplifySelect,
					count: 3
				) {
					isReduceSelect = false
					isSimplifySelect = true
					isEnhanceSelect = false
					selectGoals = .Simplify
				}
				
				SelectableButton(
					title: "Enhance video content quality",
					systemIcon: Image(.arrowUp),
					isSelected: $isEnhanceSelect,
					count: 3
				) {
					isReduceSelect = false
					isSimplifySelect = false
					isEnhanceSelect = true
					selectGoals = .Enhance
				}
			}
			.padding(.horizontal)
			.padding(.top)
			
			Spacer()
			
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				if selectGoals != .empty {
					Button(action: {
						viewModel.onboardingState = .result
					}) {
						HStack {
							Spacer()
							
							Text("Continue")
								.font(.bodyMedium)
								.bold()
								.foregroundColor(.white)
							
							Spacer()
							
							Image(.save)
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
				} else {
					HStack {
						Spacer()
						
						Text("Continue")
							.font(.bodyMedium)
							.bold()
							.foregroundColor(.white)
						
						Spacer()
						
						Image(.arrowRight)
					}
					.frame(maxWidth: .infinity)
					.padding()
					.background(
						RoundedRectangle(cornerRadius: 20)
							.fill(Color.white.opacity(0.04))
					)
					.overlay(
						RoundedRectangle(cornerRadius: 20)
							.stroke(
								LinearGradient(
									gradient: Gradient(colors: [
										Color.white.opacity(0.2),
										Color.white.opacity(0.05)
									]),
									startPoint: .top,
									endPoint: .bottom
								),
								lineWidth: 1
							)
					)
					.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
					.cornerRadius(16)
					.padding(.horizontal, 30)
				}
			}
		}
	}
}

#Preview {
	OnbordingStepView(viewModel: OnboardingViewModel())
}
