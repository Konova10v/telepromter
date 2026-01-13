//
//  SelectLayoutView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 06.08.2025.
//

import SwiftUI

struct LayoutModel: Identifiable, Hashable {
	let id = UUID()
	let name: String
	let aspect: VideoAspect
	let location: String
	let width: CGFloat
	let height: CGFloat
	var isActive: Bool
}

struct SelectLayoutView: View {
	@EnvironmentObject var telepromterViewModel: TelepromterViewModel
	
	var emptyColor: [Color] = [
		Color.white.opacity(0.1),
		Color.white.opacity(0.0)
	]
	
	var noEmptyColor: [Color] = [
		Color.primaryOrange,
		Color.primaryOrange
	]
	
	@State var selectLayout: LayoutModel = LayoutModel(name: "",
													   aspect: .nineSixteen,
													   location: "",
													   width: 0,
													   height: 0,
													   isActive: false)
	@State var aspect: VideoAspect = .nineSixteen
	
	@State var populars: [LayoutModel] = [
		LayoutModel(name: "9:16",
					aspect: .nineSixteen,
					location: "Vertical",
					width: 68,
					height: 104,
					isActive: false),
		LayoutModel(name: "9:16",
					aspect: .sixteenNine,
					location: "Horizontal",
					width: 104,
					height: 68,
					isActive: false)
	]
	
	@State var instagram: [LayoutModel] = [
		LayoutModel(name: "4:5",
					aspect: .fourFive,
					location: "Portrait",
					width: 98,
					height: 104,
					isActive: false),
		LayoutModel(name: "1:1",
					aspect: .oneOne,
					location: "Post",
					width: 104,
					height: 104,
					isActive: false),
		LayoutModel(name: "9:16",
					aspect: .nineSixteen,
					location: "Vertical",
					width: 68,
					height: 104,
					isActive: false)
	]
	
	@State var linkedin: [LayoutModel] = [
		LayoutModel(name: "9:16",
					aspect: .nineSixteen,
					location: "Post",
					width: 104,
					height: 68,
					isActive: false)
	]
	
	@State var twitter: [LayoutModel] = [
		LayoutModel(name: "9:16",
					aspect: .nineSixteen,
					location: "Vertical",
					width: 68,
					height: 104,
					isActive: false),
		LayoutModel(name: "5:4",
					aspect: .fiveFour,
					location: "Post",
					width: 110,
					height: 104,
					isActive: false),
	]
	
	@State var tikTok: [LayoutModel] = [
		LayoutModel(name: "9:16",
					aspect: .nineSixteen,
					location: "Post",
					width: 68,
					height: 104,
					isActive: false),
	]
	
	@State var script: String
	
	@Environment(\.dismiss) var dismiss
	
    var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Button {
					dismiss()
				} label: {
					Image(.arrowLeft)
				}

				Spacer()
				
				Text("Select layout")
					.foregroundStyle(.white)
					.font(.labelLarge)
					.padding(.leading, 5)
				
				Spacer()
				
