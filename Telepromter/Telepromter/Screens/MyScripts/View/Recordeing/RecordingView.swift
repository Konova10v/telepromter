//
//  RecordingView.swift
//  Telepromter
//
//  Created by Кирилл Коновалов on 13.08.2025.
//

import SwiftUI
import AVFoundation
import AVKit
import Combine

enum SettingType {
	case timer
	case fontSize
	case speed
	case mirror
}

// MARK: - Главный экран
struct RecordingView: View {
	@EnvironmentObject var telepromterViewModel: TelepromterViewModel
	@StateObject private var capture = CaptureManager()
	@StateObject private var scroller = TeleprompterScroller()
	
	@State private var settings = TeleprompterSettings()
	@State private var showSettings = false
	@State private var countdown: Int? = nil
	
	// Позиция/масштаб блока
	@State private var blockOffset: CGSize = .zero
	@State private var blockScale: CGFloat = 1
	
	@State var settingType: SettingType = .timer
	
	@State private var blockPosition: CGSize = .zero
	@State private var blockSize: CGSize = CGSize(width: SizeScreen().width / 1.2,
												  height: SizeScreen().height / 2)
	
	// Скрипт (read-only)
	@State var script: String
	@State var aspect: VideoAspect
	
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		ZStack(alignment: .top) {
			// Камера на фоне
			CameraPreview(session: capture.session)
				.ignoresSafeArea()
				.onAppear { capture.requestPermissionsAndStart() }
			
			// Верх: таймер записи
			if capture.isRecording {
				HStack {
					Text(timeString(capture.duration))
						.font(.system(size: 14, weight: .bold))
						.padding(.horizontal, 10).padding(.vertical, 6)
						.background(.black.opacity(0.7))
						.clipShape(Capsule())
						.foregroundColor(.white)
					Spacer()
				}
				.padding(.top, 18)
				.padding(.horizontal, 14)
				.transition(.opacity)
			}
			
			// Окно телесуфлера (как в макете)
			TeleprompterBlock(
				position: $blockPosition,
				size: $blockSize,
				script: script,
				settings: TeleprompterSettings(fontSize: settings.fontSize,
											   isMirrored: settings.isMirrored), isScrolling: capture.isRecording
			)
			.padding(.top)
			
			// Низ: панель управления (иконки без подписей)
			VStack {
				Spacer()
				
				if showSettings {
					VStack(spacing: 0) {
						VStack {
							HStack {
								switch settingType {
									case .timer:
										Text("Сountdown")
											.font(.labelMedium)
											.foregroundStyle(.white)
									case .fontSize:
										Text("Font Size")
											.font(.labelMedium)
											.foregroundStyle(.white)
									case .speed:
										Text("Speed")
											.font(.labelMedium)
											.foregroundStyle(.white)
									case .mirror:
										Text("Mirror")
											.font(.labelMedium)
											.foregroundStyle(.white)
								}
								
								Spacer()
								
								Button {
									showSettings = false
								} label: {
									Text("Done")
										.font(.labelMedium)
										.foregroundStyle(.primaryOrange)
								}
							}
							
							switch settingType {
								case .timer:
									StepSliderView(settings: $settings,
												   value: Double(settings.countdown),
												   range: 0...10,
												   settingType: settingType)
										.padding(.top, 30)
								case .fontSize:
									StepSliderView(settings: $settings,
												   value: settings.fontSize,
												   range: 0...100,
												   settingType: settingType)
										.padding(.top, 30)
								case .speed:
									StepSliderView(settings: $settings,
												   value: settings.scrollSpeed,
												   range: 0...100,
												   settingType: settingType)
										.padding(.top, 30)
								case .mirror:
									if settings.isMirrored {
										Button(action: {
											settings.isMirrored.toggle()
										}) {
											HStack {
												Spacer()
												
												Image(.mirrorRight)
													.foregroundColor(.white)
												
												Spacer()
											}
											.frame(maxWidth: .infinity)
											.padding(.vertical, 15)
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
										}
									} else {
										Button {
											settings.isMirrored.toggle()
										} label: {
											HStack {
												Spacer()
												
												Image(.mirrorRight)
													.foregroundColor(.white)
												
												Spacer()
											}
											.frame(maxWidth: .infinity)
											.padding(.vertical, 15)
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
										}
									}
							}
						}
						.padding(.horizontal, 20)
						.padding(.top, 25)
						.padding(.bottom, 20)
						.background(Color.black)
						.clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
						
						ZStack {
							ZStack {
								Image(.darkBkg)
									.resizable()
									.frame(width: SizeScreen().width, height: 90)
								
								Image(.recordBkg)
									.resizable()
									.frame(width: SizeScreen().width, height: 90)
							}
							
							HStack(spacing: 3) {
								Button {
									settingType = .timer
								} label: {
									ZStack {
										Image(.settingBtnBkg)
											.hidden(settingType == .timer ? false : true)
										Image(.timer)
											.resizable()
											.frame(width: 24, height: 24)
											.foregroundColor(.neutralGrey)
									}
								}
								
								Spacer()
								
								Button {
									settingType = .fontSize
								} label: {
									ZStack {
										Image(.settingBtnBkg)
											.hidden(settingType == .fontSize ? false : true)
										Image(.fontSize)
											.resizable()
											.frame(width: 24, height: 24)
											.foregroundColor(.neutralGrey)
									}
								}
								
								Spacer()
								
								Button {
									settingType = .speed
								} label: {
									ZStack {
										Image(.settingBtnBkg)
											.hidden(settingType == .speed ? false : true)
										Image(.speed)
											.resizable()
											.frame(width: 24, height: 24)
											.foregroundColor(.neutralGrey)
									}
								}
								
								Spacer()
								
								Button {
									settingType = .mirror
								} label: {
									ZStack {
										Image(.settingBtnBkg)
											.hidden(settingType == .mirror ? false : true)
										Image(.mirrorRight)
											.resizable()
											.frame(width: 24, height: 24)
											.foregroundColor(.neutralGrey)
									}
								}
							}
							.padding(.horizontal, 40)
						}
						.frame(width: SizeScreen().width)
					}
				} else {
					controlBar
				}
			}
			.padding(.bottom, 14)
			
			// Центр: обратный отсчёт
			if let v = countdown {
				VStack {
					Spacer()
					
					Text("\(max(0, v))")
						.font(.system(size: SizeScreen().width / 1.5, weight: .medium, design: .default))
						.foregroundColor(.white)
						.shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 2)
						.transition(.opacity)
					
					Spacer()
				}
			}
		}
		.onChange(of: settings.scrollSpeed) { new in scroller.speed = new }
		// Превью записанного видео
		.sheet(item: $telepromterViewModel.preview) { item in
			PreviewView(videoURL: item.url, script: script, aspect: aspect)
		}
		.navigationBarHidden(true)
	}
	
	// MARK: - Панель управления
	private var controlBar: some View {
		ZStack {
			ZStack {
				Image(.darkBkg)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
				
				Image(.recordBkg)
					.resizable()
					.frame(width: SizeScreen().width, height: 90)
			}
			
			HStack(spacing: 28) {
				// Слева: Назад / Пауза-Продолжить
				Button {
					if capture.isRecording {
						capture.toggleCamera()
					} else {
						dismiss()
					}
				} label: {
					Image(capture.isRecording ? .toggleCamera : .arrowLeft)
				}
				
				Spacer()
				
				// Центр: Старт/Стоп
				Button {
					if capture.isRecording {
						UIApplication.shared.isIdleTimerDisabled = false
						scroller.pause()
						capture.isRecording = false
						capture.stopAll { url in
							if let url {
								   DispatchQueue.main.async {   // гарантируем обновление UI
									   telepromterViewModel.cropVideo(inputURL: url, aspect: aspect) { url in
										   telepromterViewModel.preview = PreviewItem(url: url)
										   }
								   }
							   }
						}
					} else {
						UIApplication.shared.isIdleTimerDisabled = true
						startCountdownThenRecord()
					}
				} label: {
					Image(capture.isRecording  ? .recordOff : .record)
				}
				
				Spacer()
				
				// Справа: Настройки / Переключение камеры
				Button {
					if capture.isRecording {
						capture.pause()
					} else {
						showSettings = true
					}
				} label: {
					Image(capture.isRecording ? .pause : .recordSetting)
				}
			}
			.padding(.horizontal, 40)
		}
	}
	
	// MARK: - Обратный отсчёт и старт
	private func startCountdownThenRecord() {
		countdown = settings.countdown
		if settings.countdown == 0 {
			countdown = nil
			beginRecording()
			capture.isRecording = true
			return
		}
		Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
			guard var v = countdown else { t.invalidate(); return }
			if v > 1 { v -= 1; countdown = v }
			else { t.invalidate(); countdown = nil; beginRecording() }
		}
	}
	private func beginRecording() {
		scroller.speed = settings.scrollSpeed
		scroller.play()
		capture.startSegment()
	}
	
	// MARK: - Helpers
	private func timeString(_ t: TimeInterval) -> String {
		let m = Int(t) / 60, s = Int(t) % 60
		return String(format: "%02d:%02d", m, s)
	}
}

