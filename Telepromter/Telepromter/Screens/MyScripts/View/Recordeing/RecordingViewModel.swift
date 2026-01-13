//
//  RecordingViewModel.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 16.08.2025.
//

import SwiftUI
import AVFoundation
import AVKit
import Combine

// MARK: - Модель настроек (для текущего файла)
struct TeleprompterSettings: Equatable {
	var countdown: Int = 3            // 0...15
	var fontSize: CGFloat = 44        // из макета ~ 44
	var scrollSpeed: CGFloat = 30     // pt/sec
	var isMirrored: Bool = false
}

// MARK: - Идентифицируемый превью-айтем
struct PreviewItem: Identifiable {
	let id = UUID()
	let url: URL
}

// MARK: - Менеджер камеры и записи (сегменты + склейка)
final class CaptureManager: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
	@Published var isRecording = false
	@Published var isPaused = false
	@Published var duration: TimeInterval = 0
	
	let session = AVCaptureSession()
	private let movieOutput = AVCaptureMovieFileOutput()
	private var videoInput: AVCaptureDeviceInput?
	private var timer: Timer?
	
	private var segments: [URL] = []
	private var currentSegmentURL: URL?
	
	private var completionHandler: ((URL?) -> Void)?
	
	override init() {
			super.init()
			setupNotifications()
		}
	
	// Настройка с выбранной камерой
	func configure(position: AVCaptureDevice.Position = .front) {
		session.beginConfiguration()
		session.sessionPreset = .high
		
		// Видео
		if let old = videoInput { session.removeInput(old) }
		guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
			  let vInput = try? AVCaptureDeviceInput(device: device) else {
			session.commitConfiguration(); return
		}
		if session.canAddInput(vInput) {
			session.addInput(vInput)
			videoInput = vInput
		}
		
		// Аудио
		if let audio = AVCaptureDevice.default(for: .audio),
		   let aInput = try? AVCaptureDeviceInput(device: audio),
		   session.canAddInput(aInput) {
			session.addInput(aInput)
		}
		
		// Выход
		if !session.outputs.contains(movieOutput), session.canAddOutput(movieOutput) {
			session.addOutput(movieOutput)
		}
		
		session.commitConfiguration()
	}
	
	func requestPermissionsAndStart() {
		AVCaptureDevice.requestAccess(for: .video) { [weak self] ok in
			guard ok else { return }
			AVCaptureDevice.requestAccess(for: .audio) { _ in }
			DispatchQueue.main.async {
				if self?.session.inputs.isEmpty == true { self?.configure(position: .front) }
				self?.session.startRunning()
			}
		}
	}
	
	// MARK: - Управление записью (сегменты)
	func startSegment() {
		guard !movieOutput.isRecording else { return }
		UIApplication.shared.isIdleTimerDisabled = true
		let url = FileManager.default.temporaryDirectory
			.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
		currentSegmentURL = url
		movieOutput.startRecording(to: url, recordingDelegate: self)
		if !isRecording {
			isRecording = true
			startTimer()
		}
		isPaused = false
	}
	
	func pause() {
		guard movieOutput.isRecording else { return }
		movieOutput.stopRecording()          // завершили сегмент
		isPaused = true
	}
	
	func stopAll(completion: @escaping (URL?) -> Void) {
		guard movieOutput.isRecording else {
			completion(nil)
			return
		}
		UIApplication.shared.isIdleTimerDisabled = false

		self.isRecording = false
		self.isPaused = false
		stopTimer()

		// сохраняем completion, чтобы вызвать его в делегате
		self.completionHandler = completion
		movieOutput.stopRecording()
	}
	
	func toggleCamera() {
		// безопасно — ставим паузу, переключаем, продолжим новым сегментом
		if movieOutput.isRecording { pause() }
		let newPos: AVCaptureDevice.Position = (videoInput?.device.position == .front) ? .back : .front
		configure(position: newPos)
	}
	
	func setupNotifications() {
		NotificationCenter.default.addObserver(
			forName: UIApplication.willResignActiveNotification,
			object: nil,
			queue: .main
		) { [weak self] _ in
			guard let self = self else { return }
			// Если запись идёт — корректно останавливаем сегмент
			if self.isRecording {
				self.movieOutput.stopRecording()
			}
		}

		NotificationCenter.default.addObserver(
			forName: UIApplication.didBecomeActiveNotification,
			object: nil,
			queue: .main
		) { _ in
			self.startSegment()
		}
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	// MARK: - Таймер
	private func startTimer() {
		duration = 0
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
			self?.duration += 1
		}
	}
	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}
	
	// MARK: - Делегат записи
	func fileOutput(_ output: AVCaptureFileOutput,
					didFinishRecordingTo outputFileURL: URL,
					from connections: [AVCaptureConnection],
					error: Error?) {
		if error == nil {
			completionHandler?(outputFileURL)
		} else {
			completionHandler?(nil)
		}
		completionHandler = nil
	}

	
	// MARK: - Склейка сегментов
	private func merge(urls: [URL], completion: @escaping (URL?) -> Void) {
		let comp = AVMutableComposition()
		guard let vTrack = comp.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
			  let aTrack = comp.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
		else { completion(nil); return }
		
		var t = CMTime.zero
		var preferredTransform: CGAffineTransform = .identity
		
		for url in urls {
			let asset = AVURLAsset(url: url)
			if let v = asset.tracks(withMediaType: .video).first {
				preferredTransform = v.preferredTransform
				try? vTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: v, at: t)
			}
			if let a = asset.tracks(withMediaType: .audio).first {
				try? aTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: a, at: t)
			}
			t = CMTimeAdd(t, asset.duration)
		}
		vTrack.preferredTransform = preferredTransform
		
		let outURL = FileManager.default.temporaryDirectory
			.appendingPathComponent("merged_\(UUID().uuidString).mp4")
		if FileManager.default.fileExists(atPath: outURL.path) { try? FileManager.default.removeItem(at: outURL) }
		guard let exp = AVAssetExportSession(asset: comp, presetName: AVAssetExportPresetHighestQuality) else {
			completion(nil); return
		}
		exp.outputURL = outURL
		exp.outputFileType = .mp4
		exp.exportAsynchronously {
			DispatchQueue.main.async {
				completion(exp.status == .completed ? outURL : nil)
			}
		}
	}
}

