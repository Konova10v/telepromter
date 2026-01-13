//
//  PersistenceController.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 23.08.2025.
//

import CoreData

struct PersistenceController {
	static let shared = PersistenceController()

	let container: NSPersistentContainer

	init(inMemory: Bool = false) {
		container = NSPersistentContainer(name: "ScriptModel") // имя твоей .xcdatamodeld
		if inMemory {
			container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
		}
		container.loadPersistentStores { _, error in
			if let error = error {
				fatalError("Unresolved error \(error)")
			}
		}
		container.viewContext.automaticallyMergesChangesFromParent = true
	}
}
