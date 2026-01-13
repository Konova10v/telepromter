//
//  LanguageView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 06.08.2025.
//

import SwiftUI

struct Language: Identifiable, Equatable {
	let id = UUID()
	let name: String
	let nativeName: String
}

struct LanguageView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	
	@State private var selectedLanguage: Language = Language(name: "English", nativeName: "English")
	
	let allLanguages = [
		Language(name: "English", nativeName: "English"),
		Language(name: "Russian", nativeName: "Русский"),
		Language(name: "Ukrainian", nativeName: "Українська"),
		Language(name: "Polish", nativeName: "Polski")
	]
	
    var body: some View {
		VStack(spacing: 20) {
			HStack {
				Button {
					viewModel.openSelectLanguage.toggle()
					
					viewModel.showMenu.toggle()
				} label: {
					Image(.arrowLeft)
				}

				Spacer()
				
				Text("Language")
					.foregroundStyle(.white)
					.font(.labelLarge)
					.padding(.trailing, 25)
				
				Spacer()
			}
			.padding(.horizontal)
			.padding(.top)
			
			VStack(alignment: .trailing, spacing: 0) {
				ForEach(allLanguages) { language in
					VStack(spacing: 0) {
						Button {
							selectedLanguage = language
						} label: {
							HStack() {
								VStack(alignment: .leading, spacing: 8) {
									Text(language.name)
										.foregroundStyle(.white)
										.font(.labelMedium)
									
									Text(language.nativeName)
										.foregroundStyle(.neutralGrey)
										.font(.bodySmall)
								}
								
								Spacer()
								
								if selectedLanguage == language {
									Image(.check)
								}
							}
							.padding()
						}
						
						if language.name != "Polish" {
							HStack {}
								.frame(width: SizeScreen().width / 1.2,
									   height: 1,
									   alignment: .trailing)
								.background(Color.dividerMenu)
						}
					}
				}
			}
			.background(Color.white.opacity(0.05))
			.cornerRadius(16)
			.padding(.horizontal)
			.padding(.top)
			
			Spacer()
			
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.darkBkg)
				.resizable()
				.ignoresSafeArea()
		)
    }
}

#Preview {
    LanguageView()
}