				Button {
					telepromterViewModel.isPresentingAddScript.toggle()
				} label: {
					Image(.closeButton)
				}
			}
			.padding(.horizontal)
			.padding(.vertical)
			
			HStack {}
				.frame(width: SizeScreen().width, height: 1)
				.background(Color.divider)
			
			ScrollView {
				VStack(alignment: .leading, spacing: 18) {
					VStack(alignment: .leading, spacing: 20) {
						HStack(spacing: 13) {
							Image(.popular)
							
							Text("Popular")
								.foregroundStyle(.white)
								.font(.labelMedium)
						}
						.padding(.horizontal)
						
						VStack(alignment: .leading, spacing: 12) {
							HStack(spacing: 16) {
								ForEach(populars.indices, id: \.self) { index in
									LayoutButton(
											model: populars[index],
											isActive: populars[index].isActive,
											emptyColor: emptyColor,
											noEmptyColor: noEmptyColor
										) {
											for item in populars.indices {
												populars[item].isActive = false
											}
											populars[index].isActive = true
											selectLayout = populars[index]
											
											for item in instagram.indices {
												instagram[item].isActive = false
											}
											for item in linkedin.indices {
												linkedin[item].isActive = false
											}
											for item in twitter.indices {
												twitter[item].isActive = false
											}
											for item in tikTok.indices {
												tikTok[item].isActive = false
											}
											
											aspect = populars[index].aspect
										}
								}
							}
							.padding(.horizontal)
							
							DottedDivider()
						}
					}
					
					VStack(alignment: .leading, spacing: 20) {
						HStack(spacing: 13) {
							Image(.instagram)
							
							Text("Instagram")
								.foregroundStyle(.white)
								.font(.labelMedium)
						}
						.padding(.horizontal)
						
						VStack(alignment: .leading, spacing: 12) {
							HStack(spacing: 16) {
								ForEach(instagram.indices, id: \.self) { index in
									LayoutButton(
											model: instagram[index],
											isActive: instagram[index].isActive,
											emptyColor: emptyColor,
											noEmptyColor: noEmptyColor
										) {
											for item in instagram.indices {
												instagram[item].isActive = false
											}
											instagram[index].isActive = true
											selectLayout = instagram[index]
											
											for item in populars.indices {
												populars[item].isActive = false
											}
											for item in linkedin.indices {
												linkedin[item].isActive = false
											}
											for item in twitter.indices {
												twitter[item].isActive = false
											}
											for item in tikTok.indices {
												tikTok[item].isActive = false
											}
											
											aspect = instagram[index].aspect
										}
								}
							}
							.padding(.horizontal)
							
							DottedDivider()
						}
					}
					
					VStack(alignment: .leading, spacing: 20) {
						HStack(spacing: 13) {
							Image(.linkedin)
							
							Text("Linkedin")
								.foregroundStyle(.white)
								.font(.labelMedium)
						}
						.padding(.horizontal)
						
						VStack(alignment: .leading, spacing: 12) {
							HStack(spacing: 16) {
								ForEach(linkedin.indices, id: \.self) { index in
									LayoutButton(
											model: linkedin[index],
											isActive: linkedin[index].isActive,
											emptyColor: emptyColor,
											noEmptyColor: noEmptyColor
										) {
											for item in linkedin.indices {
												linkedin[item].isActive = false
											}
											linkedin[index].isActive = true
											selectLayout = linkedin[index]
											
											for item in populars.indices {
												populars[item].isActive = false
											}
											for item in instagram.indices {
												instagram[item].isActive = false
											}
											for item in twitter.indices {
												twitter[item].isActive = false
											}
											for item in tikTok.indices {
												tikTok[item].isActive = false
											}
											
											aspect = linkedin[index].aspect
										}
								}
							}
							.padding(.horizontal)
							
							DottedDivider()
						}
					}
					
					VStack(alignment: .leading, spacing: 20) {
						HStack(spacing: 13) {
							Image(.twitter)
							
							Text("Twitter (X)")
								.foregroundStyle(.white)
								.font(.labelMedium)
						}
						.padding(.horizontal)
						
						VStack(alignment: .leading, spacing: 12) {
							HStack(spacing: 16) {
								ForEach(twitter.indices, id: \.self) { index in
									LayoutButton(
											model: twitter[index],
											isActive: twitter[index].isActive,
											emptyColor: emptyColor,
											noEmptyColor: noEmptyColor
										) {
											for item in twitter.indices {
												twitter[item].isActive = false
											}
											twitter[index].isActive = true
											selectLayout = twitter[index]
											
											for item in populars.indices {
												populars[item].isActive = false
											}
											for item in instagram.indices {
												instagram[item].isActive = false
											}
											for item in linkedin.indices {
												linkedin[item].isActive = false
											}
											for item in tikTok.indices {
												tikTok[item].isActive = false
											}
											
											aspect = twitter[index].aspect
										}
								}
							}
							.padding(.horizontal)
							
							DottedDivider()
						}
					}
					
					VStack(alignment: .leading, spacing: 20) {
						HStack(spacing: 13) {
							Image(.tiktok)
							
							Text("Tik-Tok")
								.foregroundStyle(.white)
								.font(.labelMedium)
						}
						.padding(.horizontal)
						
						VStack(alignment: .leading, spacing: 12) {
							HStack(spacing: 16) {
								ForEach(tikTok.indices, id: \.self) { index in
									LayoutButton(
											model: tikTok[index],
											isActive: tikTok[index].isActive,
											emptyColor: emptyColor,
											noEmptyColor: noEmptyColor
										) {
											for item in tikTok.indices {
												tikTok[item].isActive = false
											}
											tikTok[index].isActive = true
											selectLayout = tikTok[index]
											
											for item in populars.indices {
												populars[item].isActive = false
											}
											for item in instagram.indices {
												instagram[item].isActive = false
											}
											for item in linkedin.indices {
												linkedin[item].isActive = false
											}
											for item in twitter.indices {
												twitter[item].isActive = false
											}
											
											aspect = tikTok[index].aspect
										}
								}
							}
							.padding(.horizontal)
							
							DottedDivider()
						}
					}
				}
				
				ZStack {
					Image(.buttonContainer)
						.resizable()
						.frame(width: SizeScreen().width, height: 90)
					
					if selectLayout.name.isEmpty {
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
					} else {
						NavigationLink {
							RecordingView(script: script, aspect: aspect)
						} label: {
							HStack {
								Spacer()
								
								Text("Сontinue")
									.font(.bodyMedium)
									.bold()
									.foregroundColor(.white)
									.padding(.leading, 20)
								
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
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.darkBkg)
				.resizable()
				.ignoresSafeArea()
		)
		.navigationBarHidden(true)
    }
}

#Preview {
	SelectLayoutView(script: "")
}


struct DottedDivider: View {
	var body: some View {
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
		.padding(.horizontal)
	}
}

struct LayoutButton: View {
	let model: LayoutModel
	let isActive: Bool
	let emptyColor: [Color]
	let noEmptyColor: [Color]
	let action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(spacing: 5) {
				Text(model.name)
					.foregroundStyle(.white)
					.font(.labelXLarge)
				
				Text(model.location)
					.foregroundStyle(.neutralGrey)
					.font(.labelXSmall)
			}
			.frame(width: model.width, height: model.height)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(isActive ? Color.primaryOrange.opacity(0.15) : Color.black.opacity(0.35))
					.overlay(
						RoundedRectangle(cornerRadius: 16)
							.stroke(
								LinearGradient(
									gradient: Gradient(colors: isActive ? noEmptyColor : emptyColor),
									startPoint: .top,
									endPoint: .bottom
								),
								lineWidth: 1
							)
					)
					.shadow(color: Color.white.opacity(0.05), radius: 3, x: 0, y: 1)
			)
		}
	}
}
