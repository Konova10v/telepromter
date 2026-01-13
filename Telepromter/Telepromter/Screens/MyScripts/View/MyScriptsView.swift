//
//  MyScriptsView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 05.08.2025.
//

import SwiftUI

struct MyScriptsView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	@StateObject private var recordingViewModel = RecordingViewModel()
	
    var body: some View {
		ZStack(alignment: .bottomTrailing) {
			VStack(spacing: 16) {
				HStack {
					Button {
						withAnimation {
							viewModel.showMenu = true
							}
					} label: {
						Image(.settings)
					}
					
					Spacer()
					
					Text("My Scripts")
						.foregroundStyle(.white)
						.font(.labelLarge)
						.padding(.leading, 20)
					
					Spacer()
					
					Button {
						viewModel.showPaywall.toggle()
					} label: {
						Image(.proBadge)
					}
				}
				.padding(.top)
				.padding(.leading)
				.padding(.trailing)
				
				if recordingViewModel.recordings.isEmpty {
					cellView()
					
					Spacer()
					
					emptyView()
					
					Spacer()
				} else {
					ScrollView {
						cellView()
						
						VStack {
							ForEach(recordingViewModel.recordings, id: \.id) { recording in
								scriptCell(name: recording.createdAt ?? "",
										   script: recording.scriptText ?? "",
										   video: recording.videoURL ?? "",
										   recording: recording)
							}
						}
						.padding(.top)
					}
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(
				Image(.darkBkg)
					.resizable()
					.ignoresSafeArea()
			)
			
			Button {
				viewModel.isPresentingAddScript = true
			} label: {
				Image(.addButton)
			}
			.padding()
		}
//		.sheet(isPresented: $viewModel.isPresentingAddScript) {
//			AddScriptView()
//				.presentationBackground(Color.black)
//		}
		.fullScreenCover(isPresented: $viewModel.isPresentingAddScript) {
			AddScriptView()
		}
    }
	
	func emptyView() -> some View {
		VStack(spacing: 20) {
			Image(.emptyScript)
			
			Text("You have no scripts yet.")
				.foregroundStyle(.white)
				.font(.labelLarge)
			
			Text("Press “+” to create your first skript with Teleprompter")
				.foregroundStyle(.neutralGrey)
				.font(.labelLarge)
				.multilineTextAlignment(.center)
		}
		.padding(.horizontal)
	}
	
	func cellView() -> some View {
		Button {
			viewModel.showPaywall.toggle()
		} label: {
			VStack(spacing: 0) {
				ZStack(alignment: .leading) {
					ZStack {
						Image(.cellBkg)
							.resizable()
							.scaledToFill()
							.frame(width: SizeScreen().width - 32, height: SizeScreen().height / 6.5)
							.scaleEffect(1.2)
							.offset(y: 30)
							.offset(x: -20)
							.clipped()
							.cornerRadius(16)
						
						
						LinearGradient(
							gradient: Gradient(colors: [Color.black.opacity(0.50),
														Color.black.opacity(0.30)]),
							startPoint: .leading,
							endPoint: .trailing
						)
						.frame(width: SizeScreen().width - 32, height: SizeScreen().height / 6.5)
					}
					
					VStack(alignment: .leading, spacing: 15) {
						Text("Limited Time Offer")
							.foregroundStyle(.white)
							.font(.labelLarge)
						
						CountdownTimer()
							.padding(.top)
					}
					.padding(.leading, 10)
				}
				.overlay(
					VStack(spacing: 0) {
						LinearGradient(
							gradient: Gradient(colors: [
								Color.white.opacity(0.1), // сверху яркий белый
								Color.white.opacity(0.0)  // вниз исчезает
							]),
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
						.frame(height: 2) // "глубина" градиента внутрь карточки
						Spacer()
					}
					.cornerRadius(16, corners: [.topLeft, .topRight]),
					alignment: .top
				)
				.shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
				
				HStack {
					Image(.discountShape)
					
					Text("Get Premium with 40% OFF!")
						.foregroundStyle(.primaryOrange)
						.font(.labelSmall)
				}
				.frame(width: SizeScreen().width - 64)
				.padding(.vertical, 6)
				.background(Color.primaryOrange.opacity(0.15))
				.clipShape(RoundedCorner(radius: 12, corners: [.bottomLeft, .bottomRight]))
			}
			.allowsHitTesting(false)
		}
	}
	
	func scriptCell(name: String, script: String, video: String, recording: RecordingEntity) -> some View {
		VStack(spacing: 12) {
			VStack(spacing: 15) {
				VStack(alignment: .leading, spacing: 21) {
					Text(name)
						.font(.labelMedium)
						.foregroundStyle(.white)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					Text(script)
						.lineLimit(2)
						.font(.bodyMedium)
						.foregroundStyle(.neutralGrey)
						.frame(maxWidth: .infinity, alignment: .leading)
				}
				
				GeometryReader { geometry in
					let width = geometry.size.width
					let spacing: CGFloat = 8
					let dotSize: CGFloat = 3
					let count = Int(width / spacing)
					
					HStack(spacing: spacing - dotSize) {
						ForEach(0..<count, id: \.self) { _ in
							Circle()
								.fill(Color.white.opacity(0.1))
								.frame(width: dotSize, height: dotSize)
						}
					}
					.frame(width: width, height: dotSize)
				}
				.frame(height: 6)
			}
			
			HStack(spacing: 8) {
				Button {
					recordingViewModel.deleteRecording(recording)
				} label: {
					Image(.delete)
						.resizable()
						.frame(width: 15, height: 15)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
				.frame(width: SizeScreen().width / 3.8, height: 28)
				.background(Color.primaryOrange.opacity(0.06))
				.cornerRadius(8)
				
				Button {
					viewModel.editScript.toggle()
				} label: {
					Image(.edit)
						.resizable()
						.frame(width: 15, height: 15)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
				.frame(width: SizeScreen().width / 3.8, height: 28)
				.background(Color.white.opacity(0.06))
				.cornerRadius(8)
				
				Button {
					
				} label: {
					Image(.play)
						.resizable()
						.frame(width: 15, height: 15)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
				}
				.frame(width: SizeScreen().width / 3.8, height: 28)
				.background(Color.white.opacity(0.06))
				.cornerRadius(8)

			}
		}
		.padding()
		.background(Color.white.opacity(0.12))
		.cornerRadius(16)
		.padding(.horizontal)
		.fullScreenCover(isPresented: $viewModel.editScript) {
			EditScriptView(title: name, script: script, entity: recording)
		}
	}
}

#Preview {
    MyScriptsView()
		.environmentObject(TelepromterViewModel())
}


struct CountdownTimer: View {
	@State private var hours: Int = 12
	@State private var minutes: Int = 8
	@State private var seconds: Int = 56

	var body: some View {
		HStack(spacing: 6) {
			Text("12")
				.foregroundColor(.white)
				.font(.labelMedium)
				.frame(width: 32, height: 32)
				.background(Color.white.opacity(0.1))
				.clipShape(RoundedCorner(radius: 100, corners: [.topLeft, .bottomLeft]))
				.clipShape(RoundedCorner(radius: 8, corners: [.topRight, .bottomRight]))
			
			Text(":")
				.foregroundColor(.white)
				.font(.labelMedium)
			
			Text("8")
				.foregroundColor(.white)
				.font(.labelMedium)
				.frame(width: 32, height: 32)
				.background(Color.white.opacity(0.1))
				.clipShape(RoundedRectangle(cornerRadius: 8))
			
			Text(":")
				.foregroundColor(.white)
				.font(.labelMedium)
			
			Text("56")
				.foregroundColor(.white)
				.font(.labelMedium)
				.frame(width: 32, height: 32)
				.background(Color.white.opacity(0.1))
				.clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .bottomLeft]))
				.clipShape(RoundedCorner(radius: 100, corners: [.topRight, .bottomRight]))
//				.overlay(
//					RoundedRectangle(cornerRadius: 12)
//						.stroke(Color.white.opacity(0.2), lineWidth: 1)
//				)
		}
		.padding(8)
		.background(Color.black.opacity(0.35))
		.clipShape(RoundedRectangle(cornerRadius: 100))
		.overlay(
			RoundedRectangle(cornerRadius: 100)
				.stroke(Color.white.opacity(0.15), lineWidth: 1) // лёгкий бордер
		)
	}
}

extension Date {
	func formattedDateString() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "M/dd/yyyy HH:mm"
		return formatter.string(from: self)
	}
}
