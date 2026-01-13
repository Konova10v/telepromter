//
//  TelepromterViewModel.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 06.08.2025.
//

import SwiftUI
import AVFoundation

enum Screens {
	case onbording
	case mainScreen
}

class TelepromterViewModel: ObservableObject {
	@Published var screen: Screens = .mainScreen
	@Published var showMenu = false
	@AppStorage("onboardingShown") private var onboardingShown: Bool = false
	
	@Published var openSelectLanguage: Bool = false
	@Published var showPaywall: Bool = false
	@Published var showHelp: Bool = false
	
	@Published var isPresentingAddScript = false
	@Published var script: String = ""
	@Published var editScript: Bool = false
	
	@Published var preview: PreviewItem?
	
	init() {
		if onboardingShown {
			screen = .mainScreen
		} else {
			screen = .onbording
			onboardingShown = true
		}
	}
	
	func cropVideo(inputURL: URL, aspect: VideoAspect, completion: @escaping (URL) -> Void) {
		let asset = AVAsset(url: inputURL)
		guard let track = asset.tracks(withMediaType: .video).first else { return }

		let videoSize = track.naturalSize.applying(track.preferredTransform)
		let absSize = CGSize(width: abs(videoSize.width), height: abs(videoSize.height))
		let inputRatio = absSize.width / absSize.height
		let targetRatio = aspect.ratio

		var cropRect = CGRect(origin: .zero, size: absSize)

		if inputRatio > targetRatio {
			let newWidth = absSize.height * targetRatio
			cropRect.origin.x = (absSize.width - newWidth) / 2
			cropRect.size.width = newWidth
		} else {
			let newHeight = absSize.width / targetRatio
			cropRect.origin.y = (absSize.height - newHeight) / 2
			cropRect.size.height = newHeight
		}

		let composition = AVMutableVideoComposition()
		composition.renderSize = cropRect.size
		composition.frameDuration = CMTime(value: 1, timescale: 30)

		let instruction = AVMutableVideoCompositionInstruction()
		instruction.timeRange = CMTimeRange(start: .zero, duration: asset.duration)

		let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
		let tx = CGAffineTransform(translationX: -cropRect.origin.x, y: -cropRect.origin.y)
		let finalTransform = track.preferredTransform.concatenating(tx)
		layerInstruction.setTransform(finalTransform, at: .zero)

		instruction.layerInstructions = [layerInstruction]
		composition.instructions = [instruction]

		let exportURL = FileManager.default.temporaryDirectory.appendingPathComponent("cropped.mp4")
		try? FileManager.default.removeItem(at: exportURL)

		let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
		exporter.outputURL = exportURL
		exporter.outputFileType = .mp4
		exporter.videoComposition = composition
		exporter.exportAsynchronously {
			DispatchQueue.main.async {
				if exporter.status == .completed {
					completion(exportURL)
				} else {
					print("Ошибка экспорта: \(String(describing: exporter.error))")
				}
			}
		}
	}
}
