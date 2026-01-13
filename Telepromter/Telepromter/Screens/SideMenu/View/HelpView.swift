//
//  HelpView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 07.08.2025.
//

import SwiftUI

struct HelpView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	
    var body: some View {
		VStack {
			HStack {
				Button {
					viewModel.showHelp.toggle()
					viewModel.showMenu.toggle()
				} label: {
					Image(.arrowLeft)
				}
				
				Spacer()
			}
			.padding(.horizontal)
			
			Spacer()
			
			VStack(spacing: 30) {
				VStack(spacing: 40) {
					Text("Help")
						.foregroundStyle(.white)
						.font(.h3)
					
					Text("Message us on Telegram — we will quickly help you resolve any issue.")
						.foregroundStyle(.white)
						.font(.bodyLarge)
						.multilineTextAlignment(.center)
				}
				
				ZStack {
					Image(.buttonContainer)
						.resizable()
						.frame(width: SizeScreen().width, height: 90)
					
					Button(action: {
						if let url = URL(string: "https://sites.google.com/view/tlprmptr/support") {
							UIApplication.shared.open(url)
						}
					}) {
						HStack {
							Spacer()
							
							Text("Contact us in Telegram")
								.font(.bodyMedium)
								.bold()
								.foregroundColor(.white)
							
							Spacer()
							
							Image(.telegram)
								.padding(.trailing)
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
				.padding(.bottom)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.helpBkg)
				.resizable()
				.ignoresSafeArea()
		)
    }
}

#Preview {
    HelpView()
}
