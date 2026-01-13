//
//  ContentView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import SwiftUI

struct TelepromterView: View {
	@EnvironmentObject var viewModel: TelepromterViewModel
	
    var body: some View {
		NavigationView {
			ZStack {
				VStack {
					switch viewModel.screen {
						case .onbording:
							OnboardingView()
						case .mainScreen:
							MyScriptsView()
								.offset(x: viewModel.showMenu ? SizeScreen().width / 1.2 : 0)
					}
				}
				
				if viewModel.showPaywall {
					PaywallView()
				}
				
				if viewModel.openSelectLanguage {
					LanguageView()
				}
				
				if viewModel.showHelp {
					HelpView()
				}
				
				if viewModel.showMenu {
					SideMenuView()
						.transition(.move(edge: .leading))
						.zIndex(2)
				}
			}
		}
    }
}

#Preview {
    TelepromterView()
		.environmentObject(TelepromterViewModel())
	
}
