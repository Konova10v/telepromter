//
//  TelepromterApp.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 04.08.2025.
//

import SwiftUI
import RevenueCat

@main
struct TelepromterApp: App {
	let persistenceController = PersistenceController.shared

	init() {
		Purchases.configure(withAPIKey: "appl_XeMYuOCVsYIqQqsFgCkzYkbhWtK")
	}
	
    var body: some Scene {
        WindowGroup {
            TelepromterView()
				.environmentObject(TelepromterViewModel())
				.environment(\.managedObjectContext, persistenceController.container.viewContext)
				.preferredColorScheme(.dark)
        }
    }
}
