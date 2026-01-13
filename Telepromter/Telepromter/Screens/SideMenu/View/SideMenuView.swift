//
//  SideMenuView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 06.08.2025.
//

import SwiftUI
import StoreKit

struct SideMenuView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	
	var body: some View {
		ZStack(alignment: .leading) {
			Color.black.opacity(0.2).ignoresSafeArea() // фон для наглядности
				.onTapGesture {
					viewModel.showMenu.toggle()
				}
			
			VStack(alignment: .leading, spacing: 24) {
				Group {
					Text("SETTINGS")
						.foregroundColor(.neutralGrey)
						.font(.pretitle)
					
					Button {
						viewModel.showHelp = false
						viewModel.showMenu.toggle()
						viewModel.openSelectLanguage.toggle()
					} label: {
						HStack {
							Image(.global)
								.foregroundColor(.orange)
							
							Text("Language")
								.foregroundColor(.white)
							
							Spacer()
							
							Image(.arrowMenu)
								.foregroundColor(.gray)
						}
						.padding()
						.background(Color.white.opacity(0.05))
						.cornerRadius(16)
					}
				}

				Group {
					Text("SUPPORT")
						.foregroundColor(.neutralGrey)
						.font(.pretitle)
					
					VStack(spacing: 0) {
						VStack(alignment: .trailing, spacing: 0) {
							Button {
								viewModel.openSelectLanguage = false
								viewModel.showMenu.toggle()
								viewModel.showHelp.toggle()
							} label: {
								HStack(spacing: 15) {
									Image(.help)
										.resizable()
										.frame(width: 24, height: 24)
									
									Text("Help")
										.foregroundColor(.white)
									
									Spacer()
									
									Image(.arrowMenu)
								}
								.padding(.horizontal)
							}
							.padding(.vertical)
							
							HStack {}
								.frame(width: SizeScreen().width / 1.65,
									   height: 1,
									   alignment: .trailing)
								.background(Color.dividerMenu)
						}
						
						VStack(alignment: .trailing, spacing: 0) {
							Button {
								requestAppReview()
							} label: {
								HStack(spacing: 15) {
									Image(.like)
										.resizable()
										.frame(width: 24, height: 24)
									
									Text("Rate Us")
										.foregroundColor(.white)
									
									Spacer()
									
									Image(.arrowMenu)
										.foregroundColor(.gray)
								}
								.padding(.horizontal)
							}
							.padding(.vertical)
							
							HStack {}
								.frame(width: SizeScreen().width / 1.65,
									   height: 1,
									   alignment: .trailing)
								.background(Color.dividerMenu)
						}
						
						VStack(alignment: .trailing, spacing: 0) {
							Button {
								
							} label: {
								HStack(spacing: 15) {
									Image(.document)
										.resizable()
										.frame(width: 24, height: 24)
									
									Text("Terms of Use")
										.foregroundColor(.white)
									
									Spacer()
									
									Image(.arrowMenu)
										.foregroundColor(.gray)
								}
								.padding(.horizontal)
							}
							.padding(.vertical)
							
							HStack {}
								.frame(width: SizeScreen().width / 1.65,
									   height: 1,
									   alignment: .trailing)
								.background(Color.dividerMenu)
						}
						
						VStack(alignment: .trailing, spacing: 0) {
							Button {
								
							} label: {
								HStack(spacing: 15) {
									Image(.lock)
										.resizable()
										.frame(width: 24, height: 24)
									
									Text("Privacy Policy")
										.foregroundColor(.white)
									
									Spacer()
									
									Image(.arrowMenu)
										.foregroundColor(.gray)
								}
								.padding(.horizontal)
							}
							.padding(.vertical)
							
							HStack {}
								.frame(width: SizeScreen().width / 1.65,
									   height: 1,
									   alignment: .trailing)
								.background(Color.dividerMenu)
						}
						
						Button {
							
						} label: {
							HStack(spacing: 15) {
								Image(.subtract)
									.resizable()
									.frame(width: 24, height: 24)
								
								Text("Restore Purchase")
									.foregroundColor(.white)
								
								Spacer()
								
								Image(.arrowMenu)
									.foregroundColor(.gray)
							}
							.padding(.horizontal)
						}
						.padding(.vertical)
					}
					.background(Color.white.opacity(0.05))
					.cornerRadius(16)
				}

				Spacer()
				
				VStack {
					Button(action: {
						viewModel.showMenu.toggle()
						viewModel.showPaywall.toggle()
					}) {
						HStack {
							Image(.proBadgeWhite)
							
							Text("Upgrade to PRO")
								.font(.labelMedium)
							
							Spacer()
							
							Image(.arrowMenu)
						}
						.foregroundColor(.white)
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
					}
				}
			}
			.padding()
			.frame(width: SizeScreen().width / 1.2, alignment: .leading)
			.background(
				Image(.darkBkg)
					.resizable()
					.ignoresSafeArea()
			)
		}
	}

	func requestAppReview() {
		if let scene = UIApplication.shared.connectedScenes
			.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {

			if #available(iOS 18.0, *) {
				AppStore.requestReview(in: scene)
			} else {
				SKStoreReviewController.requestReview(in: scene)
			}
		}
	}

}

#Preview {
	SideMenuView()
		.environmentObject(TelepromterViewModel())
	
}
