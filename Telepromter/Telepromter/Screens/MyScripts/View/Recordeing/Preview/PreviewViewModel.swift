//
//  PreviewViewModel.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 23.08.2025.
//

import Foundation
import CoreData

class RecordingViewModel: ObservableObject {
	@Published var recordings: [RecordingEntity] = []

	private let context: NSManagedObjectContext

	init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
		self.context = context
		fetchRecordings()
	}

	func fetchRecordings() {
		let request: NSFetchRequest<RecordingEntity> = RecordingEntity.fetchRequest()
		request.sortDescriptors = [NSSortDescriptor(keyPath: \RecordingEntity.createdAt, ascending: false)]

		do {
			recordings = try context.fetch(request)
		} catch {
			print("❌ Fetch error: \(error)")
		}
	}

	func addRecording(scriptText: String, videoURL: URL) {
		let newRecording = RecordingEntity(context: context)
		newRecording.id = UUID()
		newRecording.scriptText = scriptText
		newRecording.videoURL = videoURL.absoluteString
		newRecording.createdAt = Date().formattedDateString()

		saveContext()
		fetchRecordings()
	}

	func deleteRecording(_ recording: RecordingEntity) {
		context.delete(recording)
		saveContext()
		fetchRecordings()
	}

	private func saveContext() {
		do {
			try context.save()
		} catch {
			print("❌ Save error: \(error)")
		}
	}
	
	func updateRecording(
		_ recording: RecordingEntity,
		newScript: String? = nil,
		newVideoURL: URL? = nil,
		newCreatedAt: String? = nil
	) {
		if let newScript = newScript {
			recording.scriptText = newScript
		}
		if let newVideoURL = newVideoURL {
			recording.videoURL = newVideoURL.absoluteString
		}
		if let newCreatedAt = newCreatedAt {
			recording.createdAt = newCreatedAt
		}
		saveContext()
		fetchRecordings()
	}
}

enum VideoAspect: CaseIterable, Identifiable {
	case nineSixteen, sixteenNine, fourFive, oneOne, fiveFour
	
	var id: Self { self }
	
	var ratio: CGFloat {
		switch self {
		case .nineSixteen: return 9.0 / 16.0
		case .sixteenNine: return 16.0 / 9.0
		case .fourFive:    return 4.0 / 5.0
		case .oneOne:      return 1.0
		case .fiveFour:    return 5.0 / 4.0
		}
	}
	
	var title: String {
		switch self {
		case .nineSixteen: return "9:16"
		case .sixteenNine: return "16:9"
		case .fourFive:    return "4:5"
		case .oneOne:      return "1:1"
		case .fiveFour:    return "5:4"
		}
	}
}


import AVFoundation
import UIKit

protocol CameraViewControllerDelegate: AnyObject {
	func didFinishRecording(outputURL: URL)
}

class CameraViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
	private let captureSession = AVCaptureSession()
	private let movieOutput = AVCaptureMovieFileOutput()
	private var previewLayer: AVCaptureVideoPreviewLayer!
	weak var delegate: CameraViewControllerDelegate?

	var currentAspect: VideoAspect = .nineSixteen

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSession()
	}

	private func setupSession() {
		guard let device = AVCaptureDevice.default(for: .video),
			  let input = try? AVCaptureDeviceInput(device: device) else { return }

		if captureSession.canAddInput(input) {
			captureSession.addInput(input)
		}
		if captureSession.canAddOutput(movieOutput) {
			captureSession.addOutput(movieOutput)
		}

		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.videoGravity = .resizeAspectFill
		previewLayer.frame = view.bounds
		view.layer.addSublayer(previewLayer)

		captureSession.startRunning()
	}

	func startRecording() {
		guard !movieOutput.isRecording else { return }
		let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("raw.mov")
		try? FileManager.default.removeItem(at: fileURL)
		movieOutput.startRecording(to: fileURL, recordingDelegate: self)
	}

	func stopRecording() {
		if movieOutput.isRecording {
			movieOutput.stopRecording()
		}
	}

	// ✅ После записи → сразу кропим и возвращаем готовый файл
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		guard error == nil else { return }
		cropVideo(inputURL: outputFileURL, aspect: currentAspect) { url in
			self.delegate?.didFinishRecording(outputURL: url)
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

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
	@Binding var aspect: VideoAspect
	@Binding var isRecording: Bool
	@Binding var outputURL: URL?

	func makeUIViewController(context: Context) -> CameraViewController {
		let vc = CameraViewController()
		vc.delegate = context.coordinator
		return vc
	}

	func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
		uiViewController.currentAspect = aspect

		if isRecording {
			uiViewController.startRecording()
		} else {
			uiViewController.stopRecording()
		}
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(parent: self)
	}

	class Coordinator: NSObject, CameraViewControllerDelegate {
		var parent: CameraView
		init(parent: CameraView) { self.parent = parent }

		func didFinishRecording(outputURL: URL) {
			DispatchQueue.main.async {
				self.parent.outputURL = outputURL
			}
		}
	}
}