// MARK: - Превью-слой камеры
final class AVCapturePreviewHostView: UIView {
	override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
	var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }

	override init(frame: CGRect) {
		super.init(frame: frame)
		videoPreviewLayer.videoGravity = .resizeAspectFill
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		videoPreviewLayer.videoGravity = .resizeAspectFill
	}
}

// SwiftUI-обёртка
struct CameraPreview: UIViewRepresentable {
	let session: AVCaptureSession

	func makeUIView(context: Context) -> AVCapturePreviewHostView {
		let view = AVCapturePreviewHostView()
		view.videoPreviewLayer.session = session
		return view
	}

	func updateUIView(_ uiView: AVCapturePreviewHostView, context: Context) {
		// Подстраиваем ориентацию превью под устройство (не обязательно, но полезно)
		if let conn = uiView.videoPreviewLayer.connection, conn.isVideoOrientationSupported {
			if let o = AVCaptureVideoOrientation(deviceOrientation: UIDevice.current.orientation) {
				conn.videoOrientation = o
			}
		}
	}
}

// Удобный маппер ориентации
private extension AVCaptureVideoOrientation {
	init?(deviceOrientation: UIDeviceOrientation) {
		switch deviceOrientation {
		case .portrait: self = .portrait
		case .landscapeRight: self = .landscapeLeft   // фронт/тыл зеркалят оси
		case .landscapeLeft: self = .landscapeRight
		case .portraitUpsideDown: self = .portraitUpsideDown
		default: return nil
		}
	}
}


// MARK: - Скроллер телесуфлера (CADisplayLink)
final class TeleprompterScroller: ObservableObject {
	@Published var offset: CGFloat = 0
	var speed: CGFloat = 30
	private var link: CADisplayLink?
	private(set) var isRunning = false
	
	func play() {
		guard !isRunning else { return }
		isRunning = true
		link = CADisplayLink(target: self, selector: #selector(tick))
		link?.add(to: .main, forMode: .common)
	}
	func pause() {
		isRunning = false
		link?.invalidate()
		link = nil
	}
	func stop() {
		pause()
		offset = 0
	}
	@objc private func tick(_ l: CADisplayLink) {
		offset += CGFloat(l.duration) * speed
	}
}