// MARK: - Модификатор принудительного смещения ScrollView (iOS 16-friendly)
private struct ContentOffsetModifier: ViewModifier {
	let y: CGFloat
	func body(content: Content) -> some View {
		content.background(OffsetHost(y: y))
	}
	private struct OffsetHost: UIViewRepresentable {
		let y: CGFloat
		func makeUIView(context: Context) -> UIScrollView { UIScrollView() }
		func updateUIView(_ uiView: UIScrollView, context: Context) {
			DispatchQueue.main.async {
				if let sv = findScrollView(in: uiView.superview) {
					let off = CGPoint(x: 0, y: y)
					if sv.contentOffset != off { sv.setContentOffset(off, animated: false) }
				}
			}
		}
		private func findScrollView(in view: UIView?) -> UIScrollView? {
			guard let v = view else { return nil }
			if let sv = v as? UIScrollView { return sv }
			for s in v.subviews { if let r = findScrollView(in: s) { return r } }
			return nil
		}
	}
}
private extension View {
	func contentOffset(y: CGFloat) -> some View { modifier(ContentOffsetModifier(y: max(0, y))) }
}

// MARK: - Preview
struct TeleprompterView_Previews: PreviewProvider {
	static var previews: some View {
		RecordingView(script: "", aspect: .fiveFour)
			.preferredColorScheme(.dark)
	}
}

