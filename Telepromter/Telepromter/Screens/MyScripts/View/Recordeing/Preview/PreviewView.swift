//
//  PreviewView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 16.08.2025.
//

import SwiftUI
import AVKit
import UIKit
import Photos

struct PreviewView: View {
	@EnvironmentObject var telepromterViewModel: TelepromterViewModel
	@ObservedObject var viewModel: RecordingViewModel = RecordingViewModel()
	@State var script: String
	@State var aspect: VideoAspect
	
	@State private var showPaywall = false
	@State private var showExitConfirm = false
	@State private var showEditor = false
	@State private var currentVideo: URL
	
	@State private var showShare = false
	
	let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
	
	init(videoURL: URL, script: String, aspect: VideoAspect) {
		_currentVideo = State(initialValue: videoURL)
		_script = State(initialValue: script)
		_aspect = State(initialValue: aspect)
		
		saveVideoToLibrary(currentVideo) { success, error in
				if success {
					print("✅ Video saved to Photos")
				} else {
					print("❌ Error saving video:", error?.localizedDescription ?? "Unknown")
				}
			}
	}

	var body: some View {
		VStack {
			// Header
			HStack {
				Button {
					telepromterViewModel.preview = nil
				} label: {
					Image(.arrowLeft)
				}
				.frame(width: 50)

				Spacer()

				Text("Preview")
					.font(.labelLarge)
					.foregroundStyle(.white)

				Spacer()

				Button {
					showExitConfirm.toggle()
				} label: {
					Image(.closeButton)
				}
				.frame(width: 50)
			}
			.padding(.horizontal)
			.padding(.vertical)

			HStack {}
				.frame(width: SizeScreen().width, height: 1)
				.background(Color.divider)

			// 🔑 Показываем либо отредактированное, либо исходное видео
			VideoPreview(url: currentVideo, aspect: aspect)
				.padding()
				.frame(height: SizeScreen().height / 4)

			Text("Edit Options")
				.font(.labelMedium)
				.foregroundStyle(.white)

			LazyVGrid(columns: columns, spacing: 16) {
				Button {
					if UIVideoEditorController.canEditVideo(atPath: currentVideo.path) {
						showEditor = true
					}
				} label: {
					Image(.trimVideo)
				}
			}

			Spacer()

			// Bottom buttons
			ZStack {
				Image(.buttonContainer)
					.resizable()
					.frame(width: SizeScreen().width, height: 160)

				VStack(spacing: 14) {
					Button(action: {
						viewModel.addRecording(scriptText: script, videoURL: currentVideo)
						
						saveVideoToLibrary(currentVideo) { success, error in
								if success {
									print("✅ Video saved to Photos")
								} else {
									print("❌ Error saving video:", error?.localizedDescription ?? "Unknown")
								}
							}
					}) {
						HStack {
							Spacer()
							Text("Save")
								.font(.bodyMedium)
								.bold()
								.foregroundColor(.white)
								.padding(.leading, 20)
							Spacer()
							Image(.save)
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

					Button {
						viewModel.addRecording(scriptText: script, videoURL: currentVideo)
						
						if FileManager.default.fileExists(atPath: currentVideo.path) {
											showShare = true
										} else {
											print("❌ Файл не найден или не сохранён")
										}
					} label: {
						HStack {
							Spacer()
							Text("Share")
								.font(.bodyMedium)
								.bold()
								.foregroundColor(.white)
								.padding(.leading, 20)
							Spacer()
							Image(.share)
						}
						.frame(maxWidth: .infinity)
						.padding()
						.background(
							RoundedRectangle(cornerRadius: 20)
								.fill(Color.white.opacity(0.04))
						)
						.overlay(
							RoundedRectangle(cornerRadius: 20)
								.stroke(
									LinearGradient(
										gradient: Gradient(colors: [
											Color.white.opacity(0.2),
											Color.white.opacity(0.05)
										]),
										startPoint: .top,
										endPoint: .bottom
									),
									lineWidth: 1
								)
						)
						.shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 1)
						.cornerRadius(16)
						.padding(.horizontal, 30)
					}
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(
			Image(.darkBkg)
				.resizable()
				.ignoresSafeArea()
		)
		.alert("Delete recording?", isPresented: $showExitConfirm) {
			Button("Cancel", role: .cancel) {}
			Button("Delete", role: .destructive) {
				telepromterViewModel.isPresentingAddScript.toggle()
			}
		} message: {
			Text("Are you sure you want to discard this recording?")
		}
		.sheet(isPresented: $showEditor) {
					SystemVideoEditor(
						url: currentVideo,
						onDone: { newURL in
							// 👇 подменяем на обрезанный ролик
							currentVideo = newURL
							print("✅ Trimmed video at:", newURL)
						},
						onCancel: {
							print("❌ Editing cancelled")
						}
					)
				}
		.sheet(isPresented: $showShare) {
			ShareSheet(items: [currentVideo])
		}
	}
}

extension PreviewView {
	/// Сохраняет текущее видео в Фотоальбом
	func saveVideoToLibrary(_ url: URL, completion: @escaping (Bool, Error?) -> Void) {
		PHPhotoLibrary.shared().performChanges({
			PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
		}) { success, error in
			DispatchQueue.main.async {
				completion(success, error)
				telepromterViewModel.isPresentingAddScript.toggle()
			}
		}
	}
}

extension PreviewView {
	/// Открывает системное окно "Поделиться" для видео
	func shareVideo(url: URL) {
		// Если файл уже лежит в Documents — используем напрямую
		let fileManager = FileManager.default
		var shareURL = url
		
		// Если вдруг файл был во временной папке — скопируем в Documents
		if url.path.contains("/tmp/") {
			let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
			let newURL = documents.appendingPathComponent(url.lastPathComponent)
			
			do {
				if fileManager.fileExists(atPath: newURL.path) {
					try fileManager.removeItem(at: newURL)
				}
				try fileManager.copyItem(at: url, to: newURL)
				shareURL = newURL
			} catch {
				print("Ошибка переноса файла в Documents: \(error)")
				return
			}
		}
		
		// Показываем Share Sheet
		DispatchQueue.main.async {
			guard let rootVC = UIApplication.shared.connectedScenes
				.compactMap({ ($0 as? UIWindowScene)?.keyWindow })
				.first?.rootViewController else {
				return
			}
			
			let activityVC = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
			
			if let popover = activityVC.popoverPresentationController {
				popover.sourceView = rootVC.view
				popover.sourceRect = CGRect(x: rootVC.view.bounds.midX,
											y: rootVC.view.bounds.midY,
											width: 0, height: 0)
				popover.permittedArrowDirections = []
			}
			
			rootVC.present(activityVC, animated: true)
			
			telepromterViewModel.isPresentingAddScript.toggle()
		}
	}


}

struct ShareSheet: UIViewControllerRepresentable {
	var items: [Any]

	func makeUIViewController(context: Context) -> UIActivityViewController {
		let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
		return controller
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Превью видео
struct VideoPreview: View {
	let url: URL?
	let aspect: VideoAspect
	@State private var player = AVPlayer()
	
	var body: some View {
		ZStack {
			if let url {
				VideoPlayer(player: player)
					.aspectRatio(aspect.ratio, contentMode: .fit)
					.onAppear {
						player.replaceCurrentItem(with: AVPlayerItem(url: url))
						player.play()
					}
			} else {
				RoundedRectangle(cornerRadius: 12)
					.fill(Color.gray.opacity(0.3))
				Image(systemName: "play.circle.fill")
					.font(.system(size: 64))
					.foregroundColor(.white)
			}
		}
		.clipShape(RoundedRectangle(cornerRadius: 12))
	}
}


// MARK: - Системный видеоредактор
struct SystemVideoEditor: UIViewControllerRepresentable {
	let url: URL
	var onDone: (URL) -> Void
	var onCancel: () -> Void
	
	func makeUIViewController(context: Context) -> UIVideoEditorController {
		let editor = UIVideoEditorController()
		editor.videoPath = url.path
		editor.delegate = context.coordinator
		return editor
	}
	
	func updateUIViewController(_ uiViewController: UIVideoEditorController, context: Context) {}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}
	
	class Coordinator: NSObject, UIVideoEditorControllerDelegate, UINavigationControllerDelegate {
		var parent: SystemVideoEditor
		
		init(_ parent: SystemVideoEditor) {
			self.parent = parent
		}
		
		func videoEditorController(_ editor: UIVideoEditorController,
								   didSaveEditedVideoToPath editedVideoPath: String) {
			let newURL = URL(fileURLWithPath: editedVideoPath)
			parent.onDone(newURL)
			editor.dismiss(animated: true)
		}
		
		func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
			parent.onCancel()
			editor.dismiss(animated: true)
		}
		
		func videoEditorController(_ editor: UIVideoEditorController,
								   didFailWithError error: Error) {
			print("❌ Error editing video:", error)
			parent.onCancel()
			editor.dismiss(animated: true)
		}
	}
}
