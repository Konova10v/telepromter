//
//  VideoStorage.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 23.08.2025.
//

import Foundation

struct VideoStorage {
	static func saveVideo(tempURL: URL) -> URL? {
		let fileManager = FileManager.default
		let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
		let newFileURL = documents.appendingPathComponent("\(UUID().uuidString).mp4")

		do {
			try fileManager.copyItem(at: tempURL, to: newFileURL)
			return newFileURL
		} catch {
			print("❌ Error saving video: \(error)")
			return nil
		}
	}
}