extension View {
	@ViewBuilder
	func hidden(_ shouldHide: Bool) -> some View {
		if shouldHide {
			self.hidden() // сохраняет место в layout
		} else {
			self
		}
	}
}

struct StepSliderView: View {
	@Binding var settings: TeleprompterSettings
	
	@State var value: Double
	@State var range: ClosedRange<Double>
	@State var settingType: SettingType
	let step: Double = 1
	
	var body: some View {
		HStack(spacing: 16) {
			
			// MINUS BUTTON
			Button(action: {
				if value > range.lowerBound {
					value -= step
					
					switch settingType {
						case .timer:
							settings.countdown -= Int(step)
						case .fontSize:
							settings.fontSize -= step
						case .speed:
							settings.scrollSpeed  -= step
						case .mirror:
							print("")
					}
				}
			}) {
				Image(.minusButton)
			}
			
			ZStack(alignment: .leading) {
				// SLIDER TRACK
				Capsule()
					.fill(Color.gray.opacity(0.3))
					.frame(height: 8)
				
				// SLIDER FILL
				Capsule()
					.fill(Color.primaryOrange)
					.frame(width: CGFloat(value / range.upperBound) * 250, height: 8)
				
				// KNOB + BUBBLE
				GeometryReader { geo in
					let sliderWidth = geo.size.width
					let progress = value / range.upperBound
					let knobX = progress * sliderWidth
					
					ZStack {
						// Bubble with value
						Text("\(Int(value))")
							.font(.labelMedium)
							.foregroundColor(.white)
							.padding(.horizontal, 13)
							.padding(.vertical, 5)
							.background(
								Capsule()
									.fill(LinearGradient(
										colors: [Color.red, Color.orange],
										startPoint: .topLeading,
										endPoint: .bottomTrailing
									))
							)
							.offset(y: -35)
						
						// Knob
						Circle()
							.fill(Color.white)
							.frame(width: 20, height: 20)
							.shadow(radius: 2)
					}
					.position(x: knobX, y: 10)
					.gesture(
						DragGesture()
							.onChanged { gesture in
								let newValue = Double(gesture.location.x / sliderWidth) * range.upperBound
								value = min(max(range.lowerBound, newValue), range.upperBound)
								
								switch settingType {
									case .timer:
										settings.countdown = Int(value)
									case .fontSize:
										settings.fontSize = value
									case .speed:
										settings.scrollSpeed = value
									case .mirror:
										print("")
								}
							}
					)
				}
			}
			.frame(height: 20)
			
			// PLUS BUTTON
			Button(action: {
				if value < range.upperBound {
					value += step
					
					switch settingType {
						case .timer:
							settings.countdown += Int(step)
						case .fontSize:
							settings.fontSize += step
						case .speed:
							settings.scrollSpeed += step
						case .mirror:
							print("")
					}
				}
			}) {
				Image(.plusButton)
			}
		}
	}
}

struct TeleprompterBlock: View {
	@Binding var position: CGSize
	@State private var dragOffset: CGSize = .zero
	
	@Binding var size: CGSize
	@State private var resizeOffset: CGSize = .zero
	
	var script: String
	var settings: TeleprompterSettings
	
	// управление скроллом снаружи
	var isScrolling: Bool
	
	@State private var scrollOffset: CGFloat = 0
	@State private var timer: Timer?
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			ZStack(alignment: .topLeading) {
				RoundedRectangle(cornerRadius: 16)
					.fill(Color.black.opacity(0.38))
				
				ScrollView(.vertical, showsIndicators: false) {
					Text(script)
						.font(.system(size: settings.fontSize, weight: .semibold))
						.foregroundColor(.white)
						.lineSpacing(4)
						.multilineTextAlignment(.leading)
						.frame(maxWidth: .infinity, alignment: .leading)
						.padding(16)
						.scaleEffect(x: settings.isMirrored ? -1 : 1, y: 1)
						.animation(.easeInOut(duration: 0.2), value: settings.isMirrored)
						.offset(y: scrollOffset)
				}
				.clipShape(RoundedRectangle(cornerRadius: 16))
				.disabled(true) // 🚫 запрет ручного скролла
				
				Image(.moveScript)
					.padding(8)
					.offset(x: -25, y: -25)
			}
			.frame(width: size.width + resizeOffset.width,
				   height: size.height + resizeOffset.height)
			
			Image(.sizeScript)
				.padding(8)
				.gesture(
					DragGesture()
						.onChanged { value in
							resizeOffset = value.translation
						}
						.onEnded { value in
							size.width = max(150, size.width + value.translation.width)
							size.height = max(150, size.height + value.translation.height)
							resizeOffset = .zero
						}
				)
				.offset(x: 25, y: 25)
		}
		.offset(x: position.width + dragOffset.width,
				y: position.height + dragOffset.height)
		.gesture(
			DragGesture()
				.onChanged { value in
					dragOffset = value.translation
				}
				.onEnded { value in
					position.width += value.translation.width
					position.height += value.translation.height
					dragOffset = .zero
				}
		)
		.onChange(of: isScrolling) { newValue in
			if newValue {
				startAutoScroll()
			} else {
				stopAutoScroll()
			}
		}
	}
	
	// MARK: - Автопрокрутка
	private func startAutoScroll() {
		scrollOffset = 0
		stopAutoScroll()
		timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { _ in
			withAnimation(.linear(duration: 0.016)) {
				scrollOffset -= settings.scrollSpeed * 0.016
			}
		}
	}
	
	private func stopAutoScroll() {
		timer?.invalidate()
		timer = nil
	}
}
